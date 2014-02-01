//
//  RegisterStepOneViewController.m
//  Memetro
//
//  Created by Christian Bongardt on 10/09/13.
//  Copyright (c) 2013 memetro. All rights reserved.
//

#import "RegisterStepOneViewController.h"
#import "RegisterStepTwoViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "RobotoTextfieldReplacementLabel.h"
@implementation RegisterStepOneViewController

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goToStepTwo:(id)sender{
    RegisterStepTwoViewController *r = [[RegisterStepTwoViewController alloc] initWithNibName:@"RegisterStepTwoViewController" bundle:nil];
    r.name = self.name.text;
    r.twitter = self.twittername.text;
    r.email = self.email.text;
    r.aboutme = self.aboutme.text;
    if([self.email.text length] == 0){
        [CommonFunctions showError:NSLocalizedString(@"Please be advised that if you don't provide an E-mail address you won't be able to restore your password in case of loosing it. You can also provide your E-mail adress later on.", @"") withTitle:NSLocalizedString(@"Warning!", @"") withDismissHandler:^(SIAlertView *alertView) {
            [self.navigationController pushViewController:r animated:YES];
        }];
    }else{
        [self.navigationController pushViewController:r animated:YES];
    }
    
}

-(void) setupLayout{
    if(IS_IPHONE_5){
        self.formContainerHeightConstraint.constant = 566;
    }else{
        self.formContainerHeightConstraint.constant = 478;
    }
    self.name.placeholder = NSLocalizedString(@"Name", @"");
    self.twittername.text = NSLocalizedString(@"Twitter username", @"");
    self.twittername.userInteractionEnabled = YES;
    [self.twittername addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadTwitterUsername)]];
    self.email.placeholder =NSLocalizedString(@"Email", @"");
    self.aboutme.placeholder = NSLocalizedString(@"Biography", @"");
    [self.nextButton setTitle:NSLocalizedString(@"Skip this step",@"") forState:UIControlStateNormal];
    [self.nextButton setTitle:NSLocalizedString(@"Skip this step",@"") forState:UIControlStateHighlighted];
    
    [self.cancelButton setTitle:NSLocalizedString(@"Cancel", @"") forState:UIControlStateNormal];
    [self.cancelButton setTitle:NSLocalizedString(@"Cancel", @"") forState:UIControlStateHighlighted];
}




- (IBAction)cancel:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}




- (void)registerForKeyboardNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification{
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
- (void)keyboardWillBeHidden:(NSNotification*)aNotification{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
}


#pragma mark - TextfieldDelegate

-(void) loadTwitterUsername{
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error){
        [self resignFirstResponder];
        if (granted) {
            NSArray *accounts = [accountStore accountsWithAccountType:accountType];
            // Check if the users has setup at least one Twitter account
            if (accounts.count > 0){
                ACAccount *twitterAccount = [accounts objectAtIndex:0];
                [self setTwitternameText:twitterAccount.username];
            }else{
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [CommonFunctions showError:NSLocalizedString(@"You do not have any twitter accounts. Please add them from the iPhone settings.", @"") withTitle:NSLocalizedString(@"No twitter account!", @"") withDismissHandler:nil];
                });
                
                
            }
        }else{
            dispatch_sync(dispatch_get_main_queue(), ^{
                [CommonFunctions showError:NSLocalizedString(@"You declined the access to your Twitter Account. You can revise this settings in the Privacy settings of your phone.", @"") withTitle:NSLocalizedString(@"Access denied", @"") withDismissHandler:nil];
            });
            
        }
    }];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    if(textField.text.length != 0){
        [self.nextButton setTitle:NSLocalizedString(@"Next", @"") forState:UIControlStateNormal];
        [self.nextButton setTitle:NSLocalizedString(@"Next", @"") forState:UIControlStateHighlighted];
    }
    
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    _activeField = textField;
    
}

-(void) setTwitternameText:(NSString *) twittername{
    dispatch_sync(dispatch_get_main_queue(), ^{
        [CommonFunctions showError:NSLocalizedString(@"For security reasons we'll take your Twitter username from your Twitter Profile linked to your iPhone.", @"") withTitle:NSLocalizedString(@"Twitter username obtained!", @"") withDismissHandler:^(SIAlertView *alertView) {
            [self.nextButton setTitle:NSLocalizedString(@"Next", @"") forState:UIControlStateNormal];
            [self.nextButton setTitle:NSLocalizedString(@"Next", @"") forState:UIControlStateHighlighted];
            [((RobotoTextfieldReplacementLabel *)self.twittername) setPlaceholderEnabled:NO];
            self.twittername.text = [twittername stringByReplacingOccurrencesOfString:@"@" withString:@""];
        }];
    });
    NSLog(@"twittername %@",twittername);
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
    _activeField = nil;
}



@end
