//
//  CommonFunctions.m
//  Memetro
//
//  Created by Christian Bongardt on 10/09/13.
//  Copyright (c) 2013 memetro. All rights reserved.
//

#import "CommonFunctions.h"

@implementation CommonFunctions
+ (void) animateView: (UIView *)view withHeight:(int) height up: (BOOL) up {
    const float movementDuration = 0.25f;
    int movement = (up ? -height   : height);
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    view.frame = CGRectOffset(view.frame, 0, movement);
    [UIView commitAnimations];
}
@end
