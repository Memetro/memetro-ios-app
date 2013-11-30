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
    [self.navigationController pushViewController:r animated:YES];
}

-(void) setupLayout{
    if(IS_IPHONE_5){
        self.formContainerHeightConstraint.constant = 566;
    }else{
        self.formContainerHeightConstraint.constant = 478;
    }


    self.name.placeholder = NSLocalizedString(@"registername", @"");
    self.twittername.placeholder = NSLocalizedString(@"registertwitter", @"");
    self.email.placeholder =NSLocalizedString(@"registeremail", @"");
    self.aboutme.placeholder = NSLocalizedString(@"registeraboutme", @"");
    [self.nextButton setTitle:NSLocalizedString(@"omitbutton",@"") forState:UIControlStateNormal];
    [self.nextButton setTitle:NSLocalizedString(@"omitbutton",@"") forState:UIControlStateHighlighted];
    
    [self.cancelButton setTitle:NSLocalizedString(@"cancelbutton", @"") forState:UIControlStateNormal];
    [self.cancelButton setTitle:NSLocalizedString(@"cancelbutton", @"") forState:UIControlStateHighlighted];

}




- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _activeField = nil;
}



@end
