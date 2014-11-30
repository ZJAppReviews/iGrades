//
//  XYZToDoItem.m
//  toDo
//
//  Created by Mauro Vime Castillo on 22/01/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import "XYZToDoItem.h"
#import "XYZBloque.h"

@implementation XYZToDoItem

-(void)actualizarNota {
    double nota = 0.0;
    for (int i = 0; i < [self.bloques count]; ++i) {
        nota += [[self.bloques objectAtIndex:i] returnBloqueValue];
    }
    self.nota = [[NSNumber alloc] initWithDouble:nota];
}

-(double) getNota {
    [self actualizarNota];
    return [self.nota doubleValue];
}

-(double)notaFinal
{
    [self loadValores];
    [self actualizarNota];
    double falta = (self.pass - [self.nota doubleValue]);
    double porcRes = (100 - [self cantComp]);
    if (porcRes == 0) {
        if ([self.nota doubleValue] < self.pass) {
            return 110;
        }
        else {
            return 0;
        }
    }
    else {
        double nota = ((falta/porcRes)*100);
        return nota;
    }
}

-(double)sumaPorcs
{
    double res = 0.0;
    for (int i = 0; i < [self.bloques count]; ++i) {
        XYZBloque *bloque = [self.bloques objectAtIndex:i];
        res += [bloque.porc doubleValue];
    }
    return res;
}

-(double)cantComp
{
    double res = 0;
    for (int i = 0; i < [self.bloques count]; ++i) {
        XYZBloque *bloque = [self.bloques objectAtIndex:i];
        double pesos = 0;
        for (int j = 0; j < [bloque.actes count]; ++j) {
            XYZElemento *elem = [bloque.actes objectAtIndex:j];
            if (elem.nota != nil) pesos += [elem.pes doubleValue];
        }
        res += ((pesos/100) * ([bloque.porc doubleValue]/100));
    }
    return (res*100);
}

-(void)loadValores
{
    self.pass = [[[NSUserDefaults standardUserDefaults] objectForKey:@"PassedValue"] doubleValue];
    self.pass *= 10;
    self.oldMin = [[[NSUserDefaults standardUserDefaults] objectForKey:@"MinValue"] doubleValue];
    self.oldMin *= 10;
    self.oldMax = [[[NSUserDefaults standardUserDefaults] objectForKey:@"MaxValue"] doubleValue];
    self.oldMax *= 10;
}

- (void)encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeObject:self.itemName forKey:@"nom"];
    [coder encodeObject:self.sigles forKey:@"sigles"];
    [coder encodeObject:self.profesor forKey:@"prof"];
    [coder encodeObject:self.creationDate forKey:@"date"];
    [coder encodeObject:self.modificationDate forKey:@"dateModi"];
    [coder encodeObject:self.nota forKey:@"nota"];
    [coder encodeObject:self.color forKey:@"color"];
    [coder encodeObject:self.url forKey:@"url"];
    NSString *fecha = [self.creationDate description];
    NSString *ini = @"arraySaveBloquesMVAsig";
    ini = [[ini stringByAppendingString:self.itemName] stringByAppendingString:fecha];
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.igrades.subjects"];
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:self.bloques] forKey:ini];
}

- (id)initWithCoder:(NSCoder *)coder;
{
    self = [[XYZToDoItem alloc] init];
    if (self != nil) {
        self.itemName = [coder decodeObjectForKey:@"nom"];
        self.sigles = [coder decodeObjectForKey:@"sigles"];
        self.profesor = [coder decodeObjectForKey:@"prof"];
        self.creationDate = [coder decodeObjectForKey:@"date"];
        self.modificationDate = [coder decodeObjectForKey:@"dateModi"];
        self.nota = [coder decodeObjectForKey:@"nota"];
        self.color = [coder decodeObjectForKey:@"color"];
        self.url = [coder decodeObjectForKey:@"url"];
        NSString *ini = @"arraySaveBloquesMVAsig";
        NSString *fecha = [self.creationDate description];
        ini = [[ini stringByAppendingString:self.itemName] stringByAppendingString:fecha];
        NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.igrades.subjects"];
        NSData *savedArray = [defaults objectForKey:ini];
        if (savedArray != nil){
            NSArray *oldArray = [NSKeyedUnarchiver unarchiveObjectWithData:savedArray];
            if (oldArray != nil) {
                self.bloques = [[NSMutableArray alloc] initWithArray:oldArray];
            } else {
                self.bloques = [[NSMutableArray alloc] init];
            }
        }
    }
    return self;
}

-(NSDictionary *)asDictionary
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:9];
    [dic setObject:self.itemName forKey:@"nom"];
    [dic setObject:self.sigles forKey:@"sigles"];
    if (self.profesor == nil) [dic setObject:@"" forKey:@"profesor"];
    else [dic setObject:self.profesor forKey:@"profesor"];
    [dic setObject:self.creationDate forKey:@"creationDate"];
    [dic setObject:self.modificationDate forKey:@"modificationDate"];
    [dic setObject:self.nota forKey:@"nota"];
    [dic setObject:self.color forKey:@"color"];
    if (self.url == nil) [dic setObject:@"" forKey:@"url"];
    else [dic setObject:self.url forKey:@"url"];
    NSMutableDictionary *dicAct = [[NSMutableDictionary alloc] initWithCapacity:[self.bloques count]];
    for(int i = 0; i < [self.bloques count]; ++i) {
        XYZBloque *bloque = [self.bloques objectAtIndex:i];
        [dicAct setObject:[bloque asDictionary] forKey:[NSString stringWithFormat:@"bloque %d",i]];
    }
    [dic setObject:dicAct forKey:@"bloques"];
    return dic;
}

-(void)fromDictionary:(NSDictionary *)dic
{
    self.itemName = [dic objectForKey:@"nom"];
    self.sigles = [dic objectForKey:@"sigles"];
    self.profesor = [dic objectForKey:@"profesor"];
    if ([self.profesor isEqualToString:@""]) self.profesor = nil;
    self.creationDate = [dic objectForKey:@"creationDate"];
    self.modificationDate = [dic objectForKey:@"modificationDate"];
    self.nota = [dic objectForKey:@"nota"];
    self.color = [dic objectForKey:@"color"];
    self.url = [dic objectForKey:@"url"];
    if ([self.url isEqualToString:@""]) self.url = nil;
    NSDictionary *dicAct = [dic objectForKey:@"bloques"];
    self.bloques = [[NSMutableArray alloc] init];
    for (int i = 0; i < [dicAct count]; ++i) {
        XYZBloque *bloque = [[XYZBloque alloc] init];
        [bloque fromDictionary:[dicAct objectForKey:[NSString stringWithFormat:@"bloque %d",i]]];
        [self.bloques addObject:bloque];
    }
}

@end
