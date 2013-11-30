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
#import "CitiesTransports.h"
#import "Country.h"
#import "City.h"
#import "Station.h"
#import "Line.h"
#import "Transport.h"

@interface DataParser ()
    @property (strong,nonatomic) NSMutableArray *LinesStations;
    @property (strong,nonatomic) NSMutableArray *CitiesTransports;
    @property (strong,nonatomic) NSMutableArray *Countries;
    @property (strong,nonatomic) NSMutableArray *Cities;
    @property (strong,nonatomic) NSMutableArray *Stations;
    @property (strong,nonatomic) NSMutableArray *Lines;
    @property (strong,nonatomic) NSMutableArray *Transports;
@end

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
        self.parsedData = [self.parsedData objectForKey:@"data"];
        
        if(![self parseUser]){
            NSLog(@"Ha fallado parseUser");
            return NO;
        }
        NSLog(@"self.User %@",self.user);
        if(![self parseHabtmRelations]){
            NSLog(@"Ha fallado parseHabtmRelations");
            return NO;
        }
        NSLog(@"self.CitiesTransports %@",self.CitiesTransports);
        NSLog(@"self.LinesStations %@",self.LinesStations);

        
        if(![self parseStation]){
            NSLog(@"Ha fallado parseStation");
            return NO;
        }
        NSLog(@"self.Stations %@",self.Stations);
        
        if(![self parseLine]){
            NSLog(@"Ha fallado parseLine");
            return NO;
        }
        NSLog(@"self.Lines %@",self.Lines);
        
        if(![self parseTransport]){
            NSLog(@"Ha fallado parseTransport");
            return NO;
        }
        NSLog(@"self.Transports %@",self.Transports);
        
        if(![self save]){
            return NO;
        }
        return YES;
        
    }
    @catch (NSException *exception) {
        NSLog(@"Se ha lanzado una excepcion en parseSync: %@",exception);
        return NO;
    }
}

-(BOOL) parseStaticData:(NSData *) data{
    @try {
        NSError *error = nil;
        NSDictionary *d = [NSJSONSerialization
                           JSONObjectWithData:data
                           options:0
                           error:&error];
        if(error) return NO;
        if(![[d objectForKey:@"success"] boolValue]) return NO;

        if(![self parseCountry:[[d objectForKey:@"data"] objectForKey:@"country"]]){
            NSLog(@"Ha fallado parseCountry");
            return NO;
        }
        NSLog(@"self.Country %@",self.Countries);
        
        if(![self parseCity:[[d objectForKey:@"data"] objectForKey:@"city"]]){
            NSLog(@"Ha fallado parseCity");
            return NO;
        }
        NSLog(@"self.City %@",self.Cities);

        if(![self save]){
            return NO;
        }
        return YES;
        
    }
    @catch (NSException *exception) {
        NSLog(@"Se ha lanzado una excepcion en parseStaticData: %@",exception);
        return NO;
    }

}



-(BOOL) parseUserEdit:(NSData *) data{
    @try {
        NSError *error = nil;
        NSDictionary *parsed = [NSJSONSerialization
                                JSONObjectWithData:data
                                options:0
                                error:&error];


        if (error )return NO;

        if([[parsed objectForKey:@"success"] boolValue]){
            self.parsedData = @{@"user":[parsed objectForKey:@"data"]};
            return [self parseUser];
        }else{
            return NO;
        }

    }
    @catch (NSException *e) {
        NSLog(@"exception e %@",e);
        return NO;
    }

}



-(BOOL) parseTransport{
    self.Transports = [NSMutableArray array];
    if([[[self.parsedData objectForKey:@"transport"] objectForKey:@"refresh"] boolValue]){
        NSError *error = nil;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Transport"
                                                  inManagedObjectContext:[self managedObjectContext]];
        [fetchRequest setEntity:entity];
        NSDictionary *transportData = [self.parsedData objectForKey:@"transport"];
        NSArray *fetchedObjects = [[self managedObjectContext]executeFetchRequest:fetchRequest error:&error];
        if( !error ){
            for (NSManagedObject *o in fetchedObjects){
                [self.managedObjectContext deleteObject:o];
            }
            for (NSDictionary *d in[transportData objectForKey:@"data"]){
                Transport *t = [NSEntityDescription insertNewObjectForEntityForName:@"Transport" inManagedObjectContext:[self managedObjectContext]];
                t.id = [NSNumber numberWithInt:[[d objectForKey:@"id"] intValue]];
                t.name = [d objectForKey:@"name"];
                t.icon = [d objectForKey:@"icon"];
                [self.Transports addObject:t];
            }
            return YES;
        }
        else return NO;
    }else{
        return YES;
    }
}

