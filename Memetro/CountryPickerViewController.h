//
//  CityPickerViewController.h
//  Memetro
//
//  Created by Christian Bongardt on 30/11/13.
//  Copyright (c) 2013 memetro. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Country;
@protocol CountryPickerDelegate
-(void) userDidPickCountry:(Country *) country;
@end

@interface CountryPickerViewController : UITableViewController
@property (assign,nonatomic) id<CountryPickerDelegate> delegate;
@end
