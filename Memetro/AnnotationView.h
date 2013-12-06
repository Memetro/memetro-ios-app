//
//  AnnotationView.h
//  GlassPay
//
//  Created by Christian Bongardt on 11/07/13.
//  Copyright (c) 2013 PaynoPain Solutions S.L. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <AddressBook/AddressBook.h>

@interface AnnotationView : MKAnnotationView <MKAnnotation>
- (id)initWithLine:(NSString*)line station:(NSString*)station time:(NSString *) time coordinate:(CLLocationCoordinate2D)coordinate timePassed:(int) timepassed icon:(NSString *)icon;
- (MKMapItem*)mapItem;
@property (nonatomic,copy)  NSString *icon;
@property (nonatomic, copy) NSString *line;
@property (nonatomic, copy) NSString *station;
@property (nonatomic, copy) NSString *time;
@property int timePassed;

@property (nonatomic, assign) CLLocationCoordinate2D theCoordinate;
@end


