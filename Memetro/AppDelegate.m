//
//  AppDelegate.m
//  Memetro
//
//  Created by Christian Bongardt on 16/08/13.
//  Copyright (c) 2013 memetro. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "JASidePanelController.h"
#import "AlertsViewController.h"
#import "LeftViewController.h"
#import "DataParser.h"



@implementation AppDelegate
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self initViewController];
    [self setupLoginLogic];
    [self appearence];
    [self.window makeKeyAndVisible];
    [self login];
    return YES;
}

-(void) initViewController{
    self.viewController = [[JASidePanelController alloc] init];
    self.viewController.centerPanel = [[UINavigationController alloc] initWithRootViewController:[[AlertsViewController alloc] initWithNibName:@"AlertsViewController" bundle:nil]];
    self.viewController.leftPanel = [[LeftViewController alloc] initWithNibName:@"LeftViewController" bundle:nil];
    self.viewController.leftFixedWidth = 285;
    self.window.rootViewController = self.viewController;
}

-(void) login{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *identifier = [prefs stringForKey:@"accountidentifier"];
    if(identifier != nil){
        NXOAuth2Account *account = [[NXOAuth2AccountStore sharedStore] accountWithIdentifier:identifier];
        if(account != nil){
            NSLog(@"usuario logueado con account %@",account);
            [self synchronize:NO];
            return;
        }
    }
    LoginViewController *login = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    login.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self.viewController presentViewController:login animated:NO completion:nil];
}

-(void) setupLoginLogic{
    [[NXOAuth2AccountStore sharedStore]
     setClientID:CLIENT_ID
     secret:CLIENT_SECRET
     authorizationURL:[NSURL URLWithString:[BASE_URL stringByAppendingString:@"oauth/token"]]
     tokenURL:[NSURL URLWithString:[BASE_URL stringByAppendingString:@"oauth/token"]]
     redirectURL:[NSURL URLWithString:@"localhost"]
     forAccountType:@"memetro"];
    
    [[NSNotificationCenter defaultCenter]
     addObserverForName:NXOAuth2AccountStoreAccountsDidChangeNotification
     object:[NXOAuth2AccountStore sharedStore]
     queue:nil
     usingBlock:^(NSNotification *aNotification){
         if(aNotification.userInfo != nil){
             NSLog(@"Login correcto. Guardamos el identificador de la cuenta en user defaults");
             NXOAuth2Account *a = [aNotification.userInfo objectForKey:NXOAuth2AccountStoreNewAccountUserInfoKey];
             NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
             [prefs setObject:a.identifier forKey:@"accountidentifier"];
             [prefs synchronize];
             [self synchronize:YES];


         }

     }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:NXOAuth2AccountStoreDidFailToRequestAccessNotification
    object:[NXOAuth2AccountStore sharedStore]
    queue:nil
    usingBlock:^(NSNotification *aNotification){
        [[CBProgressPanel sharedInstance] hide];
        NSError *error = [aNotification.userInfo objectForKey:NXOAuth2AccountStoreErrorKey];
        NSLog(@"error %@",error);
        if([error code] == -1009){
            [CommonFunctions showNoInternetError];
        }else{
            [CommonFunctions showError:NSLocalizedString(@"wrongpassdescription", @"") withTitle:NSLocalizedString(@"wrongpasstitle", @"") withDismissHandler:nil];
        }
    }];
}

-(void) logout{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs removeObjectForKey:@"accountidentifier"];
    [prefs synchronize];
    for (NXOAuth2Account * a in [[NXOAuth2AccountStore sharedStore] accounts] ){
        [[NXOAuth2AccountStore sharedStore] removeAccount:a];
    }
    LoginViewController *login = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    login.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self.viewController presentViewController:login animated:YES completion:^{
        [self initViewController];
        LoginViewController *login = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        login.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self.viewController presentViewController:login animated:NO completion:nil];
    }];
}


