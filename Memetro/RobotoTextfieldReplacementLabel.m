//
//  RobotoTextfieldReplacementLabel.m
//  Memetro
//
//  Created by Christian Bongardt on 23/12/13.
//  Copyright (c) 2013 memetro. All rights reserved.
//

#import "RobotoTextfieldReplacementLabel.h"

@implementation RobotoTextfieldReplacementLabel

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
    self.textColor =[UIColor colorWithRed:0.78f green:0.78f blue:0.80f alpha:1.00f];
}

-(void) setPlaceholderEnabled:(BOOL) enabled{
    if(enabled){
        self.textColor =[UIColor colorWithRed:0.78f green:0.78f blue:0.80f alpha:1.00f];
    }else{
        self.textColor = [UIColor colorWithRed:0.49f green:0.49f blue:0.49f alpha:1.00f];
    }

    
}

@end
