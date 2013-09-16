//
//  CBProgressPanel.h
//  Memetro
//
//  Created by Christian Bongardt on 09/09/13.
//  Copyright (c) 2013 memetro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBProgressPanel : UIView
@property (strong,nonatomic) NSTimer *timer;
@property (strong,nonatomic) UIView *animationView;
@property (strong,nonatomic) UIImageView *memetroAnimationView;
+ (instancetype)sharedInstance;
-(void) displayInView:(UIView *) view;
-(void) hide;

@end
