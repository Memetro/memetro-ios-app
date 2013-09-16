//
//  RegisterStepTwoViewController.m
//  Memetro
//
//  Created by Christian Bongardt on 10/09/13.
//  Copyright (c) 2013 memetro. All rights reserved.
//

// locale (es,en...) name email twittername aboutme


#import "RegisterStepTwoViewController.h"
#import "CBProgressPanel.h"

@interface RegisterStepTwoViewController ()

@end

@implementation RegisterStepTwoViewController

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

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) setupLayout{
    self.nextButton.titleLabel.font = BUTTON_FONT;
    self.backbutton.titleLabel.font = BUTTON_FONT;
    for (UITextField *t in self.inputs){
        t.font = TEXTFIELD_FONT;
        t.textColor = TEXTFIELD_COLOR;
        t.attributedPlaceholder = TEXTFIELD_PLACEHOLDER;
    }
    self.username.placeholder = NSLocalizedString(@"username",@"");
    self.password.placeholder = NSLocalizedString(@"password",@"");
    self.passwordConfirm.placeholder = NSLocalizedString(@"passwordconfirm",@"");
    
    [self.nextButton setTitle:NSLocalizedString(@"registerbutton",@"") forState:UIControlStateNormal];
    [self.nextButton setTitle:NSLocalizedString(@"registerbutton",@"") forState:UIControlStateHighlighted];
    
    [self.backbutton setTitle:NSLocalizedString(@"backbutton", @"") forState:UIControlStateNormal];
    [self.backbutton setTitle:NSLocalizedString(@"backbutton", @"") forState:UIControlStateHighlighted];
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
        if(textField == self.password){
            [CommonFunctions animateView:self.view withHeight:25 up:YES];
        }
        if(textField == self.passwordConfirm){
            [CommonFunctions animateView:self.view withHeight:80 up:YES];
        }
    }
}
-(void) textFieldDidEndEditing:(UITextField *)textField{
    if(!IS_IPHONE_5){
        if(textField == self.password){
            [CommonFunctions animateView:self.view withHeight:25 up:NO];
        }
        if(textField == self.passwordConfirm){
            [CommonFunctions animateView:self.view withHeight:80 up:NO];
        }
    }
    
}

- (IBAction)register:(id)sender {
    if([self.username.text isEqualToString:@""] || [self.password.text isEqualToString:@""] || [self.passwordConfirm.text isEqualToString:@""]){
        [CommonFunctions showError:NSLocalizedString(@"loginemptypassuser", @"") withTitle:NSLocalizedString(@"incorrectdatatitle", @"") withDismissHandler:nil];
        return;
    }
    if(![self.passwordConfirm.text isEqualToString:self.password.text]){
        [CommonFunctions showError:NSLocalizedString(@"passmissmatchextended", @"") withTitle:NSLocalizedString(@"passmissmatch", @"") withDismissHandler:^(SIAlertView *alertView){
            self.password.text = @"";
            self.passwordConfirm.text = @"";
        }];
        return;
    }
    NSString *lan = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSMutableDictionary *postData = [NSMutableDictionary new];
    [postData setObject:CLIENT_ID forKey:@"client_id"];
    [postData setObject:CLIENT_SECRET forKey:@"client_secret"];
    [postData setObject:self.username.text forKey:@"username"];
    [postData setObject:self.password.text forKey:@"password"];
    [postData setObject:self.passwordConfirm.text forKey:@"password2"];
    [postData setObject:self.name forKey:@"name"];
    [postData setObject:self.email forKey:@"email"];
    [postData setObject:self.twitter forKey:@"twittername"];
    [postData setObject:self.aboutme forKey:@"aboutme"];
    [postData setObject:lan forKey:@"locale"];
    [[CBProgressPanel sharedInstance] displayInView:self.view];
    [NXOAuth2Request performMethod:@"POST"
                        onResource:[CommonFunctions generateUrlWithParams:@"register"]
                   usingParameters:postData
                       withAccount:nil
               sendProgressHandler:nil
               responseHandler:^(NSURLResponse *response, NSData *responseData, NSError *error){
                   [[CBProgressPanel sharedInstance] hide];
                   if(error !=nil){
                       NSLog(@"error user info: %@",[error userInfo]);
                       NSLog(@"full response %@",[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
                       if([error code] == -1009){
                           [CommonFunctions showNoInternetError];
                       }else{
                           [CommonFunctions showGenericFetchError];
                       }
                   }else{
                       NSError *parseError = nil;
                       NSDictionary *parsedResponse = [NSJSONSerialization
                                          JSONObjectWithData:responseData
                                          options:0
                                          error:&error];
                       if(parseError){
                           [CommonFunctions showGenericFetchError];
                       }else{
                           NSLog(@"Parsed response: %@",parsedResponse);
                           if([[parsedResponse objectForKey:@"success"] boolValue]){
                               [CommonFunctions showError:NSLocalizedString(@"registercompleted", @"") withTitle:NSLocalizedString(@"registercompletedtitle", @"")  withDismissHandler:^(SIAlertView * alertView){
                                   [self dismissViewControllerAnimated:YES completion:nil];
                               }];
                           }else{
                               [CommonFunctions showError:[parsedResponse objectForKey:@"message"] withTitle:[parsedResponse objectForKey:@"error_code"] withDismissHandler:nil];
                           }
                       }
                   }
               }];
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
