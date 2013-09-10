//
//  RegisterStepOneViewController.m
//  Memetro
//
//  Created by Christian Bongardt on 10/09/13.
//  Copyright (c) 2013 memetro. All rights reserved.
//

#import "RegisterStepOneViewController.h"
#import "RegisterStepTwoViewController.h"


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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goToStepTwo:(id)sender {
    if([self.username.text isEqualToString:@""] || [self.password.text isEqualToString:@""] || [self.passwordConfirm.text isEqualToString:@""]){
        SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:NSLocalizedString(@"incorrectdatatitle", @"") andMessage:NSLocalizedString(@"loginemptypassuser", @"")];
        [alertView addButtonWithTitle:NSLocalizedString(@"okbutton", @"")
                                 type:SIAlertViewButtonTypeCancel
                              handler:nil];
        alertView.transitionStyle = SIAlertViewTransitionStyleDropDown;
        [alertView show];
        return;
    }
    if(![self.passwordConfirm.text isEqualToString:self.password.text]){
        SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:NSLocalizedString(@"passmissmatch", @"") andMessage:NSLocalizedString(@"passmissmatchextended", @"")];
        [alertView addButtonWithTitle:NSLocalizedString(@"okbutton", @"")
                                 type:SIAlertViewButtonTypeCancel
                              handler:nil];
        alertView.transitionStyle = SIAlertViewTransitionStyleDropDown;
        [alertView show];
        alertView.willDismissHandler = ^(SIAlertView *alertView) {
            self.password.text = @"";
            self.passwordConfirm.text = @"";
        };
        return;
        
    }
    [self.navigationController pushViewController:[[RegisterStepTwoViewController alloc] initWithNibName:@"RegisterStepTwoViewController" bundle:nil] animated:YES];
}

-(void) setupLayout{
    self.nextButton.titleLabel.font = BUTTON_FONT;
    for (UITextField *t in self.inputs){
        t.font = TEXTFIELD_FONT;
        t.textColor = TEXTFIELD_COLOR;
        t.attributedPlaceholder = TEXTFIELD_PLACEHOLDER;
    }
    self.username.placeholder = NSLocalizedString(@"username",@"");
    self.password.placeholder = NSLocalizedString(@"password",@"");
    self.passwordConfirm.placeholder = NSLocalizedString(@"passwordconfirm",@"");

    [self.nextButton setTitle:NSLocalizedString(@"nextstep",@"") forState:UIControlStateNormal];
    [self.nextButton setTitle:NSLocalizedString(@"nextstep",@"") forState:UIControlStateHighlighted];
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.username){
        [self.password becomeFirstResponder];
    }else if (textField == self.password){
        [self.passwordConfirm becomeFirstResponder];
    }else{
        [textField resignFirstResponder];
    }
    return YES;
}

-(void) textFieldDidBeginEditing:(UITextField *)textField{
    if(!IS_IPHONE_5){
        if(textField == self.passwordConfirm){
            [CommonFunctions animateView:self.view withHeight:70 up:YES];
        }
    }
}
-(void) textFieldDidEndEditing:(UITextField *)textField{
    if(!IS_IPHONE_5){
        if(textField == self.passwordConfirm){
            [CommonFunctions animateView:self.view withHeight:70 up:NO];
        }
    }
    
}

@end
