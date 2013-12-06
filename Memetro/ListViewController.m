//
//  ListViewController.m
//  Memetro
//
//  Created by Christian Bongardt on 04/09/13.
//  Copyright (c) 2013 memetro. All rights reserved.
//

#import "ListViewController.h"
#import "AppDelegate.h"
#import "DataParser.h"
#import "User.h"
#import "ODRefreshControl.h"
#import "TemperatureCell.h"
#import "PlaceholderView.h"
@interface ListViewController ()
@property (strong,nonatomic) NSArray *alerts;
@property (strong,nonatomic) PlaceholderView *placeholder;
@end






@implementation ListViewController

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
    self.alerts = nil;
    [[CBProgressPanel sharedInstance] displayInView:self.view];
    ODRefreshControl *r = [[ODRefreshControl alloc] initInScrollView:self.tableView];
    r.tintColor = [UIColor blackColor];
    [r addTarget:self action:@selector(loadData:) forControlEvents:UIControlEventValueChanged];
 
}

-(void) viewWillAppear:(BOOL)animated{
       [self loadData:nil];
}
-(void) loadData:(ODRefreshControl *)r{
    if([CommonFunctions useraccount]== nil) return;
    
    [NXOAuth2Request performMethod:@"POST"
                        onResource:[CommonFunctions generateUrlWithParams:@"alerts/listAlert"]
                   usingParameters:@{@"city_id":[[DataParser sharedInstance] getUser].city_id}
                       withAccount:[CommonFunctions useraccount]
               sendProgressHandler:nil
                   responseHandler:^(NSURLResponse *response, NSData *responseData, NSError *error) {
                       if(r != nil) [r endRefreshing];
                       [[CBProgressPanel sharedInstance] hide];
                       NSError *errorJson = nil;
                       NSDictionary *dic= [NSJSONSerialization
                                           JSONObjectWithData:responseData
                                           options:0
                                           error:&errorJson];
                       if([[dic objectForKey:@"success"] boolValue]){
                           self.alerts = [dic objectForKey:@"data"];
                           NSSortDescriptor *sortDescriptor;
                           sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date"
                                                                        ascending:NO];
                           NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                           NSArray *sortedArray;
                           sortedArray = [self.alerts sortedArrayUsingDescriptors:sortDescriptors];
                           self.alerts = sortedArray;
                           [DataParser sharedInstance].alerts = self.alerts;
                           [self.tableView reloadData];
                       }
                   }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"TemperatureCell";
    TemperatureCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TemperatureCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSDictionary *alert = [self.alerts objectAtIndex:indexPath.row];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [df dateFromString:[alert objectForKey:@"date"]];
    NSNumber *n = [NSNumber numberWithDouble:[date timeIntervalSinceNow]];
    n = [NSNumber numberWithInt: abs([n intValue])];
    n = [NSNumber numberWithInt:[n intValue]/60];
    [df setDateFormat:@"HH:mm"];
    cell.time.text = [df stringFromDate:date];
    if([n intValue]< 25){
        cell.temperatureIndicator.image = [UIImage imageNamed:@"temperature-indicator-hot"];
    }else if([n intValue] < 45){
        cell.temperatureIndicator.image = [UIImage imageNamed:@"temperature-indicator-warm"];
    }
    cell.station.text = [[alert objectForKey:@"station"] uppercaseString];
    if([[alert objectForKey:@"transport_icon"] isEqualToString:@"-"]){
        cell.transportIcon.image = [UIImage imageNamed:@"transport-icon-cercanias"];
    }else{
        cell.transportIcon.image = [UIImage imageNamed:[alert objectForKey:@"transport_icon"]];
    }
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int count = [self.alerts count];
    [self.placeholder removeFromSuperview];
    if(count == 0){
        self.placeholder = [[PlaceholderView alloc] initWithTitle:NSLocalizedString(@"There are no alerts to display.", @"") andSubtitle:nil withFrame:self.tableView.frame textColor:[UIColor blackColor]];
        [self.tableView addSubview:self.placeholder];
    }
    return count;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

@end
