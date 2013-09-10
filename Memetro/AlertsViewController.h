//
//  AlertsViewController.h
//  Memetro
//
//  Created by Christian Bongardt on 18/08/13.
//  Copyright (c) 2013 memetro. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ListViewController;
@class MapViewController;
@class TweetViewController;
@interface AlertsViewController : UIViewController
@property (strong,nonatomic) ListViewController *listView;
@property (strong,nonatomic) MapViewController  *mapView;
@property (strong,nonatomic) TweetViewController *tweetView;
@property (strong,nonatomic) UIViewController *presentedView;
@property (strong,nonatomic) NSMutableArray *constraints;

@property (strong,nonatomic) UIButton *mapButton;
@property (strong,nonatomic) UIButton *tweetButton;
@property (strong,nonatomic) UIButton *listButton;

@end
