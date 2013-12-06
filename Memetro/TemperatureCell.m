//
//  TemperatureCell.m
//  Memetro
//
//  Created by Christian Bongardt on 06/12/13.
//  Copyright (c) 2013 memetro. All rights reserved.
//

#import "TemperatureCell.h"

@implementation TemperatureCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
