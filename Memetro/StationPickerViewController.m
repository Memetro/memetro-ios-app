//
//  StationPickerViewController.m
//  Memetro
//
//  Created by Christian Bongardt on 03/12/13.
//  Copyright (c) 2013 memetro. All rights reserved.
//

#import "StationPickerViewController.h"
#import "PickerCell.h"
#import "Station.h"
#import "DataParser.h"

@interface StationPickerViewController ()

@end

@implementation StationPickerViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = NSLocalizedString(@"Pick a Station", @"");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
}

-(void) cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Station *s;
    if(self.lineId!=nil){
        s  = [[[DataParser sharedInstance] getStationsOfLines:@[self.lineId]] objectAtIndex:indexPath.row];
    }else if(self.transportId != nil){
        s  = [[[DataParser sharedInstance] getStationsOfTransportId:self.transportId] objectAtIndex:indexPath.row];
    }else{
        s = [[[DataParser sharedInstance] getStations] objectAtIndex:indexPath.row];
    }
    [_delegate userDidPickStation:s];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"PickerCell";
    PickerCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PickerCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    Station *s;
    if(self.lineId!=nil){
        s  = [[[DataParser sharedInstance] getStationsOfLines:@[self.lineId]] objectAtIndex:indexPath.row];
    }else if(self.transportId != nil){
        s  = [[[DataParser sharedInstance] getStationsOfTransportId:self.transportId] objectAtIndex:indexPath.row];
    }else{
        s = [[[DataParser sharedInstance] getStations] objectAtIndex:indexPath.row];
    }
    cell.label.text = s.name;
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(self.lineId!=nil){
        return [[[DataParser sharedInstance] getStationsOfLines:@[self.lineId]] count];
    }else if(self.transportId != nil){
        return  [[[DataParser sharedInstance] getStationsOfTransportId:self.transportId] count];
    }else{
        return [[[DataParser sharedInstance] getStations] count];
    }
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

@end
