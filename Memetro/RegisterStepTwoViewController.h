//
//  RegisterStepTwoViewController.h
//  Memetro
//
//  Created by Christian Bongardt on 10/09/13.
//  Copyright (c) 2013 memetro. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CountryPickerViewController.h"
#import "CityPickerViewController.h"

@interface RegisterStepTwoViewController : UIViewController <UITextFieldDelegate,CountryPickerDelegate,CityPickerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *passwordConfirm;
@property (weak, nonatomic) IBOutlet UITextField *country;
@property (weak, nonatomic) IBOutlet UITextField *city;

@property (weak, nonatomic) IBOutlet UIButton *backbutton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *formContainerHeightConstraint;

@property (strong,nonatomic) UITextField *activeField;

- (IBAction)back:(id)sender;
- (IBAction)register:(id)sender;
@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) NSString *twitter;
@property (strong,nonatomic) NSString *email;
@property (strong,nonatomic) NSString *aboutme;
@property (strong,nonatomic) NSNumber *countryID;
@property (strong,nonatomic) NSNumber *cityID;

@end
