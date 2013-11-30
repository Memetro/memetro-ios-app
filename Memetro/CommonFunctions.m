//
//  CommonFunctions.m
//  Memetro
//
//  Created by Christian Bongardt on 10/09/13.
//  Copyright (c) 2013 memetro. All rights reserved.
//

#import "CommonFunctions.h"

@implementation CommonFunctions
+ (void) animateView: (UIView *)view withHeight:(int) height up: (BOOL) up {
    const float movementDuration = 0.25f;
    int movement = (up ? -height   : height);
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    view.frame = CGRectOffset(view.frame, 0, movement);
    [UIView commitAnimations];
}
+(NSURL *) generateUrlWithParams:(NSString *)string{
    NSString *urlstring =[BASE_URL stringByAppendingFormat:@"%@",string];
    return [NSURL URLWithString:urlstring];
}


+(void) showNoInternetError{
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:NSLocalizedString(@"offlinetitle", @"") andMessage:NSLocalizedString(@"offlinedescription", @"")];
    [alertView addButtonWithTitle:NSLocalizedString(@"okbutton", @"")
                             type:SIAlertViewButtonTypeCancel
                          handler:nil];
    alertView.transitionStyle = SIAlertViewTransitionStyleDropDown;
    [alertView show];
}

+(void) showError:(NSString *) error withTitle:(NSString *)title withDismissHandler:(SIAlertViewHandler)handler{
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:title andMessage:error];
    [alertView addButtonWithTitle:NSLocalizedString(@"okbutton", @"")
                             type:SIAlertViewButtonTypeCancel
                          handler:nil];
    alertView.transitionStyle = SIAlertViewTransitionStyleDropDown;
    alertView.willDismissHandler = handler;
    [alertView show];
}

+(void) showGenericFetchError{
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:NSLocalizedString(@"genericfetcherrortitle", @"") andMessage:NSLocalizedString(@"genericfetcherror", @"")];
    [alertView addButtonWithTitle:NSLocalizedString(@"okbutton", @"")
                             type:SIAlertViewButtonTypeCancel
                          handler:nil];
    alertView.transitionStyle = SIAlertViewTransitionStyleDropDown;
    [alertView show];
}

+(NXOAuth2Account *) useraccount{
    static NXOAuth2Account* account = nil;
    if(account == nil){
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString *identifier = [prefs stringForKey:@"accountidentifier"];
        account = [[NXOAuth2AccountStore sharedStore] accountWithIdentifier:identifier];
    }
    return account;
}

@end
