//
//  LinePickerViewController.h
//  Memetro
//
//  Created by Christian Bongardt on 03/12/13.
//  Copyright (c) 2013 memetro. All rights reserved.
//

#import <UIKit/UIKit.h>


@class Line;

@protocol LinePickerDelegate
-(void) userDidPickLine:(Line *)line;
@end

@interface LinePickerViewController : UITableViewController
@property (assign,nonatomic) id<LinePickerDelegate> delegate;
@property (strong,nonatomic) NSNumber *transportId;
@property (strong,nonatomic) NSNumber *stationId;
@end
