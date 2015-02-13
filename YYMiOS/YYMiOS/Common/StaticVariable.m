//
//  StaticVariable.m
//  YYMiOS
//
//  Created by 关旭 on 15-2-12.
//  Copyright (c) 2015年 Lide. All rights reserved.
//

#import "StaticVariable.h"

@implementation StaticVariable

static StaticVariable *_staticVariable = nil;

+ (StaticVariable *) shared{
    if (!_staticVariable) {
        _staticVariable = [[self alloc] init];
    }
    return _staticVariable;
}

@end
