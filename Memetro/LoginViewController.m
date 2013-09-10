//
//  ViewController.m
//  Memetro
//
//  Created by Christian Bongardt on 16/08/13.
//  Copyright (c) 2013 memetro. All rights reserved.
//

#import "LoginViewController.h"
#import "CBProgressPanel.h"
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
        t.font = [UIFont fontWithName:@"Roboto-Light" size:16];
        t.textColor = [UIColor colorWithRed:0.49f green:0.49f blue:0.49f alpha:1.00f];
        t.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.49f green:0.49f blue:0.49f alpha:1.00f],NSFontAttributeName:[UIFont fontWithName:@"Roboto-Light" size:16] }];
    }

    self.username.placeholder = NSLocalizedString(@"username",@"");
    self.password.placeholder = NSLocalizedString(@"password",@"");
    self.forgottenPassword.font = [UIFont fontWithName:@"Roboto-Light" size:12];
    self.forgottenPassword.text = NSLocalizedString(@"forgottenpassword", @"contraseña olvidada");
    
    for (UIButton *b in self.buttons){
        b.titleLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:16];
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
    [[CBProgressPanel sharedInstance] displayInView:self.view];
    [[NXOAuth2AccountStore sharedStore] requestAccessToAccountWithType:@"memetro"
                                                              username:self.username.text
                                                              password:self.password.text];
}
@end
