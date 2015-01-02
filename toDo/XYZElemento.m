//
//  XYZElemento.m
//  toDo
//
//  Created by Mauro Vime Castillo on 30/01/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import "XYZElemento.h"

@implementation XYZElemento

- (void)encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeObject:self.nom forKey:@"nomE"];
    [coder encodeObject:self.pes forKey:@"pesE"];
    [coder encodeObject:self.nota forKey:@"notaE"];
    [coder encodeObject:self.creationDate forKey:@"dateE"];
    [coder encodeObject:self.modificationDate forKey:@"dateEModi"];
}

- (id)initWithCoder:(NSCoder *)coder;
{
    self = [[XYZElemento alloc] init];
    if (self != nil) {
        self.nom = [coder decodeObjectForKey:@"nomE"];
        self.pes = [coder decodeObjectForKey:@"pesE"];
        self.nota = [coder decodeObjectForKey:@"notaE"];
        self.creationDate = [coder decodeObjectForKey:@"dateE"];
        self.modificationDate = [coder decodeObjectForKey:@"dateEModi"];
    }
    return self;
}

-(NSDictionary *)asDictionary
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:5];
    [dic setObject:self.nom forKey:@"nom"];
    [dic setObject:self.pes forKey:@"pes"];
    if (self.nota == nil) [dic setObject:[NSNumber numberWithDouble:-1.0] forKey:@"nota"];
    else [dic setObject:self.nota forKey:@"nota"];
    [dic setObject:self.creationDate forKey:@"creationDate"];
    [dic setObject:self.modificationDate forKey:@"modificationDate"];
    return dic;
}

-(void)fromDictionary:(NSDictionary *)dic
{
    self.nom = [dic objectForKey:@"nom"];
    self.pes = [dic objectForKey:@"pes"];
    self.nota = [dic objectForKey:@"nota"];
    if ([self.nota doubleValue] == -1.0) self.nota = nil;
    self.creationDate = [dic objectForKey:@"creationDate"];
    self.modificationDate = [dic objectForKey:@"modificationDate"];
}

-(double)returnPonderedValue {
    double val = 0;
    if (self.nota != nil) val = [self.nota doubleValue] * [self.pes doubleValue];
    return (val/100);
}

@end
