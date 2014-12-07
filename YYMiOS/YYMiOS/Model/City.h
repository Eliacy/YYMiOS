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
    NSString        *_title;
    NSString        *_timeZone;
}

@property (assign, nonatomic) NSInteger cityId;
@property (assign, nonatomic) CGFloat cityLatitude;
@property (assign, nonatomic) CGFloat cityLongitude;
@property (retain, nonatomic) NSString *cityName;
@property (assign, nonatomic) NSInteger cityOrder;
@property (retain, nonatomic) NSArray *areaArray;
@property (retain, nonatomic) NSString *title;
@property (retain, nonatomic) NSString *timeZone;

- (id)initWithAttribute:(NSDictionary *)attribute;

+ (void)getCityListWithCityId:(NSInteger)cityId
                      success:(LPObjectSuccessBlock)successBlock
                      failure:(LPObjectFailureBlock)failureBlock;

@end
