//
//  Weather.h
//  YYMiOS
//
//  Created by Lide on 14/12/7.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "LPObject.h"
#import "City.h"
#import "Forecast.h"

@interface Weather : LPObject
{
    City        *_city;
    Forecast    *_currentForecast;
    NSArray     *_forecastArray;
}

@property (retain, nonatomic) City *city;
@property (retain, nonatomic) Forecast *currentForecast;
@property (retain, nonatomic) NSArray *forecastArray;

- (id)initWithAttribute:(NSDictionary *)attribute;

+ (void)getCityForecastWithCityId:(NSInteger)cityId
                          success:(LPObjectSuccessBlock)successBlock
                          failure:(LPObjectFailureBlock)failureBlock;

@end
