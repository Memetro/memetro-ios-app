//
//  DataParser.h
//  Memetro
//
//  Created by Christian Bongardt on 19/09/13.
//  Copyright (c) 2013 memetro. All rights reserved.
//

#import <Foundation/Foundation.h>
@class User;
@class City;
@class Country;
@class Transport;
@class Line;
@class Station;
@interface DataParser : NSObject
+ (instancetype)sharedInstance;
-(BOOL) parseSync:(NSData *) data;
-(BOOL) parseStaticData:(NSData *) data;
-(BOOL) parseUserEdit:(NSData *) data;


-(BOOL) save;

@property (strong,nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong,nonatomic) NSDictionary *parsedData;

@property (strong,nonatomic) User *user;


-(User *) getUser;
-(NSArray *) getLinesStations;
-(NSArray *) getCountries;
-(Country *) getCountryWithId:(NSNumber *) id;
-(NSArray *) getCities;
-(NSArray *) getCitiesWithCountryId:(NSNumber *) id;
-(City *) getCity:(NSNumber *) id;
-(NSArray *) getStations;
-(Station *) getStation:(NSNumber *)id;
-(NSArray *) getStationsOfLines:(NSArray *)lineIds;
-(NSArray *) getStationsOfTransportId:(NSNumber *) id;
-(NSArray *) getLines;
-(Line *) getLine:(NSNumber *)id;
-(NSArray *) getLinesOfTransportId:(NSNumber *) id;
-(NSArray *) getLinesOfStations:(NSNumber *) id;
-(NSArray *) getTransports;
-(Transport *) getTransport:(NSNumber *) id;
-(NSArray *) getTransportsOfCityId:(NSNumber *)cityId;
@end
