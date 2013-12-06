//
//  TransportPickerViewController.m
//  Memetro
//
//  Created by Christian Bongardt on 03/12/13.
//  Copyright (c) 2013 memetro. All rights reserved.
//

#import "TransportPickerViewController.h"
#import "DataParser.h"
#import "Transport.h"
#import "PickerCell.h"
@interface TransportPickerViewController ()

@end

@implementation TransportPickerViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = NSLocalizedString(@"Pick a Transport", @"");
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
    Transport *t;
    if(self.cityId!=nil){
        t  = [[[DataParser sharedInstance] getTransportsOfCityId:self.cityId] objectAtIndex:indexPath.row];
    }else{
        t  = [[[DataParser sharedInstance] getTransports] objectAtIndex:indexPath.row];
    }
    
    [_delegate userDidPickTransport:t];
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
    Transport *t;
    if(self.cityId!=nil){
        t  = [[[DataParser sharedInstance] getTransportsOfCityId:self.cityId] objectAtIndex:indexPath.row];
    }else{
        t  = [[[DataParser sharedInstance] getTransports] objectAtIndex:indexPath.row];
    }
    cell.label.text = t.name;
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.cityId!=nil){
        return [[[DataParser sharedInstance] getTransportsOfCityId:self.cityId] count];
    }else{
        return [[[DataParser sharedInstance] getTransports] count];
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

@end
