//
//  Forecast.h
//  YYMiOS
//
//  Created by Lide on 14/12/7.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "LPObject.h"

@interface Forecast : LPObject
{
    NSString    *_condiction;
    NSInteger   _high;
    NSInteger   _low;
    NSInteger   _temp;
    NSString    *_time;
    NSInteger   _typeId;
    NSString    *_typeName;
    NSString    *_weekday;
    BOOL        _isNight;
}

@property (retain, nonatomic) NSString *condiction;
@property (assign, nonatomic) NSInteger high;
@property (assign, nonatomic) NSInteger low;
@property (assign, nonatomic) NSInteger temp;
@property (retain, nonatomic) NSString *time;
@property (assign, nonatomic) NSInteger typeId;
@property (retain, nonatomic) NSString *typeName;
@property (retain, nonatomic) NSString *weekday;
@property (assign, nonatomic) BOOL isNight;

- (id)initWithAttribute:(NSDictionary *)attribute;

@end
