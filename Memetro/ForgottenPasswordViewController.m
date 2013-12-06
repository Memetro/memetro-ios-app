//
//  ForgottenPasswordViewController.m
//  Memetro
//
//  Created by Christian Bongardt on 06/12/13.
//  Copyright (c) 2013 memetro. All rights reserved.
//

#import "ForgottenPasswordViewController.h"
#import "CommonFunctions.h"
#import "CBProgressPanel.h"

@interface ForgottenPasswordViewController ()

@end

@implementation ForgottenPasswordViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)restore:(id)sender {
    if([self.email.text length ] == 0){
        [CommonFunctions showError:NSLocalizedString(@"The Email address is required", @"") withTitle:NSLocalizedString(@"Required fields", @"") withDismissHandler:nil];
        return;
    }
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
@end
