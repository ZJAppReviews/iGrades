//
//  XYZToDoListViewController.h
//  toDo
//
//  Created by Mauro Vime Castillo on 22/01/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYZEditItemViewController.h"

@interface XYZToDoListViewController : UITableViewController

@property NSMutableArray *toDoItems;
@property NSString *tipo;
@property NSString *tipoOrder;
@property double oldMin;
@property double oldMax;
@property double pass;

-(void)guardar;
-(void)loadTipoOrder;
-(void)loadInitialData;
-(void)loadValores;
-(void)loadTipo;
-(void)openWeb:(XYZToDoItem *)item;

@end
