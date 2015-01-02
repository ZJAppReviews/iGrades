//
//  XYZToDoItem.h
//  toDo
//
//  Created by Mauro Vime Castillo on 22/01/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYZBloque.h"
#import <UIKit/UIKit.h>

@interface XYZToDoItem : NSObject

@property NSString *itemName;
@property NSString *sigles;
@property NSString *profesor;
@property NSNumber *nota;
@property NSDate   *creationDate;
@property NSDate   *modificationDate;
@property NSMutableArray *bloques;
@property UIColor *color;
@property NSString *url;

@property double oldMin;
@property double oldMax;
@property double pass;

-(void)actualizarNota;
-(double)getNota;
-(double)notaFinal;
-(double)sumaPorcs;
-(double)cantComp;
-(NSDictionary *)asDictionary;
-(void)fromDictionary:(NSDictionary *)dic;

@end
