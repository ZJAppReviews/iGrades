//
//  XYZContactViewController.h
//  iNotas
//
//  Created by Mauro Vime Castillo on 31/01/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "XYZToDoListViewController.h"
#import "MBProgressHUD.h"

@interface XYZContactViewController : UITableViewController

@property NSString *tipo;

@property NSString *tipoOrder;

@property XYZToDoListViewController *main;

@property MBProgressHUD *HUD;

-(void) updateCloud;

@end
