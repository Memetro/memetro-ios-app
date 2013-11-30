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
    self.username.placeholder = NSLocalizedString(@"username",@"");
    self.password.placeholder = NSLocalizedString(@"password",@"");
    self.passwordConfirm.placeholder = NSLocalizedString(@"passwordconfirm",@"");
    self.country.placeholder = NSLocalizedString(@"Chose a country", @"");
    self.city.placeholder = NSLocalizedString(@"Chose a city", @"");
    
    [self.nextButton setTitle:NSLocalizedString(@"registerbutton",@"") forState:UIControlStateNormal];
    [self.nextButton setTitle:NSLocalizedString(@"registerbutton",@"") forState:UIControlStateHighlighted];
    
    [self.backbutton setTitle:NSLocalizedString(@"backbutton", @"") forState:UIControlStateNormal];
    [self.backbutton setTitle:NSLocalizedString(@"backbutton", @"") forState:UIControlStateHighlighted];
}

- (IBAction)register:(id)sender {
    if([self.username.text isEqualToString:@""] || [self.password.text isEqualToString:@""] || [self.passwordConfirm.text isEqualToString:@""]){
        [CommonFunctions showError:NSLocalizedString(@"loginemptypassuser", @"") withTitle:NSLocalizedString(@"incorrectdatatitle", @"") withDismissHandler:nil];
        return;
    }
    if(![self.passwordConfirm.text isEqualToString:self.password.text]){
        [CommonFunctions showError:NSLocalizedString(@"passmissmatchextended", @"") withTitle:NSLocalizedString(@"passmissmatch", @"") withDismissHandler:^(SIAlertView *alertView){
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
    [postData setObject:self.name forKey:@"name"];
    [postData setObject:self.email forKey:@"email"];
    [postData setObject:self.twitter forKey:@"twittername"];
    [postData setObject:self.aboutme forKey:@"aboutme"];
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
                       NSLog(@"full response %@",[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
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
                               [CommonFunctions showError:NSLocalizedString(@"registercompleted", @"") withTitle:NSLocalizedString(@"registercompletedtitle", @"")  withDismissHandler:^(SIAlertView * alertView){
                                   [self dismissViewControllerAnimated:YES completion:nil];
                               }];
                           }else{
                               [CommonFunctions showError:[parsedResponse objectForKey:@"message"] withTitle:[parsedResponse objectForKey:@"error_code"] withDismissHandler:nil];
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
        [textField resignFirstResponder];
        CityPickerViewController * c = [[CityPickerViewController alloc] init];
        c.countryID = self.countryID;
        c.delegate = self;
        [self presentViewController:[[UINavigationController alloc] initWithRootViewController:c] animated:YES completion:nil];
        return;
    }
    if(textField == self.country){
        [textField resignFirstResponder];
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
