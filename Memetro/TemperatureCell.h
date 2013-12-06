//
//  TemperatureCell.h
//  Memetro
//
//  Created by Christian Bongardt on 06/12/13.
//  Copyright (c) 2013 memetro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TemperatureCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *station;
@property (weak, nonatomic) IBOutlet UIImageView *transportIcon;
@property (weak, nonatomic) IBOutlet UIImageView *temperatureIndicator;
@property (weak, nonatomic) IBOutlet UILabel *time;

@end
