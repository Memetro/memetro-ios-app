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
                                     [UIImage imageNamed:@"anim-bar-0"],
                                     [UIImage imageNamed:@"anim-bar-1"],
                                     [UIImage imageNamed:@"anim-bar-2"],
                                     [UIImage imageNamed:@"anim-bar-3"],
                                     [UIImage imageNamed:@"anim-bar-4"],
                                     [UIImage imageNamed:@"anim-bar-5"],
                                     [UIImage imageNamed:@"anim-bar-6"],
                                     [UIImage imageNamed:@"anim-bar-7"],
                                     [UIImage imageNamed:@"anim-bar-8"],
                                     [UIImage imageNamed:@"anim-bar-9"],
                                     nil];

    animationView.animationDuration = 0.8f;
    animationView.animationRepeatCount = 0;
    [animationView startAnimating];
    self.animationView = animationView;
    UIImageView * anim2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"memetro-anim-0"]];
    anim2.animationImages = [NSArray arrayWithObjects:
                             [UIImage imageNamed:@"memetro-anim-0"],
                             [UIImage imageNamed:@"memetro-anim-1"],
                             [UIImage imageNamed:@"memetro-anim-2"],
                             [UIImage imageNamed:@"memetro-anim-3"],
                             [UIImage imageNamed:@"memetro-anim-4"],
                             [UIImage imageNamed:@"memetro-anim-5"],
                             [UIImage imageNamed:@"memetro-anim-6"],
                             [UIImage imageNamed:@"memetro-anim-7"],
                             [UIImage imageNamed:@"memetro-anim-8"],
                             [UIImage imageNamed:@"memetro-anim-7"],
                             [UIImage imageNamed:@"memetro-anim-6"],
                             [UIImage imageNamed:@"memetro-anim-5"],
                             [UIImage imageNamed:@"memetro-anim-4"],
                             [UIImage imageNamed:@"memetro-anim-3"],
                             [UIImage imageNamed:@"memetro-anim-2"],
                             [UIImage imageNamed:@"memetro-anim-1"],
                             [UIImage imageNamed:@"memetro-anim-0"],
                             nil
                            ];
    anim2.animationRepeatCount = 0;
    anim2.animationDuration= .6f;
    [anim2 startAnimating];
    self.memetroAnimationView = anim2;
    [self setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:.7f]];
    return self;
}


-(void) displayInView:(UIView *) view{
    self.frame = [[UIScreen mainScreen] bounds];
    self.animationView.frame = CGRectMake(0, 0, view.frame.size.width, 2.0f);
    if(IS_IPHONE_5){
        self.memetroAnimationView.frame = CGRectMake(-20, 200, 59, 63);
    }else{
        self.memetroAnimationView.frame = CGRectMake(-20, 200, 59, 63);
    }
    [self addSubview:self.memetroAnimationView];
    [self addSubview:self.animationView];
    [view addSubview:self];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1f
                                                  target:self
                                                selector:@selector(increasePosition)
                                                userInfo:nil
                                                 repeats:YES];
}



-(void) hide{
    [self.animationView removeFromSuperview];
    [self removeFromSuperview];
}

-(void) increasePosition{
    CGRect  f = self.memetroAnimationView.frame;
    if(f.origin.x > 330){
        f.origin.x = -20;
    }else{
        f.origin.x = f.origin.x + 2;
    }
    self.memetroAnimationView.frame = f;
}


@end
