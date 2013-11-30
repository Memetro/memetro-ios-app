//
//  RobotoRegular.m
//  Memetro
//
//  Created by Christian Bongardt on 30/11/13.
//  Copyright (c) 2013 memetro. All rights reserved.
//

#import "RobotoRegular.h"

@implementation RobotoRegular

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
    self.font =[UIFont fontWithName:@"Roboto-Regular" size:pointSize];
}

@end
