//  Transport.h
//  Memetro
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Transport : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * icon;
@property (nonatomic, retain) NSNumber * id;

@end
