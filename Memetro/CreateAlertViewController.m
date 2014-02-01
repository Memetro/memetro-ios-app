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
#import "RobotoTextfieldReplacementLabel.h"
@interface CreateAlertViewController ()<UITextViewDelegate>

@end

@implementation CreateAlertViewController



- (void)viewDidLoad{
    [super viewDidLoad];
    [self registerForKeyboardNotifications];
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
    self.comment.font = [UIFont fontWithName:@"Roboto-Light" size:16];
    self.comment.textColor = [UIColor colorWithRed:0.49f green:0.49f blue:0.49f alpha:1.00f];
    self.comment.text = NSLocalizedString(@"Comment", @"");
    self.titleLabel.text = NSLocalizedString(@"CREATE ALERT", @"");
    self.transport.text = NSLocalizedString(@"Pick a transport", @"");
    [self.transport setUserInteractionEnabled:YES];
    [self.transport addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickTransport)]];
    self.line.text = NSLocalizedString(@"Pick a line", @"");
    [self.line setUserInteractionEnabled:YES];
    [self.line addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickLine)]];
    self.station.text = NSLocalizedString(@"Pick a station", @"");
    [self.station setUserInteractionEnabled:YES];
    [self.station addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickStation)]];
    [self.alertButton setTitle:NSLocalizedString(@"Create alert!", @"") forState:UIControlStateNormal];

    self.city.text = [[DataParser sharedInstance] getCity:self.cityId].name;
    if([self.city.text length]>0) [self.city setPlaceholderEnabled:NO];
    self.transport.text = [[DataParser sharedInstance] getTransport:self.transportId].name;
    if([self.transport.text length]>0) [self.transport setPlaceholderEnabled:NO];
}

-(void) cancel{
    [self dismissViewControllerAnimated:YES completion:nil];    
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}




-(void) pickCity{
    CityPickerViewController *c = [[CityPickerViewController alloc] init];
    c.countryID = [[DataParser sharedInstance] getCity:self.cityId].country_id;
    c.delegate = self;
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:c] animated:YES completion:nil];
    return;
    
}
-(void) pickTransport{
    TransportPickerViewController *t = [[TransportPickerViewController alloc] init];
    t.cityId = self.cityId;
    t.delegate = self;
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:t] animated:YES completion:nil];
    
}
-(void) pickLine{
    if(self.transportId == nil){
        [CommonFunctions showError:NSLocalizedString(@"Please, first pick a transport from the list.", @"") withTitle:NSLocalizedString(@"Missing transport", @"") withDismissHandler:^(SIAlertView *alertView) {
            TransportPickerViewController *t = [[TransportPickerViewController alloc] init];
            t.cityId = self.cityId;
            t.delegate = self;
            [self presentViewController:[[UINavigationController alloc] initWithRootViewController:t] animated:YES completion:nil];
        }];
        return;
    }
    LinePickerViewController * l = [[LinePickerViewController alloc] init];
    l.delegate = self;
    l.transportId = self.transportId;
    l.cityId = self.cityId;
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:l] animated:YES completion:nil];

    
}
-(void) pickStation{
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
    [self.city setPlaceholderEnabled:NO];

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
    [self.transport setPlaceholderEnabled:NO];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void) userDidPickLine:(Line *)line{
    if(line.id != self.lineId){
        self.stationId = nil;
        self.station.text = NSLocalizedString(@"Pick a station", @"");
        [self.station setPlaceholderEnabled:YES];
    }
    self.lineId = line.id;
    self.line.text = line.name;
    [self.line setPlaceholderEnabled:NO];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) userDidPickStation:(Station *)station{
    self.stationId = station.id;
    self.station.text = station.name;
    [self.station setPlaceholderEnabled:NO];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)save:(id)sender {
    NSLog(@"station id %@",self.stationId);
    NSLog(@"line id %@",self.lineId);
    
    NSString *comment = @"";
    if(!_comment.text.length == 0 && ![_comment.text isEqualToString:NSLocalizedString(@"Comment", @"")]){
        comment = _comment.text;
    }

    
    if(self.stationId == nil ){
        [CommonFunctions showError:NSLocalizedString(@"You must pick a station.", @"") withTitle:NSLocalizedString(@"Empty fields", @"") withDismissHandler:nil];
        return;
    }
    [[CBProgressPanel sharedInstance] displayInView:self.view];
    [NXOAuth2Request performMethod:@"POST"
                        onResource:[CommonFunctions generateUrlWithParams:@"alerts/add"]
                   usingParameters:@{@"station_id":self.stationId,@"line_id":self.lineId,@"comment":comment,@"transport_id":_transportId}
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


- (void)registerForKeyboardNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardDidHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, _comment.superview.frame.origin) ) {
        [self.scrollView scrollRectToVisible:_comment.superview.frame animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
}


-(BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
    }
    return YES;
}

@end
