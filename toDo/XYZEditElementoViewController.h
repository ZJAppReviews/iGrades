//
//  XYZEditElementoViewController.h
//  iNotas
//
//  Created by Mauro Vime Castillo on 31/01/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYZElemento.h"
#import "XYZBloque.h"
#import "XYZToDoItem.h"

@interface XYZEditElementoViewController : UIViewController

@property XYZElemento *elemento;
@property XYZBloque *bloque;
@property XYZToDoItem *assig;
@property UIColor *color;
@property NSString *tipo;

@end
