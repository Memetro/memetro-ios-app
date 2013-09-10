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
    for(UITextField *t in self.textfields){
        t.font = TEXTFIELD_FONT;
        t.textColor = TEXTFIELD_COLOR;
        t.attributedPlaceholder = TEXTFIELD_PLACEHOLDER;
    }

    self.username.placeholder = NSLocalizedString(@"username",@"");
    self.password.placeholder = NSLocalizedString(@"password",@"");
    self.forgottenPassword.font = [UIFont fontWithName:@"Roboto-Light" size:12];
    self.forgottenPassword.text = NSLocalizedString(@"forgottenpassword", @"contraseña olvidada");
    
    for (UIButton *b in self.buttons){
        b.titleLabel.font = BUTTON_FONT;
    }
    
    [self.loginButton setTitle: NSLocalizedString(@"loginbutton", @"boton login") forState:UIControlStateNormal];
    [self.loginButton setTitle: NSLocalizedString(@"loginbutton", @"boton login") forState:UIControlStateHighlighted];
    [self.registerButton setTitle:NSLocalizedString(@"registerbutton", @"boton de registro") forState:UIControlStateNormal];
    [self.registerButton setTitle:NSLocalizedString(@"registerbutton", @"boton de registro") forState:UIControlStateHighlighted];    
    
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
        SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:NSLocalizedString(@"incorrectdatatitle", @"") andMessage:NSLocalizedString(@"loginemptypassuser", @"")];
        [alertView addButtonWithTitle:NSLocalizedString(@"okbutton", @"")
                                 type:SIAlertViewButtonTypeCancel
                              handler:nil];
        alertView.transitionStyle = SIAlertViewTransitionStyleDropDown;
        [alertView show];
        return;
    }
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
