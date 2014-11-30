//
//  XYZAddElementoViewController.h
//  toDo
//
//  Created by Mauro Vime Castillo on 30/01/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYZElemento.h"
#import "XYZBloque.h"

@interface XYZAddElementoViewController : UIViewController

@property XYZElemento *elem;
@property XYZBloque *bloque;
@property UIColor *color;
@property NSString *tipo;

@end
