//
//  XYZElemento.h
//  toDo
//
//  Created by Mauro Vime Castillo on 30/01/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYZElemento : NSObject

@property NSString *nom;
@property NSNumber *pes;
@property NSNumber *nota;
@property NSDate   *creationDate;
@property NSDate   *modificationDate;

-(double)returnPonderedValue;
-(NSDictionary *)asDictionary;
-(void)fromDictionary:(NSDictionary *)dic;

@end
