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
#import "ODRefreshControl.h"

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
    Line *l =[[[DataParser sharedInstance] getLinesOfTransportId:self.transportId andCityId:self.cityId] objectAtIndex:indexPath.row];
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
    Line *l =[[[DataParser sharedInstance] getLinesOfTransportId:self.transportId andCityId:self.cityId] objectAtIndex:indexPath.row];
    cell.label.text = l.name;
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[[DataParser sharedInstance] getLinesOfTransportId:self.transportId andCityId:self.cityId] count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

@end
