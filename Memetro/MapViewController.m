//
//  MapViewController.m
//  Memetro
//
//  Created by Christian Bongardt on 04/09/13.
//  Copyright (c) 2013 memetro. All rights reserved.
//

#import "MapViewController.h"
#import "AnnotationView.h"
#import "DataParser.h"
#import "User.h"
@interface MapViewController ()
@property (strong,nonatomic) NSMutableArray *annotations;
@property BOOL zoomedToUserPosition;
@end

@implementation MapViewController

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

-(void) viewWillAppear:(BOOL)animated{
    [self loadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    self.map.delegate = nil;
    self.map.showsUserLocation = NO;
    [self.map removeFromSuperview];
    self.view = nil;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    static NSString *identifier = @"AnnotationView";
    if ([annotation isKindOfClass:[AnnotationView class]]) {
        MKAnnotationView *annotationView = (MKAnnotationView *) [self.map dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
        } else {
            annotationView.annotation = annotation;
        }
        annotationView.image = [UIImage imageNamed:((AnnotationView *) annotation).icon];

        return annotationView;
    }
    
    return nil;
}


-(void) loadData{
    [self.activity startAnimating];
    if([DataParser sharedInstance].alerts != nil){
        [self addAnotations];
    }else{
        [NXOAuth2Request performMethod:@"POST"
                            onResource:[CommonFunctions generateUrlWithParams:@"alerts/listAlert"]
                       usingParameters:@{@"city_id":[[DataParser sharedInstance] getUser].city_id}
                           withAccount:[CommonFunctions useraccount]
                   sendProgressHandler:nil
                       responseHandler:^(NSURLResponse *response, NSData *responseData, NSError *error) {
                           NSError *errorJson = nil;
                           NSDictionary *dic= [NSJSONSerialization
                                               JSONObjectWithData:responseData
                                               options:0
                                               error:&errorJson];

                           if([[dic objectForKey:@"success"] boolValue]){
                               [DataParser sharedInstance].alerts = [dic objectForKey:@"data"];
                               NSSortDescriptor *sortDescriptor;
                               sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date"
                                                                            ascending:NO];
                               NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                               [DataParser sharedInstance].alerts = [[DataParser sharedInstance].alerts sortedArrayUsingDescriptors:sortDescriptors];
                               [self addAnotations];

                           }
                       }];
    }
    

}

-(void) addAnotations{
    [self.map removeAnnotations:self.annotations];
    self.annotations = [NSMutableArray array];
    for (NSDictionary *alert in [DataParser sharedInstance].alerts){
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date = [df dateFromString:[alert objectForKey:@"date"]];
        NSNumber *n = [NSNumber numberWithDouble:[date timeIntervalSinceNow]];
        n = [NSNumber numberWithInt: abs([n intValue])];
        n = [NSNumber numberWithInt:[n intValue]/60];
        [df setDateFormat:@"HH:mm"];
        NSNumber * latitude = [alert objectForKey:@"latitude"];
        NSNumber * longitude = [alert objectForKey:@"longitude"];
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = latitude.doubleValue;
        coordinate.longitude = longitude.doubleValue;
        NSString *i;
        if([n intValue] <  25){
            i =[NSString stringWithFormat:@"%@-hot",[alert objectForKey:@"transport_icon"]];
        }else if([n intValue] < 45){
            i =[NSString stringWithFormat:@"%@-warm",[alert objectForKey:@"transport_icon"]];
        }else{
            i =[NSString stringWithFormat:@"%@-cold",[alert objectForKey:@"transport_icon"]];
        }
        AnnotationView *annotation = [[AnnotationView alloc] initWithLine:[alert objectForKey:@"line"] station:[alert objectForKey:@"station"] time:[df stringFromDate:date] coordinate:coordinate timePassed:[n intValue] icon:i];
        
        [self.map addAnnotation:annotation];
        [self.annotations addObject:annotation];

    }
    if(!SYSTEM_VERSION_LESS_THAN(@"7")){
        [self.map showAnnotations:self.annotations animated:YES];
    }

    [self.activity stopAnimating];
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if(SYSTEM_VERSION_LESS_THAN(@"7")){
        if(self.zoomedToUserPosition) return;
        MKCoordinateRegion mapRegion;
        mapRegion.center = mapView.userLocation.coordinate;
        mapRegion.span.latitudeDelta = 0.13;
        mapRegion.span.longitudeDelta = 0.13;
        [mapView setRegion:mapRegion animated: YES];
        self.zoomedToUserPosition = YES;
    }

}


@end
