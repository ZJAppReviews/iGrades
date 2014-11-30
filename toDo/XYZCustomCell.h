//
//  XYZCustomCell.h
//  toDo
//
//  Created by Mauro Vime Castillo on 29/01/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYZToDoListViewController.h"

@interface XYZCustomCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nomAsig;
@property (weak, nonatomic) IBOutlet UILabel *nomTasca;
@property (weak, nonatomic) IBOutlet UILabel *nomProfesor;
@property (weak, nonatomic) IBOutlet UILabel *numNota;
@property (weak, nonatomic) IBOutlet UIButton *colorB;
@property (weak, nonatomic) IBOutlet UILabel *completed;
@property (weak, nonatomic) IBOutlet UIButton *web;
@property XYZToDoListViewController *papi;
@property XYZToDoItem *asig;

@end
