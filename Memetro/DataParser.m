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
#import "LinesStations.h"

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
    self.managedObjectContext = [((AppDelegate *)[[UIApplication sharedApplication] delegate]) managedObjectContext];
    return self;
}





-(BOOL) parseSync:(NSData *) data{
    @try {
        NSError *error = nil;
        self.parsedData = [NSJSONSerialization
                           JSONObjectWithData:data
                           options:0
                           error:&error];
        if(error) return NO;
        if(![[self.parsedData objectForKey:@"success"] boolValue]) return NO;
        
        NSLog(@"d %@",self.parsedData);
        
        if(![self parseUser]){
            NSLog(@"Ha fallado parseUser");
            return NO;
        }
        if(![self parseHabtmRelations]){
            NSLog(@"Ha fallado parseHabtmRelations");
            return NO;
        }
        
        if([self save]){
            return NO;
        }
        return YES;
        
    }
    @catch (NSException *exception) {
        NSLog(@"Se ha lanzado una excepcion en parseSync: %@",exception);
        return NO;
    }
}

-(BOOL) parseUser{
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User"
                                              inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];
    NSDictionary *userData = [self.parsedData objectForKey:@"user"];
    
    NSArray *fetchedObjects = [[self managedObjectContext]executeFetchRequest:fetchRequest error:&error];
    if(error){
        NSLog(@"Error in fetch request");
        return NO;
    }
    User* user;
    if([fetchedObjects count] == 0){
        user = [NSEntityDescription insertNewObjectForEntityForName:@"User"
                                             inManagedObjectContext:[self managedObjectContext]];

    }else{
        user = [fetchedObjects objectAtIndex:0];

    }
    user.username = [userData objectForKey:@"username"];
    user.name = [userData objectForKey:@"name"];
    user.aboutme = [userData objectForKey:@"aboutme"];
    user.email = [userData objectForKey:@"email"];
    user.twittername = [userData objectForKey:@"twittername"];
    self.user = user;
    return YES;
}

-(BOOL) parseHabtmRelations{
    NSError *error = nil;
    NSFetchRequest *LinesStationsfetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *LinesStationsEntity = [NSEntityDescription entityForName:@"LinesStations"
                                              inManagedObjectContext:[self managedObjectContext]];
    [LinesStationsfetchRequest setEntity:LinesStationsEntity];
    NSArray *LinesStationsData = [self.parsedData objectForKey:@"user"];
    
    NSArray *fetchedLinesStations = [[self managedObjectContext]executeFetchRequest:LinesStationsfetchRequest error:&error];
    if(error){
        NSLog(@"Error in fetch request");
        return NO;
    }
    self.LinesStations = nil;
    for (NSManagedObject *o in fetchedLinesStations) {
        [[self managedObjectContext] deleteObject:o];
    }
    for(NSDictionary *d in LinesStationsData){
        LinesStations *l = [NSEntityDescription insertNewObjectForEntityForName:@"LinesStations"
                                                         inManagedObjectContext:[self managedObjectContext]];
        l.line = [d objectForKey:@""];
        l.station = [d objectForKey:@""];
        [self.LinesStations addObject:l];
    }
    return YES;
}

-(NSArray *) getLinesStations{
    if(self.LinesStations == nil){
        NSError *error = nil;
        NSFetchRequest *LinesStationsfetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *LinesStationsEntity = [NSEntityDescription entityForName:@"LinesStations"
                                                               inManagedObjectContext:[self managedObjectContext]];
        [LinesStationsfetchRequest setEntity:LinesStationsEntity];
        
        NSArray *fetchedLinesStations = [[self managedObjectContext]executeFetchRequest:LinesStationsfetchRequest error:&error];
        if(error){
            NSLog(@"Error in fetch request");
            return nil;
        }
        return fetchedLinesStations;
    }else{
        return self.LinesStations;
    }
}

-(User *) getUser{
    if(self.user != nil){
        return self.user;
    }else{
        NSError *error = nil;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"User"
                                                  inManagedObjectContext:[self managedObjectContext]];
        [fetchRequest setEntity:entity];
        NSArray *fetchedObjects = [[self managedObjectContext]executeFetchRequest:fetchRequest error:&error];
        if(error){
            NSLog(@"Error in fetch request");
            return nil;
        }
        if([fetchedObjects count] == 0){
            return nil;
        }else{
            return [fetchedObjects objectAtIndex:0];
        }
    }
}

-(BOOL) save{
    NSError *error = nil;
    if(![[self managedObjectContext] save:&error]){
        NSLog(@"error while saving wallet: %@",error);
        return NO;
    }
    NSLog(@"Data was saved.");
    return YES;
    
}


@end
