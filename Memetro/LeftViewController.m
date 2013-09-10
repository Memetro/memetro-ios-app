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
@interface LeftViewController ()

@end

@implementation LeftViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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
            break;
        }
        case 2:{
            break;
        }
        case 3:{
            break;
        }
        case 4:{
            break;
        }
        case 5:{
            break;
        }
        case 6:{
            break;
        }
        case 7:{
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
    if(indexPath.row == 1){
        static NSString *simpleTableIdentifier = @"ProfileMenuCell";
        ProfileMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil){
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ProfileMenuCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.alert.text = @"7";
        cell.memetrol.text = @"250";
        cell.rankImage.image = [UIImage imageNamed:@"ninja-menu-icon"];
        return cell;
        
    }else{
        static NSString *simpleTableIdentifier = @"NormalMenuCell";
        NormalMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil){
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NormalMenuCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        switch (indexPath.row) {
            case 0:{
                cell.label.text = NSLocalizedString(@"username",@"");
                break;
            }
            case 2:{
                cell.label.text = NSLocalizedString(@"menualerts",@"");
                cell.image.image = [UIImage imageNamed:@"alert-menu-icon"];
                break;
            }
            case 3:{
                cell.label.text = NSLocalizedString(@"menuparticipants",@"");
                cell.image.image = [UIImage imageNamed:@"ranking-menu-icon"];
                break;
            }
            case 4:{
                cell.label.text = NSLocalizedString(@"menuaorg",@"");
                cell.image.image = [UIImage imageNamed:@"asoc-menu-icon"];
                break;
            }
            case 5:{
                cell.label.text = NSLocalizedString(@"menusettings",@"");
                cell.image.image = [UIImage imageNamed:@"settings-menu-icon"];
                break;
            }
            case 6:{
                cell.label.text = NSLocalizedString(@"menuappinfo",@"");
                cell.image.image = [UIImage imageNamed:@"appinfo-menu-icon"];
                break;
            }
            case 7:{
                cell.label.text = NSLocalizedString(@"menulogout",@"");
                cell.image.image = [UIImage imageNamed:@"logout-menu-icon"];
                break;
            }
            default:
                break;
        }
        return cell;
        
    }
    
    
    

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 8;
    
}


@end
