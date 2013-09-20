//
//  DataParser.m
//  Memetro
//
//  Created by Christian Bongardt on 19/09/13.
//  Copyright (c) 2013 memetro. All rights reserved.
//

#import "DataParser.h"
#import "AppDelegate.h"
#import "User.h"

@implementation DataParser
+ (instancetype)sharedInstance{
    static id sharedInstance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[[self class] alloc] init];
    });
    return sharedInstance;
}


-(id) init{
    self = [super init];
    return self;
}

-(NSManagedObjectContext *) managedObjectContext{
    if(self.managedObjectContext == nil){
        self.managedObjectContext =[((AppDelegate *)[[UIApplication sharedApplication] delegate]) managedObjectContext];
    }
    return self.managedObjectContext;
}

-(BOOL) parseSync:(NSData *) data{
    NSError *error = nil;
    self.parsedData = [NSJSONSerialization
                       JSONObjectWithData:data
                       options:0
                       error:&error];
    if(error) return NO;
    if(![[self.parsedData objectForKey:@"success"] boolValue]) return NO;
    
    NSLog(@"d %@",self.parsedData);

    if(![[self managedObjectContext] save:&error]){
        NSLog(@"error while saving wallet: %@",error);
        return NO;
    }
    return YES;
}

-(BOOL) parseUser{
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User"
                                              inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [[self managedObjectContext]executeFetchRequest:fetchRequest error:&error];
    if(error){
        NSLog(@"Error in fetch request");
        return NO;
    }
    User* user;
    if(fetchedObjects.count == 0){
        user = [fetchedObjects objectAtIndex:0];
    }else{
        user = [NSEntityDescription insertNewObjectForEntityForName:@"User"
                                             inManagedObjectContext:[self managedObjectContext]];
    }
    
    
    return YES;
}


@end
