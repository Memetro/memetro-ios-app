//
//  MemetroOrgViewController.m
//  Memetro
//
//  Created by Christian Bongardt on 05/12/13.
//  Copyright (c) 2013 memetro. All rights reserved.
//

#import "MemetroOrgViewController.h"
#import "WebViewController.h"
@interface MemetroOrgViewController ()

@end

@implementation MemetroOrgViewController

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
    self.asesoramiento.text = NSLocalizedString(@"Advice", @"");
    self.asesoramiento.superview.userInteractionEnabled = YES;
    [self.asesoramiento.superview addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushasesoramiento)]];
    self.memetroles.text = NSLocalizedString(@"Memetrols", @"");
    self.memetroles.superview.userInteractionEnabled = YES;
    [self.memetroles.superview addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushmemetroles)]];
    self.sintomas.text = NSLocalizedString(@"Symptoms", @"");
    self.sintomas.superview.userInteractionEnabled = YES;
    [self.sintomas.superview addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushsintomas)]];
    self.asociarse.text = NSLocalizedString(@"Become associated", @"");
    self.asociarse.superview.userInteractionEnabled = YES;
    [self.asociarse.superview addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushasociarse)]];
    self.contacto.text = NSLocalizedString(@"Contact", @"");
    self.contacto.superview.userInteractionEnabled =YES;
    [self.contacto.superview addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushcontacto)]];
    self.trastorno.text = NSLocalizedString(@"Memetro disorder", @"");
    self.trastorno.superview.userInteractionEnabled = YES;
    [self.trastorno.superview addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushtrastorno)]];
}


-(void) pushasesoramiento{
    WebViewController *w = [[WebViewController alloc] init];
    w.url = [NSURL URLWithString:@"http://www.memetro.net/asesoramiento-legal/"];
    [self.navigationController pushViewController:w animated:YES];
}

-(void) pushmemetroles{
    WebViewController *w = [[WebViewController alloc] init];
    w.url = [NSURL URLWithString:@"http://www.memetro.net/memetroles/"];
    [self.navigationController pushViewController:w animated:YES];
    
}
-(void) pushsintomas{
    WebViewController *w = [[WebViewController alloc] init];
    w.url = [NSURL URLWithString:@"http://www.memetro.net/vivir-con-el-trastono/"];
    [self.navigationController pushViewController:w animated:YES];
    
}
-(void) pushasociarse{
    WebViewController *w = [[WebViewController alloc] init];
    w.url = [NSURL URLWithString:@"http://www.memetro.net/asociarse/"];
    [self.navigationController pushViewController:w animated:YES];
    
}
-(void) pushcontacto{
    WebViewController *w = [[WebViewController alloc] init];
    w.url = [NSURL URLWithString:@"http://www.memetro.net/contacto/"];
    [self.navigationController pushViewController:w animated:YES];
    
}
-(void) pushtrastorno{
    WebViewController *w = [[WebViewController alloc] init];
    w.url = [NSURL URLWithString:@"http://www.memetro.net/trastorno-memetro/"];
    [self.navigationController pushViewController:w animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
