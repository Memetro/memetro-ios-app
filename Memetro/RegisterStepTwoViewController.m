//
//  RegisterStepTwoViewController.m
//  Memetro
//
//  Created by Christian Bongardt on 10/09/13.
//  Copyright (c) 2013 memetro. All rights reserved.
//

// locale (es,en...) name email twittername aboutme


#import "RegisterStepTwoViewController.h"
#import "CBProgressPanel.h"
#import "Country.h"
#import "City.h"
#import "DataParser.h"

@interface RegisterStepTwoViewController ()

@end

@implementation RegisterStepTwoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupLayout];
    [self registerForKeyboardNotifications];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) setupLayout{
    if(IS_IPHONE_5){
        self.formContainerHeightConstraint.constant = 566;
    }else{
        self.formContainerHeightConstraint.constant = 478;
    }
    self.username.placeholder = NSLocalizedString(@"Username",@"");
    self.password.placeholder = NSLocalizedString(@"Password",@"");
    self.passwordConfirm.placeholder = NSLocalizedString(@"Confirm password",@"");
    self.country.placeholder = NSLocalizedString(@"Chose a country", @"");
    self.city.placeholder = NSLocalizedString(@"Chose a city", @"");
    
    [self.nextButton setTitle:NSLocalizedString(@"Create account",@"") forState:UIControlStateNormal];
    [self.nextButton setTitle:NSLocalizedString(@"Create account",@"") forState:UIControlStateHighlighted];
    
    [self.backbutton setTitle:NSLocalizedString(@"Back", @"") forState:UIControlStateNormal];
    [self.backbutton setTitle:NSLocalizedString(@"Back", @"") forState:UIControlStateHighlighted];
}

- (IBAction)register:(id)sender {
    [self resignFirstResponder];
    if([self.username.text isEqualToString:@""] || [self.password.text isEqualToString:@""] || [self.passwordConfirm.text isEqualToString:@""] || self.cityID == nil){
        [CommonFunctions showError:NSLocalizedString(@"Username and pasword are required fields", @"") withTitle:NSLocalizedString(@"Empty fields", @"") withDismissHandler:nil];
        return;
    }
    if(![self.passwordConfirm.text isEqualToString:self.password.text]){
        [CommonFunctions showError:NSLocalizedString(@"Both password must match. Please try again.", @"") withTitle:NSLocalizedString(@"Password missmatch", @"") withDismissHandler:^(SIAlertView *alertView){
            self.password.text = @"";
            self.passwordConfirm.text = @"";
        }];
        return;
    }
    NSString *lan = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSMutableDictionary *postData = [NSMutableDictionary new];
    [postData setObject:CLIENT_ID forKey:@"client_id"];
    [postData setObject:CLIENT_SECRET forKey:@"client_secret"];
    [postData setObject:self.username.text forKey:@"username"];
    [postData setObject:self.password.text forKey:@"password"];
    [postData setObject:self.passwordConfirm.text forKey:@"password2"];
    
    if(self.name != nil){
        [postData setObject:self.name forKey:@"name"];
    }
    if(self.email != nil){
        [postData setObject:self.email forKey:@"email"];
    }
    if (self.twitter != nil && ![self.twitter isEqualToString:NSLocalizedString(@"Twitter username", @"")]){
        [postData setObject:self.twitter forKey:@"twittername"];
    }
    if(self.aboutme != nil){
        [postData setObject:self.aboutme forKey:@"aboutme"];
    }
    
    [postData setObject:self.cityID forKey:@"city_id"];
    
    
    [postData setObject:lan forKey:@"locale"];
    [[CBProgressPanel sharedInstance] displayInView:self.view];
    [NXOAuth2Request performMethod:@"POST"
                        onResource:[CommonFunctions generateUrlWithParams:@"register"]
                   usingParameters:postData
                       withAccount:nil
               sendProgressHandler:nil
                   responseHandler:^(NSURLResponse *response, NSData *responseData, NSError *error){
                       [[CBProgressPanel sharedInstance] hide];
                       if(error !=nil){
                           NSLog(@"error user info: %@",[error userInfo]);

                           if([error code] == -1009){
                               [CommonFunctions showNoInternetError];
                           }else{
                               [CommonFunctions showGenericFetchError];
                           }
                       }else{
                           NSError *parseError = nil;
                           NSDictionary *parsedResponse = [NSJSONSerialization
                                                           JSONObjectWithData:responseData
                                                           options:0
                                                           error:&error];
                           if(parseError){
                               [CommonFunctions showGenericFetchError];
                           }else{
                               NSLog(@"Parsed response: %@",parsedResponse);
                               if([[parsedResponse objectForKey:@"success"] boolValue]){
                                   [CommonFunctions showError:NSLocalizedString(@"Congratulations! Your account has been created and you can now login to Memetro!", @"") withTitle:NSLocalizedString(@"Account created", @"")  withDismissHandler:^(SIAlertView * alertView){
                                       [self dismissViewControllerAnimated:YES completion:nil];
                                   }];
                               }else{
                                   NSString * errorCode =[parsedResponse objectForKey:@"error_code"];
                                   NSString *message;
                                   NSString *title = @"Error";
                                   
                                   if([errorCode isEqualToString:@"R001"]){
                                       message = NSLocalizedString(@"There is already a user with that username. Please chone another one.", @"");
                                    
                                       
                                   }else if([errorCode isEqualToString:@"R005"]){
                                       message = NSLocalizedString(@"The password requires a miniminum length of 5.", @"");
                                   }else if ([errorCode isEqualToString:@"R003"]){
                                       message = NSLocalizedString(@"Password missmatch.", @"");
                                   }
                                   
                                   [CommonFunctions showError:message withTitle:title withDismissHandler:nil];
                                   
                                   
                               }
                           }
                       }
                   }];
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, _activeField.frame.origin) ) {
        [self.scrollView scrollRectToVisible:_activeField.frame animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
}


#pragma mark - TextfieldDelegate

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    if(textField == self.username){
        [self.password becomeFirstResponder];
    }else if (textField == self.password){
        [self.passwordConfirm becomeFirstResponder];
    }else{
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if(textField == self.city){
        [self resignFirstResponder];
        CityPickerViewController * c = [[CityPickerViewController alloc] init];
        c.countryID = self.countryID;
        c.delegate = self;
        [self presentViewController:[[UINavigationController alloc] initWithRootViewController:c] animated:YES completion:nil];
        return;
    }
    if(textField == self.country){
        [self resignFirstResponder];
        CountryPickerViewController * c = [[CountryPickerViewController alloc] init];
        c.delegate = self;
        [self presentViewController:[[UINavigationController alloc] initWithRootViewController:c] animated:YES completion:nil];
        return;
    }
    _activeField = textField;
}



- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _activeField = nil;
}


-(void) userDidPickCountry:(Country *)country{
    self.countryID = country.id;
    self.country.text = country.name;
    if(self.cityID != nil){
        City *c = [[DataParser sharedInstance] getCity:self.cityID];
        if(c.country_id != country.id){
            self.cityID = nil;
            self.city.text = nil;
            
        }
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) userDidPickCity:(City *)city{
    self.cityID = city.id;
    self.city.text = city.name;
    Country *c = [[DataParser sharedInstance] getCountryWithId:city.country_id];
    self.country.text = c.name;
    self.countryID = c.id;
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
