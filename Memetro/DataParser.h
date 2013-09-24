//
//  DataParser.h
//  Memetro
//
//  Created by Christian Bongardt on 19/09/13.
//  Copyright (c) 2013 memetro. All rights reserved.
//

#import <Foundation/Foundation.h>
@class User;

@interface DataParser : NSObject
+ (instancetype)sharedInstance;
-(BOOL) parseSync:(NSData *) data;
-(User *) getUser;
-(NSArray *) getLinesStations;
-(BOOL) save;
@property (strong,nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong,nonatomic) NSDictionary *parsedData;
@property (strong,nonatomic) User *user;
@property (strong,nonatomic) NSMutableArray *LinesStations;
@end
