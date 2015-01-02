//
//  XYZElementosViewController.h
//  toDo
//
//  Created by Mauro Vime Castillo on 30/01/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYZBloque.h"
#import "XYZBloquesViewController.h"

@interface XYZElementosViewController : UITableViewController

@property XYZBloque *bloque;
@property XYZBloquesViewController *mainB;
@property NSString *tipo;
@property NSString *tipoOrder;

@end