-(BOOL) parseLine{
    self.Lines = [NSMutableArray array];
    if([[[self.parsedData objectForKey:@"line"] objectForKey:@"refresh"] boolValue]){
        NSError *error = nil;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Line"
                                                  inManagedObjectContext:[self managedObjectContext]];
        [fetchRequest setEntity:entity];
        NSDictionary *lineData = [self.parsedData objectForKey:@"line"];
        NSArray *fetchedObjects = [[self managedObjectContext]executeFetchRequest:fetchRequest error:&error];
        if( !error ){
            for (NSManagedObject *o in fetchedObjects){
                [self.managedObjectContext deleteObject:o];
            }
            for (NSDictionary *d in[lineData objectForKey:@"data"]){
                Line *l = [NSEntityDescription insertNewObjectForEntityForName:@"Line" inManagedObjectContext:[self managedObjectContext]];
                l.id = [NSNumber numberWithInt:[[d objectForKey:@"id"] intValue]];
                l.name = [d objectForKey:@"name"];
                l.number = [NSNumber numberWithInt:[[d objectForKey:@"number"] intValue] ];
                l.transport_id = [NSNumber numberWithInt:[[d objectForKey:@"transport_id"] intValue]];
                [self.Lines addObject:l];
            }
            return YES;
        }
        else return NO;
    }else{
        return YES;
    }
}

-(BOOL) parseStation{
    self.Stations = [NSMutableArray array];
    if([[[self.parsedData objectForKey:@"station"] objectForKey:@"refresh"] boolValue]){
        NSError *error = nil;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Station"
                                                  inManagedObjectContext:[self managedObjectContext]];
        [fetchRequest setEntity:entity];
        NSDictionary *stationData = [self.parsedData objectForKey:@"station"];
        NSArray *fetchedObjects = [[self managedObjectContext]executeFetchRequest:fetchRequest error:&error];
        if( !error){
            for (NSManagedObject *o in fetchedObjects){
                [self.managedObjectContext deleteObject:o];
            }
            for (NSDictionary *d in[stationData objectForKey:@"data"]){
                Station *s = [NSEntityDescription insertNewObjectForEntityForName:@"Station" inManagedObjectContext:[self managedObjectContext]];
                s.id = [NSNumber numberWithInt:[[d objectForKey:@"id"] intValue]];
                s.name = [d objectForKey:@"name"];
                s.longitude = [ NSNumber numberWithFloat:[[d objectForKey:@"longitude"] floatValue] ];
                s.latitude = [ NSNumber numberWithFloat:[[d objectForKey:@"latitude"] floatValue] ];
                [self.Stations addObject:s];
            }
            return YES;
        }
        else return NO;
    }else{
        return YES;
    }
}

-(BOOL) parseCity:(NSDictionary *)cityData{
    self.Cities = [NSMutableArray array];
    if([[cityData objectForKey:@"refresh"] boolValue]){
        NSError *error = nil;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"City"
                                                  inManagedObjectContext:[self managedObjectContext]];
        [fetchRequest setEntity:entity];
        NSArray *fetchedObjects = [[self managedObjectContext]executeFetchRequest:fetchRequest error:&error];
        if( !error ){
            for (NSManagedObject *o in fetchedObjects){
                [self.managedObjectContext deleteObject:o];
            }
            for (NSDictionary *d in[cityData objectForKey:@"data"]){
                City *c = [NSEntityDescription insertNewObjectForEntityForName:@"City" inManagedObjectContext:[self managedObjectContext]];
                c.id = [NSNumber numberWithInt:[[d objectForKey:@"id"] intValue]];
                c.name = [d objectForKey:@"name"];
                c.country_id = [ NSNumber numberWithInt:[[d objectForKey:@"country_id"] intValue] ];
                [self.Cities addObject:c];
            }
            return YES;
        }
        else return NO;
    }else{
        return YES;
    }
 }

