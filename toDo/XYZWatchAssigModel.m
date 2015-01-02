//
//  XYZWatchAssigModel.m
//  iNotas
//
//  Created by Mauro Vime Castillo on 20/11/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import "XYZWatchAssigModel.h"

@implementation XYZWatchAssigModel

- (void)encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeObject:self.sigles forKey:@"sigles"];
    [coder encodeObject:self.nota forKey:@"nota"];
    [coder encodeObject:self.completed forKey:@"comp"];
    [coder encodeObject:self.notaType forKey:@"notaType"];
    [coder encodeObject:self.color forKey:@"color"];
}

- (id)initWithCoder:(NSCoder *)coder;
{
    self = [[XYZWatchAssigModel alloc] init];
    if (self != nil) {
        self.sigles = [coder decodeObjectForKey:@"sigles"];
        self.nota = [coder decodeObjectForKey:@"nota"];
        self.completed = [coder decodeObjectForKey:@"comp"];
        self.notaType = [coder decodeObjectForKey:@"notaType"];
        self.color = [coder decodeObjectForKey:@"color"];
    }
    return self;
}

@end
