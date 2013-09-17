//
//  CommonFunctions.h
//  Memetro
//
//  Created by Christian Bongardt on 10/09/13.
//  Copyright (c) 2013 memetro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NXOAuth2.h"

@interface CommonFunctions : NSObject
+ (void) animateView: (UIView *)view withHeight:(int) height up: (BOOL) up;
+(NSURL *) generateUrlWithParams:(NSString *)string;
+(void) showNoInternetError;
+(void) showError:(NSString *) error withTitle:(NSString *)title withDismissHandler:(SIAlertViewHandler)handler;
+(void) showGenericFetchError;
+(NXOAuth2Account *) useraccount;
@end