-(BOOL) parseCountry:(NSDictionary *) countryData{
    self.Countries = [NSMutableArray array];
    if([[countryData objectForKey:@"refresh"] boolValue]){
        NSError *error = nil;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Country"
                                                  inManagedObjectContext:[self managedObjectContext]];
        [fetchRequest setEntity:entity];
        NSArray *fetchedObjects = [[self managedObjectContext]executeFetchRequest:fetchRequest error:&error];
        if( !error ){
            for (NSManagedObject *o in fetchedObjects){
                [self.managedObjectContext deleteObject:o];
            }
            for (NSDictionary *d in[countryData objectForKey:@"data"]){
                Country *c = [NSEntityDescription insertNewObjectForEntityForName:@"Country" inManagedObjectContext:[self managedObjectContext]];
                c.id = [NSNumber numberWithInt:[[d objectForKey:@"id"] intValue]];
                c.name = [d objectForKey:@"name"];
                [self.Countries addObject:c];
            }
            return YES;
        }
        else return NO;
    }else{
        return YES;
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
    user.city_id = [NSNumber numberWithInt:[NULL_TO_NIL([userData objectForKey:@"city_id"]) intValue]];
    user.username = NULL_TO_NIL([userData objectForKey:@"username"]);
    user.name = NULL_TO_NIL([userData objectForKey:@"name"]);
    user.aboutme = NULL_TO_NIL([userData objectForKey:@"aboutme"]);
    user.email = NULL_TO_NIL([userData objectForKey:@"email"]);
    user.twittername = NULL_TO_NIL([userData objectForKey:@"twittername"]);
    self.user = user;
    return YES;
}

-(BOOL) parseHabtmRelations{
    self.LinesStations = [NSMutableArray array];
    self.CitiesTransports = [NSMutableArray array];

    NSError *error = nil;
    NSFetchRequest *LinesStationsfetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *LinesStationsEntity = [NSEntityDescription entityForName:@"LinesStations"
                                              inManagedObjectContext:[self managedObjectContext]];
    [LinesStationsfetchRequest setEntity:LinesStationsEntity];

    NSArray *LinesStationsData = [[self.parsedData objectForKey:@"linesstations"] objectForKey:@"data"];

    NSArray *fetchedLinesStations = [[self managedObjectContext]executeFetchRequest:LinesStationsfetchRequest error:&error];
    if(error){
        NSLog(@"Error in fetch request");
        return NO;
    }
    for (NSManagedObject *o in fetchedLinesStations) {
        [[self managedObjectContext] deleteObject:o];
    }
    for(NSDictionary *d in LinesStationsData){
        LinesStations *l = [NSEntityDescription insertNewObjectForEntityForName:@"LinesStations"
                                                         inManagedObjectContext:[self managedObjectContext]];
        l.line = [ NSNumber numberWithInt:[[d objectForKey:@"line_id"] intValue] ];
        l.station = [NSNumber numberWithInt:[[d objectForKey:@"station_id"] intValue] ];
        [self.LinesStations addObject:l];
    }
    
    NSFetchRequest *CitiesTranportsfetchRequest  = [[NSFetchRequest alloc] init];
    NSEntityDescription *CitiesTransportsEntity = [NSEntityDescription insertNewObjectForEntityForName:@"CitiesTransports"
                                                                            inManagedObjectContext:[self managedObjectContext]];
    NSArray *CitiesTransportsData = [[self.parsedData objectForKey:@"citiestransport"] objectForKey:@"data"];
    [CitiesTranportsfetchRequest setEntity:CitiesTransportsEntity];
    NSArray *fetchedCitiesTransports = [[self managedObjectContext]executeFetchRequest:LinesStationsfetchRequest error:&error];
    if(error == nil){
        for(NSManagedObject *o in fetchedCitiesTransports ){
            [self.managedObjectContext deleteObject:o];
        }
    }else{
        return NO;
    }
    if(error){
        NSLog(@"Error in fetch request");
        return NO;
    }
    for (NSDictionary *d in CitiesTransportsData){
        CitiesTransports *c = [NSEntityDescription insertNewObjectForEntityForName:@"CitiesTransports" inManagedObjectContext:[self managedObjectContext]];
        c.city = [ NSNumber numberWithInt:[[d objectForKey:@"transport_id"] intValue] ];
        c.transport = [NSNumber numberWithInt:[[d objectForKey:@"city_id"] intValue] ];
        [self.CitiesTransports addObject:c];
    }
    return YES;
}


-(NSArray *) getTransports{
    if(self.Transports == nil){
        NSError *error = nil;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Transport"
                                                  inManagedObjectContext:[self managedObjectContext]];
        [fetchRequest setEntity:entity];
        NSArray *fetchedObjects = [[self managedObjectContext]executeFetchRequest:fetchRequest error:&error];
        if(error == nil){
            self.Transports = [NSMutableArray arrayWithArray:fetchedObjects];
            return fetchedObjects;
        }
        else return nil;
    }else{
        return self.Transports;
    }

}

-(NSArray *) getLines{
    if(self.Lines == nil){
        NSError *error = nil;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Line"
                                                  inManagedObjectContext:[self managedObjectContext]];
        [fetchRequest setEntity:entity];
        NSArray *fetchedObjects = [[self managedObjectContext]executeFetchRequest:fetchRequest error:&error];
        if(error == nil){
            self.Lines = [NSMutableArray arrayWithArray:fetchedObjects];
            return fetchedObjects;
        }
        else return nil;
    }else{
        return self.Lines;
    }
    
}

