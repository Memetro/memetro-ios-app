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

    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    [self.button setTitle: NSLocalizedString(@"Request token", @"") forState:UIControlStateNormal];
    self.desscription.text = NSLocalizedString(@"In order to restore your password you had to provide your Email either in the registration form or in the settings section of the app. Enter your email in the text field and request a token. You will get a mail with a link in it. Follow the link and complete the process to restore your password. ", @"");
    self.email.placeholder = NSLocalizedString(@"Email", @"");
}

-(void) cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
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
    [[CBProgressPanel sharedInstance] displayInView:self.view];
    [NXOAuth2Request performMethod:@"POST"
                        onResource:[CommonFunctions generateUrlWithParams:@"register/recoverPassword"]
                   usingParameters:@{@"email":self.email.text,@"client_id":CLIENT_ID,@"client_secret":CLIENT_SECRET}
                       withAccount:[CommonFunctions useraccount]
               sendProgressHandler:nil
                   responseHandler:^(NSURLResponse *response, NSData *responseData, NSError *error) {
                       [[CBProgressPanel sharedInstance] hide];
                       NSLog(@"repsonse %@",response);
                       if(error == nil){
                           
                           NSError *errorJson = nil;
                           NSDictionary *dic= [NSJSONSerialization
                                               JSONObjectWithData:responseData
                                               options:0
                                               error:&errorJson];
                           if([[dic objectForKey:@"success"] boolValue]){
                               [CommonFunctions showError:NSLocalizedString(@"You will get an email with the token! Also check your spam folder.", @"") withTitle:NSLocalizedString(@"Success!", @"") withDismissHandler:^(SIAlertView *alertView) {
                                   [self dismissViewControllerAnimated:YES completion:nil];
                               }];
                           }else{
                               [CommonFunctions showError:NSLocalizedString(@"We can't find any account with that email address.", @"") withTitle:NSLocalizedString(@"Error", @"") withDismissHandler:nil];
                           }
                    
                       }else{
                           if([error code] == -1009){
                               [CommonFunctions showNoInternetError];
                               return;
                           }
                           [CommonFunctions showGenericFetchError];
                       }
                       NSLog(@"Response data %@",[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
                       
                   }];

}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
@end
