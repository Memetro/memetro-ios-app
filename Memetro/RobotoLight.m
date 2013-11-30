//
//  RobotoLight.m
//  Memetro
//
//  Created by Christian Bongardt on 30/11/13.
//  Copyright (c) 2013 memetro. All rights reserved.
//

#import "RobotoLight.h"

@implementation RobotoLight

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) awakeFromNib{
    CGFloat pointSize = self.font.pointSize;
    self.font =[UIFont fontWithName:@"Roboto-Light" size:pointSize];
}


@end
