//
//  CreateAlertViewController.m
//  Memetro
//
//  Created by Christian Bongardt on 30/11/13.
//  Copyright (c) 2013 memetro. All rights reserved.
//

#import "CreateAlertViewController.h"
#import "DataParser.h"
#import "User.h"
#import "City.h"
#import "Country.h"
#import "Transport.h"
#import "Line.h"
#import "Station.h"
#import "CBProgressPanel.h"
@interface CreateAlertViewController ()

@end

@implementation CreateAlertViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
        self.cityId =[[DataParser sharedInstance] getUser].city_id;
    NSArray *transports = [[DataParser sharedInstance] getTransportsOfCityId:self.cityId];
    if([transports count] != 0){
        self.transportId = ((Transport *)[transports objectAtIndex:0]).id;
    }
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];

    [self setupLayout];
}

-(void) setupLayout{
    self.titleLabel.text = NSLocalizedString(@"CREATE ALERT", @"");
    self.transport.placeholder = NSLocalizedString(@"Pick a transport", @"");
    self.line.placeholder = NSLocalizedString(@"Pick a line", @"");
    self.station.placeholder = NSLocalizedString(@"Pick a station", @"");
    [self.alertButton setTitle:NSLocalizedString(@"Create alert!", @"") forState:UIControlStateNormal];

    self.city.text = [[DataParser sharedInstance] getCity:self.cityId].name;
    self.transport.text = [[DataParser sharedInstance] getTransport:self.transportId].name;
}

-(void) cancel{
    [self dismissViewControllerAnimated:YES completion:nil];    
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

-(void) textFieldDidBeginEditing:(UITextField *)textField{
    [textField resignFirstResponder];
    if(textField == self.city){
        CityPickerViewController *c = [[CityPickerViewController alloc] init];
        c.countryID = [[DataParser sharedInstance] getCity:self.cityId].country_id;
        c.delegate = self;
        [self presentViewController:[[UINavigationController alloc] initWithRootViewController:c] animated:YES completion:nil];
        return;
    }
    if( textField == self.transport){
        TransportPickerViewController *t = [[TransportPickerViewController alloc] init];
        t.cityId = self.cityId;
        t.delegate = self;
        [self presentViewController:[[UINavigationController alloc] initWithRootViewController:t] animated:YES completion:nil];
    }
    if(textField == self.line){
        if(self.transportId == nil){
            [CommonFunctions showError:NSLocalizedString(@"Please, first pick a transport from the list.", @"") withTitle:NSLocalizedString(@"Missing transport", @"") withDismissHandler:^(SIAlertView *alertView) {
                TransportPickerViewController *t = [[TransportPickerViewController alloc] init];
                t.cityId = self.cityId;
                t.delegate = self;
                [self presentViewController:[[UINavigationController alloc] initWithRootViewController:t] animated:YES completion:nil];
            }];
        }
        LinePickerViewController * l = [[LinePickerViewController alloc] init];
        l.delegate = self;
        l.transportId = self.transportId;
        l.cityId = self.cityId;
        [self presentViewController:[[UINavigationController alloc] initWithRootViewController:l] animated:YES completion:nil];
    }
    
    if(textField == self.station){
        if(self.lineId == nil){
            [CommonFunctions showError:NSLocalizedString(@"Please, first pick a line from the list.", @"") withTitle:NSLocalizedString(@"Missing line", @"") withDismissHandler:^(SIAlertView *alertView) {
                TransportPickerViewController *t = [[TransportPickerViewController alloc] init];
                t.cityId = self.cityId;
                t.delegate = self;
                [self presentViewController:[[UINavigationController alloc] initWithRootViewController:t] animated:YES completion:nil];
            }];
            return;
        }
        StationPickerViewController *s = [[StationPickerViewController alloc] init];
        s.delegate = self;
        s.transportId = self.transportId;
        s.lineId = self.lineId;
        [self presentViewController:[[UINavigationController alloc] initWithRootViewController:s] animated:YES completion:nil];
    }
}

-(void) userDidPickCity:(City *)city{
    if(city.id != self.cityId){
        self.transport.text = @"";
        self.transportId = nil;
        self.station.text = @"";
        self.stationId = nil;
        self.line.text =@"";
        self.lineId = nil;
    }
    self.cityId = city.id;
    self.city.text = city.name;

    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) userDidPickTransport:(Transport *)transport{
    if(transport.id != self.transportId){
        self.station.text = @"";
        self.stationId = nil;
        self.line.text =@"";
        self.lineId = nil;
    }
    self.transportId = transport.id;
    self.transport.text = transport.name;
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void) userDidPickLine:(Line *)line{
    if(line.id != self.lineId){
        self.stationId = nil;
        self.station.text = @"";
    }
    self.lineId = line.id;
    self.line.text = line.name;
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) userDidPickStation:(Station *)station{
    self.stationId = station.id;
    self.station.text = station.name;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)save:(id)sender {
    NSLog(@"station id %@",self.stationId);
    NSLog(@"line id %@",self.lineId);
    

    if(self.stationId == nil ){
        [CommonFunctions showError:NSLocalizedString(@"You must pick a station.", @"") withTitle:NSLocalizedString(@"Empty fields", @"") withDismissHandler:nil];
        return;
    }
    [[CBProgressPanel sharedInstance] displayInView:self.view];
    [NXOAuth2Request performMethod:@"POST"
                        onResource:[CommonFunctions generateUrlWithParams:@"alerts/add"]
                   usingParameters:@{@"station_id":self.stationId,@"line_id":self.lineId}
                       withAccount:[CommonFunctions useraccount]
               sendProgressHandler:nil
                   responseHandler:^(NSURLResponse *response, NSData *responseData, NSError *error) {
                           [[CBProgressPanel sharedInstance] hide];
                       NSLog(@"repsonse %@",response);
                       if(error == nil){
                           
                           NSError *errorJson = nil;
                           NSDictionary *dic= [NSJSONSerialization
                                               JSONObjectWithData:responseData
                                               options:0
                                               error:&errorJson];
                           if([[dic objectForKey:@"success"] boolValue]){
                               [DataParser sharedInstance].alerts = nil;
                               [CommonFunctions showError:NSLocalizedString(@"Your alert has been created!", @"") withTitle:NSLocalizedString(@"Success!", @"") withDismissHandler:^(SIAlertView *alertView) {
                                   [self dismissViewControllerAnimated:YES completion:nil];
                               }];
                           }else{
                               [CommonFunctions showError:NSLocalizedString(@"You have to wait some time beofre creating your next alert!", @"") withTitle:NSLocalizedString(@"Error", @"") withDismissHandler:^(SIAlertView *alertView) {
                                   
                               }];
                               
                           }

                           
                       }else{
                           if([error code] == -1009){
                               [CommonFunctions showNoInternetError];
                               return;
                           }
                           [CommonFunctions showError:NSLocalizedString(@"Your alert could not be created. Try again later.", @"") withTitle:NSLocalizedString(@"Error!", @"") withDismissHandler:nil];
                       }
                       NSLog(@"Response data %@",[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
        
    }];
}
@end
