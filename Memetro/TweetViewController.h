//
//  TweetViewController.h
//  Memetro
//
//  Created by Christian Bongardt on 04/09/13.
//  Copyright (c) 2013 memetro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TweetViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@end
