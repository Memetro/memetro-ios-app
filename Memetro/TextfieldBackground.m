//
//  TextfieldBackground.m
//  Memetro
//
//  Created by Christian Bongardt on 30/11/13.
//  Copyright (c) 2013 memetro. All rights reserved.
//

#import "TextfieldBackground.h"
#import <QuartzCore/QuartzCore.h>


@implementation TextfieldBackground

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) awakeFromNib{
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor colorWithRed:0.53f green:0.53f blue:0.53f alpha:1.00f].CGColor;
    self.layer.cornerRadius = 2;
    self.backgroundColor =[UIColor colorWithRed:0.99f green:0.99f blue:0.99f alpha:1.00f];
}

@end
