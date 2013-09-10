//
//  CBProgressPanel.m
//  Memetro
//
//  Created by Christian Bongardt on 09/09/13.
//  Copyright (c) 2013 memetro. All rights reserved.
//

#import "CBProgressPanel.h"

@implementation CBProgressPanel


+ (instancetype)sharedInstance{
    static id sharedInstance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[[self class] alloc] init];
    });
    return sharedInstance;
}

-(id) init{
    self = [super init];
    UIImageView* animationView = [[UIImageView alloc] init];
    animationView.animationImages = [NSArray arrayWithObjects:
                                     [UIImage imageNamed:@"anim-1"],
                                     [UIImage imageNamed:@"anim-2"],
                                     [UIImage imageNamed:@"anim-3"],
                                     [UIImage imageNamed:@"anim-4"],
                                     [UIImage imageNamed:@"anim-5"],
                                     nil];
    animationView.animationDuration = 0.8f;
    animationView.animationRepeatCount = 0;
    [animationView startAnimating];
    self.animationView = animationView;
    [self setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:.3f]];
    return self;
}


-(void) displayInView:(UIView *) view{
    self.animationView.frame = CGRectMake(0, 0, view.frame.size.width, 3.0f);
    [self addSubview:self.animationView];
    [view addSubview:self];
}

-(void) hide{
    [self.animationView removeFromSuperview];
    [self removeFromSuperview];
}


@end
