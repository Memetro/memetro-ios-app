//
//  LinesStations.h
//  Memetro
//
//  Created by Christian Bongardt on 25/09/13.
//  Copyright (c) 2013 memetro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface LinesStations : NSManagedObject

@property (nonatomic, retain) NSNumber * line;
@property (nonatomic, retain) NSNumber * station;

@end
