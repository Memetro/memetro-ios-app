//
//  RedButton.m
//  Memetro
//
//  Created by Christian Bongardt on 30/11/13.
//  Copyright (c) 2013 memetro. All rights reserved.
//

#import "RedButton.h"

@implementation RedButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(void) awakeFromNib{
    [self setBackgroundImage:[UIImage imageNamed:@"red-button"] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageNamed:@"red-button-pressed"] forState:UIControlStateHighlighted];
    self.titleLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:16];
    self.titleLabel.textColor = [UIColor whiteColor];
}

@end
