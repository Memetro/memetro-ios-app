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


    self.username.placeholder = NSLocalizedString(@"username",@"");
    self.password.placeholder = NSLocalizedString(@"password",@"");
    self.forgottenPassword.text = NSLocalizedString(@"forgottenpassword", @"contraseña olvidada");
    self.forgottenPassword.userInteractionEnabled = YES;
    [self.forgottenPassword addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showForgottenPassword)]];
    
    [self.loginButton setTitle: NSLocalizedString(@"loginbutton", @"boton login") forState:UIControlStateNormal];
    [self.loginButton setTitle: NSLocalizedString(@"loginbutton", @"boton login") forState:UIControlStateHighlighted];
    [self.registerButton setTitle:NSLocalizedString(@"registerbutton", @"boton de registro") forState:UIControlStateNormal];
    [self.registerButton setTitle:NSLocalizedString(@"registerbutton", @"boton de registro") forState:UIControlStateHighlighted];    
    
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
        [CommonFunctions showError:NSLocalizedString(@"loginemptypassuser", @"") withTitle:NSLocalizedString(@"incorrectdatatitle", @"") withDismissHandler:nil];
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
