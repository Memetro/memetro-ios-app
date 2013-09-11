//
//  RegisterStepTwoViewController.h
//  Memetro
//
//  Created by Christian Bongardt on 10/09/13.
//  Copyright (c) 2013 memetro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterStepTwoViewController : UIViewController
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *inputs;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
- (IBAction)register:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *passwordConfirm;
@property (weak, nonatomic) IBOutlet UIButton *backbutton;
- (IBAction)back:(id)sender;

@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) NSString *twitter;
@property (strong,nonatomic) NSString *email;
@property (strong,nonatomic) NSString *aboutme;

@end
