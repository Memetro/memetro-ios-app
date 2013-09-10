//
//  AlertsViewController.m
//  Memetro
//
//  Created by Christian Bongardt on 18/08/13.
//  Copyright (c) 2013 memetro. All rights reserved.
//

#import "AlertsViewController.h"

#import "MapViewController.h"
#import "ListViewController.h"
#import "TweetViewController.h"

@interface AlertsViewController ()

@end

@implementation AlertsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initNavbar];
    [self initChilds];
    [self addFirstChild];
}

-(void) initNavbar{
    NSMutableArray *rightButtons = [[NSMutableArray alloc]init];
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 140, 44)];
    
    UIButton *b3 = [[UIButton alloc] initWithFrame:CGRectMake(110, 12, 19, 23)];
    [b3 setBackgroundImage:[UIImage imageNamed:@"map-navbar-icon"] forState:UIControlStateNormal];
    [b3 setBackgroundImage:[UIImage imageNamed:@"map-navbar-icon-active"] forState:UIControlStateHighlighted];
    [b3 setBackgroundImage:[UIImage imageNamed:@"map-navbar-icon-active"] forState:UIControlStateSelected];
    [b3 addTarget:self action:@selector(changeToMap) forControlEvents:UIControlEventTouchUpInside];
    self.mapButton = b3;
    [v addSubview:b3];
    
    UIButton *b2 = [[UIButton alloc] initWithFrame:CGRectMake(60, 12, 16, 23)];
    [b2 setBackgroundImage:[UIImage imageNamed:@"twitter-navbar-icon"] forState:UIControlStateNormal];
    [b2 setBackgroundImage:[UIImage imageNamed:@"twitter-navbar-icon-active"] forState:UIControlStateHighlighted];
        [b2 setBackgroundImage:[UIImage imageNamed:@"twitter-navbar-icon-active"] forState:UIControlStateSelected];
    [b2 addTarget:self action:@selector(changeToTweet) forControlEvents:UIControlEventTouchUpInside];
    self.tweetButton = b2;
    [v addSubview:b2];
    
    UIButton *b1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 12, 24, 24)];
    [b1 setBackgroundImage:[UIImage imageNamed:@"list-navbar-icon"] forState:UIControlStateNormal];
    [b1 setBackgroundImage:[UIImage imageNamed:@"list-navbbar-icon-active"] forState:UIControlStateHighlighted];
    [b1 setBackgroundImage:[UIImage imageNamed:@"list-navbbar-icon-active"] forState:UIControlStateSelected];
    [b1 addTarget:self action:@selector(changeToList) forControlEvents:UIControlEventTouchUpInside];
    self.listButton = b1;
    
    [v addSubview:b1];
    [rightButtons addObject:[[UIBarButtonItem alloc] initWithCustomView:v]];
    self.navigationItem.rightBarButtonItems = rightButtons;
}

-(void) changeToMap{
    if([self.presentedView isKindOfClass:[MapViewController class]]){
        return;
    }
    [self switchFromContentViewController:self.presentedView toContentViewCOntroller:self.mapView toLeft:YES];
    self.presentedView = self.mapView;
    [self.mapButton setSelected:YES];
    [self.tweetButton setSelected:NO];
    [self.listButton setSelected:NO];

}

-(void) changeToTweet{
    if ([self.presentedView isKindOfClass:[TweetViewController class]]){
        return;
    }
    if([self.presentedView isKindOfClass:[MapViewController class]]){
        [self switchFromContentViewController:self.presentedView toContentViewCOntroller:self.tweetView toLeft:NO];
        self.presentedView = self.tweetView;
    }else{
        [self switchFromContentViewController:self.presentedView toContentViewCOntroller:self.tweetView toLeft:YES];
        self.presentedView = self.tweetView;
    }
    [self.mapButton setSelected:NO];
    [self.tweetButton setSelected:YES];
    [self.listButton setSelected:NO];
    
}

-(void) changeToList{
    if ([self.presentedView isKindOfClass:[ListViewController class]]){
        return;
    }
    [self switchFromContentViewController:self.presentedView toContentViewCOntroller:self.listView toLeft:NO];
    self.presentedView = self.listView;
    [self.mapButton setSelected:NO];
    [self.tweetButton setSelected:NO];
    [self.listButton setSelected:YES];

}

