//
//  BaseViewController.m
//  Memetro
//
//  Created by Christian Bongardt on 30/11/13.
//  Copyright (c) 2013 memetro. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDelegate.h"
#import "JASidePanelController.h"
#import "AlertsViewController.h"
#import "CreateAlertViewController.h"
@interface BaseViewController ()

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if(![self isKindOfClass:[AlertsViewController class]]){
            [self addAlertsViewButton];
        
    }

    if(![self isKindOfClass:[CreateAlertViewController class]]){
        [self addAlertCreationButton];
    }
}

-(void) addAlertsViewButton{
    UIButton *b1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 12, 24, 24)];
    [b1 setBackgroundImage:[UIImage imageNamed:@"list-navbar-icon"] forState:UIControlStateNormal];
    [b1 setBackgroundImage:[UIImage imageNamed:@"list-navbbar-icon-active"] forState:UIControlStateHighlighted];
    [b1 setBackgroundImage:[UIImage imageNamed:@"list-navbbar-icon-active"] forState:UIControlStateSelected];
    [b1 addTarget:self action:@selector(showAlertsView) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:b1];

}

-(void) addAlertCreationButton{
    UIButton *b = [[UIButton alloc] init];
    [b setBackgroundImage:[UIImage imageNamed:@"alertbutton-normal"] forState:UIControlStateNormal];
    [b setBackgroundImage:[UIImage imageNamed:@"alertbutton-active"] forState:UIControlStateHighlighted];
    [self.view addSubview:b];
    [b setContentMode:UIViewContentModeBottom];
    b.translatesAutoresizingMaskIntoConstraints = NO;
    NSMutableArray *constraintsForView = [NSMutableArray array];
    NSMutableArray *constraintsForButton = [NSMutableArray array];
    [constraintsForButton addObject:[NSLayoutConstraint constraintWithItem:b
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:Nil
                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                       multiplier:1
                                                         constant:70]];
    [constraintsForButton addObject:[NSLayoutConstraint constraintWithItem:b
                                                       attribute:NSLayoutAttributeWidth
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:nil
                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                      multiplier:1
                                                        constant:146]];
    [constraintsForView addObject:[NSLayoutConstraint constraintWithItem:b
                                                        attribute:NSLayoutAttributeBottom
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.view
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1
                                                         constant:2]];
    [constraintsForView addObject:[NSLayoutConstraint constraintWithItem:b
                                                        attribute:NSLayoutAttributeCenterX
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.view
                                                        attribute:NSLayoutAttributeCenterX
                                                       multiplier:1
                                                         constant:0]];
    [self.view addConstraints:constraintsForView];
    [b addConstraints:constraintsForButton];
    [b addTarget:self action:@selector(showCreateAlert) forControlEvents:UIControlEventTouchUpInside];
    self.createAlertViewButton = b;
}

-(void) showAlertsView{
    AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    delegate.viewController.centerPanel = [[UINavigationController alloc] initWithRootViewController:[[AlertsViewController alloc] initWithNibName:@"AlertsViewController" bundle:nil]];
    
}

-(void) showCreateAlert{

    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:[[CreateAlertViewController alloc] initWithNibName:@"CreateAlertViewController" bundle:nil]] animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
