//
//  ProfileMenuCell.h
//  Memetro
//
//  Created by Christian Bongardt on 04/09/13.
//  Copyright (c) 2013 memetro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileMenuCell : UITableViewCell
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *fatLabels;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *lightLabels;
@property (weak, nonatomic) IBOutlet UIImageView *rankImage;
@property (weak, nonatomic) IBOutlet UILabel *level;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UILabel *memetrolLabel;
@property (weak, nonatomic) IBOutlet UILabel *memetrol;
@property (weak, nonatomic) IBOutlet UILabel *alertLabel;
@property (weak, nonatomic) IBOutlet UILabel *alert;

@end
