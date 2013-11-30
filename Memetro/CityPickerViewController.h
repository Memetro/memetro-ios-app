//
//  CityPickerViewController.h
//  Memetro
//
//  Created by Christian Bongardt on 30/11/13.
//  Copyright (c) 2013 memetro. All rights reserved.
//

#import <UIKit/UIKit.h>

@class City;
@protocol CityPickerDelegate
-(void) userDidPickCity:(City *) city;
@end

@interface CityPickerViewController : UITableViewController
@property (assign,nonatomic) id<CityPickerDelegate> delegate;
@property (strong,nonatomic) NSNumber *countryID;
@end
