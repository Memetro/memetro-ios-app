//
//  SettingsViewController.m
//  Memetro
//
//  Created by Christian Bongardt on 30/11/13.
//  Copyright (c) 2013 memetro. All rights reserved.
//

#import "SettingsViewController.h"
#import "DataParser.h"
#import "User.h"
#import "City.h"
#import "Country.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupLayout];
    [self registerForKeyboardNotifications];
}

-(void) setupLayout{
    self.name.placeholder = NSLocalizedString(@"Name", @"");
    self.email.placeholder = NSLocalizedString(@"Email", @"");
    self.twitter.placeholder = NSLocalizedString(@"Twitter", @"");
    self.country.placeholder = NSLocalizedString(@"Country", @"");
    self.city.placeholder = NSLocalizedString(@"City", @"");
    [self.saveButton setTitle:NSLocalizedString(@"Save", @"") forState:UIControlStateNormal];
    [self.saveButton setTitle:NSLocalizedString(@"Save", @"") forState:UIControlStateHighlighted];
    
    User *u = [[DataParser sharedInstance] getUser];
    self.name.text = u.name;
    self.email.text = u.email;
    self.twitter.text = u.twittername;
    City *city = [[DataParser sharedInstance] getCity:u.city_id];
    Country *country = [[DataParser sharedInstance] getCountryWithId:city.country_id];
    self.cityID = city.id;
    self.countryID = country.id;
    self.country.text = country.name;
    self.city.text = city.name;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)save:(id)sender {
    if(self.cityID == nil){
        [CommonFunctions showError:NSLocalizedString(@"You must pick a City!", @"") withTitle:NSLocalizedString(@"Empty fields!", @"") withDismissHandler:nil];
        return;
    }
    [NXOAuth2Request performMethod:@"POST"
                        onResource:[CommonFunctions generateUrlWithParams:@"users/edit_user_data"]
                   usingParameters:@{@"name":self.name.text,@"email":self.email.text,@"twittername":self.twitter.text,@"city_id":self.cityID}
                       withAccount:[CommonFunctions useraccount]
               sendProgressHandler:nil
                   responseHandler:^(NSURLResponse *response, NSData *responseData, NSError *error){
                       [[CBProgressPanel sharedInstance] hide];
                       if(error !=nil){
                           if([error code] == -1009){
                               [CommonFunctions showNoInternetError];
                           }else{
                               [CommonFunctions showGenericFetchError];
                           }
                           
                       }else{
                           if([[DataParser sharedInstance] parseUserEdit:responseData]){
                               [CommonFunctions showError:NSLocalizedString(@"Your data has been updated", @"") withTitle:NSLocalizedString(@"Succesful", @"") withDismissHandler:nil];
                               
                           }else{
                               [CommonFunctions showGenericFetchError];
                               
                           }
                       }
                   }];
    
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
    if(textField == self.twitter) self.twitter.text = [self.twitter.text stringByReplacingOccurrencesOfString:@"@" withString:@""];
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField == self.city){
        [self resignFirstResponder];
        CityPickerViewController *c = [[CityPickerViewController alloc] init];
        c.delegate = self;
        c.countryID = self.countryID;
        [self presentViewController:[[UINavigationController alloc] initWithRootViewController:c] animated:YES completion:nil];
    }else if(textField == self.country){
        [self resignFirstResponder];
        CountryPickerViewController *c = [[CountryPickerViewController alloc] init];
        c.delegate = self;
        [self presentViewController:[[UINavigationController alloc] initWithRootViewController:c] animated:YES completion:nil];
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