-(void) initChilds{
    self.mapView = [[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil];
    self.tweetView = [[TweetViewController alloc] initWithNibName:@"TweetViewController" bundle:nil];
    self.listView = [[ListViewController alloc] initWithNibName:@"ListViewController" bundle:nil];
}

-(void) addFirstChild{
    [self displayContentViewController:self.listView];
    self.presentedView = self.listView;
    [self.listButton setSelected:YES];
}


-(void) switchFromContentViewController:(UIViewController *)oldC toContentViewCOntroller:(UIViewController *)newC toLeft:(BOOL) left{
    [self addChildViewController:newC];
    [self.view addSubview:newC.view];
    [newC.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSDictionary *views = @{ @"newView" : newC.view,@"oldView":oldC.view };
    NSMutableArray *newViewStartConstraints = [NSMutableArray new];
    
    if(!left){
        [newViewStartConstraints addObjectsFromArray:[NSLayoutConstraint
                                                      constraintsWithVisualFormat:@"[newView(320)]-320-|"
                                                      options:0
                                                      metrics:nil
                                                      views:views]];
        
    }else{
        [newViewStartConstraints addObjectsFromArray:[NSLayoutConstraint
                                                      constraintsWithVisualFormat:@"|-320-[newView(320)]"
                                                      options:0
                                                      metrics:nil
                                                      views:views]];
        
    }
    
    [newViewStartConstraints addObjectsFromArray:[NSLayoutConstraint
                                                  constraintsWithVisualFormat:@"V:|[newView]|"
                                                  options:0
                                                  metrics:nil
                                                  views:views]];
    
    [self.view addConstraints:newViewStartConstraints];
    [newC.view layoutIfNeeded];
    
    [self.view removeConstraints:self.constraints];
    NSMutableArray *oldViewEndConstraints = [NSMutableArray new];
    if(!left){
        [oldViewEndConstraints addObjectsFromArray:[NSLayoutConstraint
                                                    constraintsWithVisualFormat:@"|-640-[oldView(320)]"
                                                    options:0
                                                    metrics:nil
                                                    views:views]];
    }else{
        [oldViewEndConstraints addObjectsFromArray:[NSLayoutConstraint
                                                    constraintsWithVisualFormat:@"[oldView(320)]-640-|"
                                                    options:0
                                                    metrics:nil
                                                    views:views]];
    }
    
    [oldViewEndConstraints addObjectsFromArray:[NSLayoutConstraint
                                                constraintsWithVisualFormat:@"V:|[oldView]|"
                                                options:0
                                                metrics:nil
                                                views:views]];
    
    [self.view addConstraints:oldViewEndConstraints];
    [self.view removeConstraints:newViewStartConstraints];
    self.constraints= [NSMutableArray new];
    [self.constraints addObjectsFromArray:[NSLayoutConstraint
                                           constraintsWithVisualFormat:@"|[newView]|"
                                           options:0
                                           metrics:nil
                                           views:views]];
    [self.constraints addObjectsFromArray:[NSLayoutConstraint
                                           constraintsWithVisualFormat:@"V:|[newView]|"
                                           options:0
                                           metrics:nil
                                           views:views]];
    [self.view addConstraints:self.constraints];
    [UIView animateWithDuration:.5 animations:^{
        [oldC.view layoutIfNeeded];
        [newC.view layoutIfNeeded];
        
    }completion:^(BOOL finised){
        [oldC willMoveToParentViewController:nil];
        [oldC.view removeFromSuperview];
        [oldC removeFromParentViewController];
        [self.view  removeConstraints:oldViewEndConstraints];
    }];
}

-(void) displayContentViewController:(UIViewController *) controller{
    [self addChildViewController:controller];
    [self.view addSubview:controller.view];
    [self.view sendSubviewToBack:controller.view];
    [controller.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSDictionary *views = @{ @"view" : controller.view};
    self.constraints = [NSMutableArray new];
    [self.constraints addObjectsFromArray:[NSLayoutConstraint
                                           constraintsWithVisualFormat:@"|[view]|"
                                           options:0
                                           metrics:nil
                                           views:views]];
    [self.constraints addObjectsFromArray:[NSLayoutConstraint
                                           constraintsWithVisualFormat:@"V:|[view]|"
                                           options:0
                                           metrics:nil
                                           views:views]];
    [self.view addConstraints:self.constraints];
    [controller didMoveToParentViewController:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
