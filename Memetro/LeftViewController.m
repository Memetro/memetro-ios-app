//
//  LeftViewController.m
//  Memetro
//
//  Created by Christian Bongardt on 04/09/13.
//  Copyright (c) 2013 memetro. All rights reserved.
//

#import "LeftViewController.h"
#import "JASidePanelController.h"
#import "UIViewController+JASidePanel.h"
#import "NormalMenuCell.h"
#import "ProfileMenuCell.h"
#import "AppDelegate.h"
#import "SettingsViewController.h"
#import "AlertsViewController.h"
#import "DataParser.h"
#import "User.h"
@interface LeftViewController ()

@end

@implementation LeftViewController

- (id)init
{
    if(SYSTEM_VERSION_LESS_THAN(@"7.0")){
        self = [super initWithNibName:@"LeftViewControlleriOS6" bundle:nil];
    }else{
        self = [super initWithNibName:@"LeftViewController" bundle:nil];
    }

    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:{
            break;
        }
        case 1:{
            self.sidePanelController.centerPanel = [[UINavigationController alloc] initWithRootViewController:[[AlertsViewController alloc] initWithNibName:@"AlertsViewController" bundle:nil]];
            break;
        }
        case 2:{
            break;
        }
        case 3:{
            self.sidePanelController.centerPanel = [[UINavigationController alloc] initWithRootViewController:[[SettingsViewController alloc] init]];
            break;
        }
        case 4:{
            break;
        }
        case 5:{
            [((AppDelegate *)[[UIApplication sharedApplication] delegate]) logout];
            break;
        }           
            
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 1){
        return 50;
    }
    return 44.0;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        static NSString *simpleTableIdentifier = @"NormalMenuCell";
        NormalMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil){
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NormalMenuCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        [cell.separatorLine setHidden:YES];
        switch (indexPath.row) {
            case 0:{
                User *u = [[DataParser sharedInstance] user];
                NSString *name;
                if([u.twittername length] != 0){
                    name = [NSString stringWithFormat:@"@%@",u.twittername];
                }else if([u.name length] != 0) {
                    name = u.name;
                }else{
                    name = u.username;
                }
                if(u.avatar !=nil){
                    cell.image.image = u.avatar;
                }
                cell.label.text = name;
                [cell.separatorLine setHidden:NO];
                break;
            }
            case 1:{
                cell.label.text = NSLocalizedString(@"menualerts",@"");
                cell.image.image = [UIImage imageNamed:@"alert-menu-icon"];
                break;
            }

            case 2:{
                cell.label.text = NSLocalizedString(@"menuaorg",@"");
                cell.image.image = [UIImage imageNamed:@"asoc-menu-icon"];
                break;
            }
            case 3:{
                cell.label.text = NSLocalizedString(@"menusettings",@"");
                cell.image.image = [UIImage imageNamed:@"settings-menu-icon"];
                break;
            }
            case 4:{
                cell.label.text = NSLocalizedString(@"menuappinfo",@"");
                cell.image.image = [UIImage imageNamed:@"appinfo-menu-icon"];
                break;
            }
            case 5:{
                cell.label.text = NSLocalizedString(@"menulogout",@"");
                cell.image.image = [UIImage imageNamed:@"logout-menu-icon"];
                break;
            }
            default:
                break;
        }
        return cell;
    
    

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
    
}


@end
