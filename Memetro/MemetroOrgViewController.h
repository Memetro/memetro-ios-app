//
//  MemetroOrgViewController.h
//  Memetro
//
//  Created by Christian Bongardt on 05/12/13.
//  Copyright (c) 2013 memetro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface MemetroOrgViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UILabel *trastorno;
@property (weak, nonatomic) IBOutlet UILabel *asociarse;
@property (weak, nonatomic) IBOutlet UILabel *asesoramiento;
@property (weak, nonatomic) IBOutlet UILabel *memetroles;
@property (weak, nonatomic) IBOutlet UILabel *sintomas;
@property (weak, nonatomic) IBOutlet UILabel *contacto;

@end
