//
//  MapViewController.h
//  Memetro
//
//  Created by Christian Bongardt on 04/09/13.
//  Copyright (c) 2013 memetro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
@interface MapViewController : UIViewController<CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property(nonatomic,retain) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet MKMapView *map;

@end
