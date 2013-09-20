//
//  DataParser.h
//  Memetro
//
//  Created by Christian Bongardt on 19/09/13.
//  Copyright (c) 2013 memetro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataParser : NSObject
+ (instancetype)sharedInstance;
-(BOOL) parseSync:(NSData *) data;
@property (strong,nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong,nonatomic) NSDictionary *parsedData;
@end
