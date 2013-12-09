//
//  ViewController.m
//  Memetro
//
//  Created by Christian Bongardt on 16/08/13.
//  Copyright (c) 2013 memetro. All rights reserved.
//

#import "LoginViewController.h"
#import "CBProgressPanel.h"
#import "RegisterStepOneViewController.h"
#import "ForgottenPasswordViewController.h"
@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setupLayout];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}


-(void) setupLayout{


    self.username.placeholder = NSLocalizedString(@"Username",@"");
    self.password.placeholder = NSLocalizedString(@"Password",@"");
    self.forgottenPassword.text = NSLocalizedString(@"Forgotten password?", @"");
    self.forgottenPassword.userInteractionEnabled = YES;
    [self.forgottenPassword addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showForgottenPassword)]];
    
    [self.loginButton setTitle: NSLocalizedString(@"Login", @"") forState:UIControlStateNormal];
    [self.loginButton setTitle: NSLocalizedString(@"Login", @"") forState:UIControlStateHighlighted];
    [self.registerButton setTitle:NSLocalizedString(@"Create account", @"") forState:UIControlStateNormal];
    [self.registerButton setTitle:NSLocalizedString(@"Create account", @"") forState:UIControlStateHighlighted];
    
}

-(void) showForgottenPassword{
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:[[ForgottenPasswordViewController alloc] init]] animated:YES completion:nil];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    if(textField == self.username){
        [self.password becomeFirstResponder];
    }
    return YES;
}

- (IBAction)login:(id)sender {
    if([self.username.text isEqualToString:@""]|| [self.password.text isEqualToString:@""]){
        [CommonFunctions showError:NSLocalizedString(@"All fields are mandatory! Please complete the missing data and try again!", @"") withTitle:NSLocalizedString(@"Empty fields", @"") withDismissHandler:nil];
        return;
    }
    [self.view endEditing:YES];
    [[CBProgressPanel sharedInstance] displayInView:self.view];
    [[NXOAuth2AccountStore sharedStore] requestAccessToAccountWithType:@"memetro"
                                                              username:self.username.text
                                                              password:self.password.text];
}

- (IBAction)createAccount:(id)sender {
    UINavigationController *n = [[UINavigationController alloc] initWithRootViewController:[[RegisterStepOneViewController alloc] initWithNibName:@"RegisterStepOneViewController" bundle:nil]];
    [n setNavigationBarHidden:YES];
    [self presentViewController:n animated:YES completion:nil];
}

@end
