//
//  ProfileMenuCell.m
//  Memetro
//
//  Created by Christian Bongardt on 04/09/13.
//  Copyright (c) 2013 memetro. All rights reserved.
//

#import "ProfileMenuCell.h"

@implementation ProfileMenuCell

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
    for (UILabel *l in self.fatLabels){
        l.textColor = [UIColor colorWithRed:0.20f green:0.20f blue:0.20f alpha:1.00f];
        l.font = [UIFont fontWithName:@"Roboto-Bold" size:11];
    }
    for (UILabel *l in self.lightLabels){
        l.textColor =[UIColor colorWithRed:0.20f green:0.20f blue:0.20f alpha:1.00f];
        l.font = [UIFont fontWithName:@"Roboto-Light" size:10];
    }
    self.memetrolLabel.text = NSLocalizedString(@"menumemetrollabel",@"");
    self.alertLabel.text =NSLocalizedString(@"menualertlabel",@"");
    self.levelLabel.text =NSLocalizedString(@"menulevellabel",@"");
    self.backgroundColor = [UIColor colorWithRed:0.96f green:0.95f blue:0.95f alpha:1.00f];
    self.contentView.backgroundColor= [UIColor colorWithRed:0.96f green:0.95f blue:0.95f alpha:1.00f];
}

@end