-(void) appearence{
    self.window.backgroundColor = [UIColor colorWithRed:0.96f green:0.95f blue:0.95f alpha:1.00f];
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    [[UIBarButtonItem appearance]setTitleTextAttributes:@{UITextAttributeFont:[UIFont fontWithName:@"Roboto-Light" size:12],UITextAttributeTextColor:[UIColor blackColor],UITextAttributeTextShadowColor:[UIColor blackColor], UITextAttributeTextShadowOffset: [NSValue valueWithCGSize:CGSizeMake(0.0,0.0)]} forState:UIControlStateNormal];
    [[UIBarButtonItem appearance]setTitleTextAttributes:@{UITextAttributeFont:[UIFont fontWithName:@"Roboto-Light" size:12],UITextAttributeTextColor:[UIColor blackColor],UITextAttributeTextShadowColor:[UIColor blackColor], UITextAttributeTextShadowOffset: [NSValue valueWithCGSize:CGSizeMake(0.0,0.0)]} forState:UIControlStateHighlighted];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navbar"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleTextAttributes: @{
                                UITextAttributeTextColor: [UIColor blackColor],
                                     UITextAttributeFont: [UIFont fontWithName:@"Roboto-Regular" size:15.0f],
     }];
    //[[UINavigationBar appearance] setTitleVerticalPositionAdjustment:4 forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[UIImage alloc]];
    //UIImage *image = [UIImage imageNamed:@"nav-bar-nobadge"];
    //[[UIToolbar appearance] setBackgroundImage:image forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    
    
    [[SIAlertView appearance] setMessageFont:[UIFont fontWithName:@"Roboto-Regular" size:14]];
    [[SIAlertView appearance] setTitleColor:[UIColor blackColor]];
    [[SIAlertView appearance] setMessageColor:[UIColor colorWithRed:0.56f green:0.56f blue:0.56f alpha:1.00f]];
    [[SIAlertView appearance] setTitleFont:[UIFont fontWithName:@"Roboto-Regular" size:18]];
    [[SIAlertView appearance] setCornerRadius:5];
    [[SIAlertView appearance] setShadowRadius:20];
    [[SIAlertView appearance] setViewBackgroundColor:[UIColor whiteColor]];
    [[SIAlertView appearance] setButtonColor:[UIColor whiteColor]];
    [[SIAlertView appearance] setButtonFont:BUTTON_FONT];
    
    [[SIAlertView appearance] setCancelButtonColor:[UIColor whiteColor]];
    [[SIAlertView appearance] setDestructiveButtonColor:[UIColor whiteColor]];
    
    [[SIAlertView appearance] setDefaultButtonImage:[[UIImage imageNamed:@"button-default"] resizableImageWithCapInsets:UIEdgeInsetsMake(15,5,14,6)] forState:UIControlStateNormal];
    [[SIAlertView appearance] setDefaultButtonImage:[[UIImage imageNamed:@"button-default-d"] resizableImageWithCapInsets:UIEdgeInsetsMake(15,5,14,6)] forState:UIControlStateHighlighted];
    [[SIAlertView appearance] setCancelButtonImage:[[UIImage imageNamed:@"button-cancel"] resizableImageWithCapInsets:UIEdgeInsetsMake(15,5,14,6)] forState:UIControlStateNormal];
    [[SIAlertView appearance] setCancelButtonImage:[[UIImage imageNamed:@"button-cancel-d"] resizableImageWithCapInsets:UIEdgeInsetsMake(15,5,14,6)] forState:UIControlStateHighlighted];
    [[SIAlertView appearance] setDestructiveButtonImage:[[UIImage imageNamed:@"button-destructive"] resizableImageWithCapInsets:UIEdgeInsetsMake(15,5,14,6)] forState:UIControlStateNormal];
    [[SIAlertView appearance] setDestructiveButtonImage:[[UIImage imageNamed:@"button-destructive-d"] resizableImageWithCapInsets:UIEdgeInsetsMake(15,5,14,6)] forState:UIControlStateHighlighted];

}

- (void)applicationWillResignActive:(UIApplication *)application{

}

- (void)applicationDidEnterBackground:(UIApplication *)application{
}

- (void)applicationWillEnterForeground:(UIApplication *)application{
}

- (void)applicationDidBecomeActive:(UIApplication *)application{
}

- (void)applicationWillTerminate:(UIApplication *)application{
}

-(void) synchronize:(BOOL) afterLogin{
    [NXOAuth2Request performMethod:@"GET"
                        onResource:[CommonFunctions generateUrlWithParams:@"synchronize"]
                   usingParameters:nil
                       withAccount:[CommonFunctions useraccount]
               sendProgressHandler:nil
               responseHandler:^(NSURLResponse *response, NSData *responseData, NSError *error){
                   if(error !=nil){
                       NSLog(@"error user info: %@",[error userInfo]);
                       NSLog(@"full response %@",[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
                       if(afterLogin){
                           [[CBProgressPanel sharedInstance] hide];
                           if([error code] == -1009){
                               [CommonFunctions showNoInternetError];
                           }else{
                               [CommonFunctions showGenericFetchError];
                           }
                       }

                   }else{
                       if([[DataParser sharedInstance] parseSync:responseData]){
                           if(afterLogin){
                               [[CBProgressPanel sharedInstance] hide];
                               [self.viewController dismissViewControllerAnimated:YES completion:nil];
                           }
                       }else{
                           if(afterLogin){
                               [[CBProgressPanel sharedInstance] hide];
                               [CommonFunctions showGenericFetchError];
                           }
                       }
                   }
               }];
    

}

- (void)saveContext{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    NSLog(@"caca");

    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Memetro" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Memetro.sqlite"];
    NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption: @YES, NSInferMappingModelAutomaticallyOption: @YES};
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
@end
