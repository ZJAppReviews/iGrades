//
//  XYZBloque.m
//  toDo
//
//  Created by Mauro Vime Castillo on 30/01/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import "XYZBloque.h"
#import "XYZElemento.h"

@implementation XYZBloque

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.nom forKey:@"nomB"];
    [coder encodeObject:self.porc forKey:@"porcB"];
    [coder encodeObject:self.nota forKey:@"notaB"];
    [coder encodeObject:self.creationDate forKey:@"dateB"];
    [coder encodeObject:self.modificationDate forKey:@"dateBModi"];
    NSString *ini = @"arraySaveActesMVAsig";
    NSString *fecha = [self.creationDate description];
    ini = [[ini stringByAppendingString:self.nom] stringByAppendingString:fecha];
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.igrades.subjects"];
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:self.actes] forKey:ini];
    
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [[XYZBloque alloc] init];
    if (self != nil) {
        self.nom = [coder decodeObjectForKey:@"nomB"];
        self.porc = [coder decodeObjectForKey:@"porcB"];
        self.nota = [coder decodeObjectForKey:@"notaB"];
        self.creationDate = [coder decodeObjectForKey:@"dateB"];
        self.modificationDate = [coder decodeObjectForKey:@"dateBModi"];
        NSString *ini = @"arraySaveActesMVAsig";
        NSString *fecha = [self.creationDate description];
        ini = [[ini stringByAppendingString:self.nom] stringByAppendingString:fecha];
        NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.igrades.subjects"];
        NSData *savedArray = [defaults objectForKey:ini];
        if (savedArray != nil){
            NSArray *oldArray = [NSKeyedUnarchiver unarchiveObjectWithData:savedArray];
            if (oldArray != nil) {
                self.actes = [[NSMutableArray alloc] initWithArray:oldArray];
            } else {
                self.actes = [[NSMutableArray alloc] init];
            }
        }
    }
    return self;
}

-(NSDictionary *)asDictionary
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:6];
    [dic setObject:self.nom forKey:@"nom"];
    [dic setObject:self.porc forKey:@"porc"];
    [dic setObject:self.nota forKey:@"nota"];
    [dic setObject:self.creationDate forKey:@"creationDate"];
    [dic setObject:self.modificationDate forKey:@"modificationDate"];
    NSMutableDictionary *dicAct = [[NSMutableDictionary alloc] initWithCapacity:[self.actes count]];
    for(int i = 0; i < [self.actes count]; ++i) {
        XYZElemento *elem = [self.actes objectAtIndex:i];
        [dicAct setObject:[elem asDictionary] forKey:[NSString stringWithFormat:@"elem %d",i]];
    }
    [dic setObject:dicAct forKey:@"actes"];
    return dic;
}

-(void)fromDictionary:(NSDictionary *)dic
{
    self.nom = [dic objectForKey:@"nom"];
    self.porc = [dic objectForKey:@"porc"];
    self.nota = [dic objectForKey:@"nota"];
    self.creationDate = [dic objectForKey:@"creationDate"];
    self.modificationDate = [dic objectForKey:@"modificationDate"];
    NSDictionary *dicAct = [dic objectForKey:@"actes"];
    self.actes = [[NSMutableArray alloc] init];
    for (int i = 0; i < [dicAct count]; ++i) {
        XYZElemento *elem = [[XYZElemento alloc] init];
        [elem fromDictionary:[dicAct objectForKey:[NSString stringWithFormat:@"elem %d",i]]];
        [self.actes addObject:elem];
    }
}

-(double)returnBloqueValue {
    [self recalculateNota];
    return (([self.nota doubleValue]*[self.porc doubleValue])/100);
}


-(double)sumaPorcs
{
    double res = 0;
    for (int i = 0; i < [self.actes count]; ++i) {
        XYZElemento *elem = [self.actes objectAtIndex:i];
        res += [elem.pes doubleValue];
    }
    return res;
}

-(void)recalculateNota {
    double record = 0.0;
    for (int i = 0; i < [self.actes count]; ++i) {
        record += [[self.actes objectAtIndex:i] returnPonderedValue];
    }
    self.nota = [NSNumber numberWithDouble:(record)];
}


-(NSString *)completed
{
    double pes = 0;
    for (int i = 0; i < [self.actes count]; ++i) {
        XYZElemento *acta = [self.actes objectAtIndex:i];
        if (acta.nota != nil) pes += [acta.pes doubleValue];
    }
    return [NSString stringWithFormat:@"%.2f", pes];
}

@end
