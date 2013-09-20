//
//  AppDelegate.h
//  Memetro
//
//  Created by Christian Bongardt on 16/08/13.
//  Copyright (c) 2013 memetro. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JASidePanelController;
@class LoginViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) JASidePanelController *viewController;
-(void) logout;
-(void) synchronize:(BOOL) afterLogin;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
@end
