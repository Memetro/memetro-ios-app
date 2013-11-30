//
//  RobotoTextfield.m
//  Memetro
//
//  Created by Christian Bongardt on 30/11/13.
//  Copyright (c) 2013 memetro. All rights reserved.
//

#import "RobotoTextfield.h"

@implementation RobotoTextfield

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) awakeFromNib{
    self.font = [UIFont fontWithName:@"Roboto-Light" size:16];
    self.textColor = [UIColor colorWithRed:0.49f green:0.49f blue:0.49f alpha:1.00f];
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.49f green:0.49f blue:0.49f alpha:1.00f],NSFontAttributeName:[UIFont fontWithName:@"Roboto-Light" size:16] }];
}

@end
