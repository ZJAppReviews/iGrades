//
//  XYZCloudConfigTableViewCell.h
//  iNotas
//
//  Created by Mauro Vime Castillo on 12/08/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SevenSwitch.h"
#import "XYZContactViewController.h"

@interface XYZCloudConfigTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *texto;
@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet SevenSwitch *sswitch;
@property XYZContactViewController *papi;

@end
