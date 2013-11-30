//
//  User.h
//  Memetro
//
//  Created by Christian Bongardt on 30/11/13.
//  Copyright (c) 2013 memetro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSString * aboutme;
@property (nonatomic, retain) id avatar;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * twittername;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSNumber * city_id;

@end
