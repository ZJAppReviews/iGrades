//
//  XYZBloquesViewController.h
//  toDo
//
//  Created by Mauro Vime Castillo on 30/01/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYZToDoItem.h"
#import "XYZToDoListViewController.h"

@interface XYZBloquesViewController : UITableViewController

@property XYZToDoItem *assig;
@property XYZToDoListViewController *main;
@property NSString *tipo;
@property NSString *tipoOrder;

-(void)sortList;

@end