-(NSArray *) getStations{
    if(self.Stations == nil){
        NSError *error = nil;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Station"
                                                  inManagedObjectContext:[self managedObjectContext]];
        [fetchRequest setEntity:entity];
        NSArray *fetchedObjects = [[self managedObjectContext]executeFetchRequest:fetchRequest error:&error];
        if(error == nil){
            self.Stations = [NSMutableArray arrayWithArray:fetchedObjects];
            return fetchedObjects;
        }
        else return nil;
    }else{
        return self.Stations;
    }
}

-(NSArray *) getCities{
    if(self.Cities == nil){
        NSError *error = nil;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"City"
                                                  inManagedObjectContext:[self managedObjectContext]];
        [fetchRequest setEntity:entity];
        NSArray *fetchedObjects = [[self managedObjectContext]executeFetchRequest:fetchRequest error:&error];
        if(error == nil){
            self.Cities = [NSMutableArray arrayWithArray:fetchedObjects];
            return fetchedObjects;
        }
        else return nil;
    }else{
        return self.Cities;
    }
}

-(NSArray *) getCitiesWithCountryId:(NSNumber *) id{
    if (self.Cities == nil){
        [self getCities];
        if(self.Cities !=nil){
            [self getCitiesWithCountryId:id];
        }
    }else{
        NSArray *filteredCities = [self.Cities filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(self.country_id == %@)",id]];
        return filteredCities;
    }
    return [NSArray array];
}



-(City *) getCity:(NSNumber *) id{
    if(self.Cities ==nil){
        [self getCities];
        if(self.Cities != nil){
            [self getCity:id];
        }
    }else{
        NSArray *filteredCities = [self.Cities filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(self.id == %@)",id]];
        if([filteredCities count] != 0){
            return [filteredCities objectAtIndex:0];
        }
        return nil;
    }
    return nil;
}

-(NSArray *) getCountries{
    if(self.Countries ==nil){
        NSError *error = nil;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Country"
                                                  inManagedObjectContext:[self managedObjectContext]];
        [fetchRequest setEntity:entity];
        NSArray *fetchedObjects = [[self managedObjectContext]executeFetchRequest:fetchRequest error:&error];
        if(error == nil){
            self.Countries = [NSMutableArray arrayWithArray:fetchedObjects];
            return fetchedObjects;
        }
        else return nil;
    }else{
        return self.Countries;
    }
    
}
-(Country *) getCountryWithId:(NSNumber *) id{
    if(self.Countries ==nil){
        [self getCountries];
        if(self.Countries != nil){
            [self getCountryWithId:id];
        }
    }else{
        NSArray *filteredCountries = [self.Countries filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(self.id == %@)",id]];
        if([filteredCountries count] != 0){
            return [filteredCountries objectAtIndex:0];
        }
        return nil;
    }
    return nil;
    
}

-(NSArray *) getLinesStations{
    if(self.LinesStations == nil){
        NSError *error = nil;
        NSFetchRequest *LinesStationsfetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *LinesStationsEntity = [NSEntityDescription entityForName:@"LinesStations"
                                                               inManagedObjectContext:[self managedObjectContext]];
        [LinesStationsfetchRequest setEntity:LinesStationsEntity];
        
        NSArray *fetchedLinesStations = [[self managedObjectContext]executeFetchRequest:LinesStationsfetchRequest error:&error];
        if(error!=nil){
            NSLog(@"Error in fetch request");
            return nil;
        }
        self.LinesStations = [NSMutableArray arrayWithArray:fetchedLinesStations];
        return fetchedLinesStations;
    }else{
        return self.LinesStations;
    }
}

-(NSArray *) getCitiesTransports{
    if(self.CitiesTransports ==  nil){
        NSError *error = nil;
        NSFetchRequest *CitiesTranportsfetchRequest  = [[NSFetchRequest alloc] init];
        NSEntityDescription *CitiesTransportsEntity = [NSEntityDescription insertNewObjectForEntityForName:@"CitiesTransports"
                                                                                    inManagedObjectContext:[self managedObjectContext]];
        [CitiesTranportsfetchRequest setEntity:CitiesTransportsEntity];
        NSArray *fetchedCitiesTransports = [[self managedObjectContext] executeFetchRequest:CitiesTranportsfetchRequest error:&error];
        if(error == nil){
            self.CitiesTransports = [NSMutableArray arrayWithArray:fetchedCitiesTransports];
            return fetchedCitiesTransports;
        }
        return nil;

    }else{
        return self.CitiesTransports;
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
