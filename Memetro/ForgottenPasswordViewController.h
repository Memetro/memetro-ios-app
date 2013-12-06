//
//  ForgottenPasswordViewController.h
//  Memetro
//
//  Created by Christian Bongardt on 06/12/13.
//  Copyright (c) 2013 memetro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgottenPasswordViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UILabel *desscription;
- (IBAction)restore:(id)sender;
@end
