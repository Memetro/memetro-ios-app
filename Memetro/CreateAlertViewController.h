//
//  CreateAlertViewController.h
//  Memetro
//
//  Created by Christian Bongardt on 30/11/13.
//  Copyright (c) 2013 memetro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CityPickerViewController.h"
#import "TransportPickerViewController.h"
#import "LinePickerViewController.h"
#import "StationPickerViewController.h"

@interface CreateAlertViewController : UIViewController <UITextFieldDelegate, CityPickerDelegate,TransportPickerDelegate,LinePickerDelegate,StationPickerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *alertButton;
@property (weak, nonatomic) IBOutlet UITextField *city;
@property (weak, nonatomic) IBOutlet UITextField *transport;
@property (weak, nonatomic) IBOutlet UITextField *line;
@property (weak, nonatomic) IBOutlet UITextField *station;
- (IBAction)save:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *formContainerHeightConstraint;

@property (strong,nonatomic) NSNumber *cityId;
@property (strong,nonatomic) NSNumber *transportId;
@property (strong,nonatomic) NSNumber *lineId;
@property (strong,nonatomic) NSNumber *stationId;


@end
