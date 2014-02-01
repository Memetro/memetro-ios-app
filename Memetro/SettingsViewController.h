//
//  SettingsViewController.h
//  Memetro
//
//  Created by Christian Bongardt on 30/11/13.
//  Copyright (c) 2013 memetro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "CountryPickerViewController.h"
#import "CityPickerViewController.h"
@interface SettingsViewController : BaseViewController <UITextFieldDelegate,CityPickerDelegate,CountryPickerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UILabel *twitter;
@property (weak, nonatomic) IBOutlet UILabel *country;
@property (weak, nonatomic) IBOutlet UILabel *city;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong,nonatomic) UITextField *activeField;
@property (strong,nonatomic) NSNumber *countryID;
@property (strong,nonatomic) NSNumber *cityID;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

- (IBAction)save:(id)sender;
@end
