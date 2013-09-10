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
#import "CBProgressPanel.h"

@implementation AppDelegate

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
            return;
        }
    }
    LoginViewController *login = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    login.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self.viewController presentViewController:login animated:NO completion:nil];
}

-(void) setupLoginLogic{
    [[NXOAuth2AccountStore sharedStore]
     setClientID:@"NTFmMDU3YmY2ZDFkMDFl"
     secret:@"2cb128799bb3886281c6b7a89b7ac0047c06b876"
     authorizationURL:[NSURL URLWithString:@"http://memetro.bongardt.co/oauth/token"]
     tokenURL:[NSURL URLWithString:@"http://memetro.bongardt.co/oauth/token"]
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
             [[CBProgressPanel sharedInstance] hide];
             [self.viewController dismissViewControllerAnimated:YES completion:nil];
         }

     }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:NXOAuth2AccountStoreDidFailToRequestAccessNotification
    object:[NXOAuth2AccountStore sharedStore]
    queue:nil
    usingBlock:^(NSNotification *aNotification){
        NSError *error = [aNotification.userInfo objectForKey:NXOAuth2AccountStoreErrorKey];
        NSLog(@"error %@",error);
        [[CBProgressPanel sharedInstance] hide];
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

@end
