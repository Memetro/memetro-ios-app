//
//  CitiesTransports.h
//  Memetro
//
//  Created by Christian Bongardt on 24/09/13.
//  Copyright (c) 2013 memetro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CitiesTransports : NSManagedObject

@property (nonatomic, retain) NSNumber * city;
@property (nonatomic, retain) NSNumber * transport;

@end
