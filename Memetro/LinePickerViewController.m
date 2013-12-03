//
//  LinePickerViewController.m
//  Memetro
//
//  Created by Christian Bongardt on 03/12/13.
//  Copyright (c) 2013 memetro. All rights reserved.
//

#import "LinePickerViewController.h"
#import "PickerCell.h"
#import "Line.h"
#import "DataParser.h"

@interface LinePickerViewController ()

@end

@implementation LinePickerViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = NSLocalizedString(@"Pick a Line", @"");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    Line *l;
    if(self.stationId != nil){
        l  = [[[DataParser sharedInstance] getLinesOfStations:self.stationId] objectAtIndex:indexPath.row];
    }
    else if(self.transportId!=nil){
        l  = [[[DataParser sharedInstance] getLinesOfTransportId:self.transportId] objectAtIndex:indexPath.row];
    }else{
        l  = [[[DataParser sharedInstance] getLines] objectAtIndex:indexPath.row];
    }
    [_delegate userDidPickLine:l];
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
    Line *l;
    if(self.stationId != nil){
        l  = [[[DataParser sharedInstance] getLinesOfStations:self.stationId] objectAtIndex:indexPath.row];
    }
    else if(self.transportId!=nil){
        l  = [[[DataParser sharedInstance] getLinesOfTransportId:self.transportId] objectAtIndex:indexPath.row];
    }else{
        l  = [[[DataParser sharedInstance] getLines] objectAtIndex:indexPath.row];
    }
    cell.label.text = l.name;
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.stationId != nil){
        return [[[DataParser sharedInstance] getLinesOfStations:self.stationId] count];
    }
    else if(self.transportId!=nil){
        return [[[DataParser sharedInstance] getLinesOfTransportId:self.transportId] count];
    }else{
        return [[[DataParser sharedInstance] getLines] count];
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

@end
