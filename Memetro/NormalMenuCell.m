//
//  NormalMenuCell.m
//  Memetro
//
//  Created by Christian Bongardt on 04/09/13.
//  Copyright (c) 2013 memetro. All rights reserved.
//

#import "NormalMenuCell.h"

@implementation NormalMenuCell

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

-(void) awakeFromNib{
    self.label.textColor = [UIColor colorWithRed:0.77f green:0.77f blue:0.77f alpha:1.00f];
    self.label.font = [UIFont fontWithName:@"Roboto-Light" size:16];
}

@end
