//
//  CityPickerViewController.m
//  Memetro
//
//  Created by Christian Bongardt on 30/11/13.
//  Copyright (c) 2013 memetro. All rights reserved.
//

#import "CityPickerViewController.h"
#import "DataParser.h"
#import "City.h"
#import "PickerCell.h"

@interface CityPickerViewController ()

@end

@implementation CityPickerViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = NSLocalizedString(@"Pick a City", @"");
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
    City *c;
    if(self.countryID != nil){
        c = [[[DataParser sharedInstance] getCitiesWithCountryId:self.countryID] objectAtIndex:indexPath.row];
    }else{
        c = [[[DataParser sharedInstance] getCities] objectAtIndex:indexPath.row];
    }
    
    [_delegate userDidPickCity:c];
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
    City *c;
    if(self.countryID != nil){
        c = [[[DataParser sharedInstance] getCitiesWithCountryId:self.countryID] objectAtIndex:indexPath.row];
        
    }else{
        c = [[[DataParser sharedInstance] getCities] objectAtIndex:indexPath.row];
        
    }
    
    cell.label.text = c.name;
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.countryID != nil){
        return [[[DataParser sharedInstance] getCitiesWithCountryId:self.countryID] count];
    }else{
        return [[[DataParser sharedInstance] getCities] count];
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

@end
