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
    self.nextButton.titleLabel.font = BUTTON_FONT;
    self.cancelButton.titleLabel.font = BUTTON_FONT;
    for (UITextField *t in self.inputs){
        t.font = TEXTFIELD_FONT;
        t.textColor = TEXTFIELD_COLOR;
        t.attributedPlaceholder = TEXTFIELD_PLACEHOLDER;
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

-(void) textFieldDidBeginEditing:(UITextField *)textField{
    if(IS_IPHONE_5){
        if(textField == self.aboutme){
            [CommonFunctions animateView:self.view withHeight:25 up:YES];
        }
        
    }else{
        if(textField == self.email){
            [CommonFunctions animateView:self.view withHeight:15 up:YES];
        }
        if(textField == self.twittername){
            [CommonFunctions animateView:self.view withHeight:65 up:YES];
        }
        if(textField == self.aboutme){
            [CommonFunctions animateView:self.view withHeight:115 up:YES];
        }
    }

}

-(void) textFieldDidEndEditing:(UITextField *)textField{
    if(![textField.text isEqualToString:@""]){
        [self.nextButton setTitle:NSLocalizedString(@"nextstep",@"") forState:UIControlStateNormal];
        [self.nextButton setTitle:NSLocalizedString(@"nextstep",@"") forState:UIControlStateHighlighted];
    }
    if(IS_IPHONE_5){
        if(textField == self.aboutme){
            [CommonFunctions animateView:self.view withHeight:25 up:NO];
        }
    }else{
        if(textField == self.email){
            [CommonFunctions animateView:self.view withHeight:15 up:NO];
        }
        if(textField == self.twittername){
            [CommonFunctions animateView:self.view withHeight:65 up:NO];
        }
        if(textField == self.aboutme){
            [CommonFunctions animateView:self.view withHeight:115 up:NO];
        }
    }

}
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    if(textField == self.name){
        [self.email becomeFirstResponder];
    }
    if(textField == self.email){
        [self.twittername becomeFirstResponder];
    }
    if (textField == self.twittername){
        [self.aboutme becomeFirstResponder];
    }else{
        [textField resignFirstResponder];
    }
    return YES;
}


- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
