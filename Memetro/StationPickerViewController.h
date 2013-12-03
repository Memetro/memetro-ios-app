//
//  StationPickerViewController.h
//  Memetro
//
//  Created by Christian Bongardt on 03/12/13.
//  Copyright (c) 2013 memetro. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Station;

@protocol StationPickerDelegate
-(void) userDidPickStation:(Station *)station;
@end

@interface StationPickerViewController : UITableViewController
@property (assign,nonatomic) id<StationPickerDelegate> delegate;
@property (strong,nonatomic) NSNumber *transportId;
@property (strong,nonatomic) NSNumber *lineId;
@end
