//
//  AnnotationView.m
//  GlassPay
//
//  Created by Christian Bongardt on 11/07/13.
//  Copyright (c) 2013 PaynoPain Solutions S.L. All rights reserved.
//

#import "AnnotationView.h"

@implementation AnnotationView

- (id)initWithLine:(NSString*)line station:(NSString*)station time:(NSString *) time coordinate:(CLLocationCoordinate2D)coordinate timePassed:(int) timepassed icon:(NSString *)icon{
    if ((self = [super init])) {
        self.icon =icon;
        self.line = line;
        self.timePassed = timepassed;
        self.station = station;
        self.time = time;
        self.theCoordinate = coordinate;
    }
    return self;
}

- (NSString *)title {
    return [NSString stringWithFormat:@"%@ %@",self.station,self.line];
}

- (NSString *)subtitle {
    return self.time;
}

- (CLLocationCoordinate2D)coordinate {
    return _theCoordinate;
}

- (MKMapItem*)mapItem {
    MKPlacemark *placemark = [[MKPlacemark alloc]
                              initWithCoordinate:self.coordinate
                              addressDictionary:nil];
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    mapItem.name = self.title;
    return mapItem;
}

@end
