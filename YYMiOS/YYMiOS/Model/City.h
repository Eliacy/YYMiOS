//
//  City.h
//  YYMiOS
//
//  Created by lide on 14-10-15.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "LPObject.h"

@interface City : LPObject
{
    NSInteger       _cityId;
    CGFloat         _cityLatitude;
    CGFloat         _cityLongitude;
    NSString        *_cityName;
    NSInteger       _cityOrder;
    NSArray         *_areaArray;
}

@property (assign, nonatomic) NSInteger cityId;
@property (assign, nonatomic) CGFloat cityLatitude;
@property (assign, nonatomic) CGFloat cityLongitude;
@property (retain, nonatomic) NSString *cityName;
@property (assign, nonatomic) NSInteger cityOrder;
@property (retain, nonatomic) NSArray *areaArray;

- (id)initWithAttribute:(NSDictionary *)attribute;

@end
