//
//  PlaceholderView.m
//  PaynoPain
//
//  Created by Christian Bongardt on 05/12/13.
//  Copyright (c) 2013 PaynoPain. All rights reserved.
//

#import "PlaceholderView.h"

@implementation PlaceholderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id) initWithTitle:(NSString *)title andSubtitle:(NSString *) subtitle withFrame:(CGRect) frame textColor:(UIColor *) color{
    self= [super initWithFrame:frame];
    if(self){
        
        UIImageView *i = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"placeholder"]];
        i.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:i];
        [i addConstraint:[NSLayoutConstraint constraintWithItem:i
                                                      attribute:NSLayoutAttributeHeight
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:Nil
                                                      attribute:NSLayoutAttributeNotAnAttribute
                                                     multiplier:1
                                                       constant:150]];
        [i addConstraint:[NSLayoutConstraint constraintWithItem:i
                                                      attribute:NSLayoutAttributeWidth
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:Nil
                                                      attribute:NSLayoutAttributeNotAnAttribute
                                                     multiplier:1
                                                       constant:150]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:i
                                                         attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterX
                                                        multiplier:1
                                                          constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:i
                                                         attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterY
                                                        multiplier:1
                                                          constant:-30]];
        UILabel *l1 = [UILabel new];
        l1.textAlignment = NSTextAlignmentCenter;
        l1.backgroundColor = [UIColor clearColor];
        l1.font = [UIFont fontWithName:@"Roboto-Light" size:14];
        l1.text = title;
        l1.textColor = color;
        l1.minimumScaleFactor = 0.5;
        l1.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:l1];
        [l1 addConstraint:[NSLayoutConstraint constraintWithItem:l1
                                                      attribute:NSLayoutAttributeHeight
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:Nil
                                                      attribute:NSLayoutAttributeNotAnAttribute
                                                     multiplier:1
                                                       constant:21]];
        [l1 addConstraint:[NSLayoutConstraint constraintWithItem:l1
                                                       attribute:NSLayoutAttributeWidth
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:Nil
                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                      multiplier:1
                                                        constant:200]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:l1
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:i
                                                         attribute:NSLayoutAttributeBottom
                                                        multiplier:1
                                                          constant:8]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:l1
                                                         attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterX
                                                        multiplier:1
                                                          constant:0]];

        
        UILabel *l2 = [UILabel new];
        l2.font = [UIFont fontWithName:@"Roboto-Light" size:12];
        l2.backgroundColor = [UIColor clearColor];
        l2.text = subtitle;
        l2.textAlignment = NSTextAlignmentCenter;
        l2.textColor = color;
        l2.minimumScaleFactor = 0.5;
        l2.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:l2];

        [l2 addConstraint:[NSLayoutConstraint constraintWithItem:l2
                                                       attribute:NSLayoutAttributeWidth
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:Nil
                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                      multiplier:1
                                                        constant:200]];
        [l2 addConstraint:[NSLayoutConstraint constraintWithItem:l2
                                                       attribute:NSLayoutAttributeHeight
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:Nil
                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                      multiplier:1
                                                        constant:21]];

        [self addConstraint:[NSLayoutConstraint constraintWithItem:l2
                                                         attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterX
                                                        multiplier:1
                                                          constant:0]];

        [self addConstraint:[NSLayoutConstraint constraintWithItem:l2
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:l1
                                                         attribute:NSLayoutAttributeBottom
                                                        multiplier:1
                                                          constant:8]];

    }
    return self;
}

-(void) layoutSubviews{
    [super layoutSubviews];
}



@end
