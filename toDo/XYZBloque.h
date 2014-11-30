//
//  XYZBloque.h
//  toDo
//
//  Created by Mauro Vime Castillo on 30/01/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYZElemento.h"

@interface XYZBloque : NSObject

@property NSString *nom;
@property NSNumber *porc;
@property NSNumber *nota;
@property NSMutableArray *actes;
@property NSDate   *creationDate;
@property NSDate   *modificationDate;

-(double)returnBloqueValue;
-(void)recalculateNota;
-(double)sumaPorcs;
-(NSString *)completed;
-(NSDictionary *)asDictionary;
-(void)fromDictionary:(NSDictionary *)dic;

@end
