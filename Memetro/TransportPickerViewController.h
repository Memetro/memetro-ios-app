//
//  TransportPickerViewController.h
//  Memetro
//
//  Created by Christian Bongardt on 03/12/13.
//  Copyright (c) 2013 memetro. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Transport;
@protocol TransportPickerDelegate
-(void) userDidPickTransport:(Transport *) transport;
@end

@interface TransportPickerViewController : UITableViewController
@property (assign,nonatomic) id<TransportPickerDelegate> delegate;
@property (strong,nonatomic) NSNumber *cityId;
@end

