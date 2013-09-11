//
//  RegisterStepOneViewController.h
//  Memetro
//
//  Created by Christian Bongardt on 10/09/13.
//  Copyright (c) 2013 memetro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterStepOneViewController : UIViewController<UITextFieldDelegate>
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *inputs;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
- (IBAction)goToStepTwo:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *twittername;
@property (weak, nonatomic) IBOutlet UITextField *aboutme;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
- (IBAction)cancel:(id)sender;
@end
