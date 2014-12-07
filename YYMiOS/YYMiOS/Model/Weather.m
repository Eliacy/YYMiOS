//
//  Weather.m
//  YYMiOS
//
//  Created by Lide on 14/12/7.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "Weather.h"

@implementation Weather

@synthesize city = _city;
@synthesize currentForecast = _currentForecast;
@synthesize forecastArray = _forecastArray;

- (id)initWithAttribute:(NSDictionary *)attribute
{
    self = [super init];
    if(self != nil)
    {
        if(attribute != nil)
        {
            if([attribute objectForKey:@"city"] && ![[attribute objectForKey:@"city"] isEqual:[NSNull null]])
            {
                NSDictionary *cityDictionary = [attribute objectForKey:@"city"];
                if(cityDictionary && [cityDictionary isKindOfClass:[NSDictionary class]])
                {
                    City *city = [[[City alloc] initWithAttribute:cityDictionary] autorelease];
                    self.city = city;
                }
            }
            if([attribute objectForKey:@"current"] && ![[attribute objectForKey:@"current"] isEqual:[NSNull null]])
            {
                NSDictionary *currentDictionary = [attribute objectForKey:@"current"];
                if(currentDictionary && [currentDictionary isKindOfClass:[NSDictionary class]])
                {
                    Forecast *current = [[[Forecast alloc] initWithAttribute:currentDictionary] autorelease];
                    self.currentForecast = current;
                }
            }
            if([attribute objectForKey:@"forecasts"] && ![[attribute objectForKey:@"forecasts"] isEqual:[NSNull null]])
            {
                NSArray *array = [attribute objectForKey:@"forecasts"];
                NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:0];
                if(array && [array isKindOfClass:[NSArray class]] && [array count] > 0)
                {
                    for(NSDictionary *dictionary in array)
                    {
                        Forecast *forecast = [[[Forecast alloc] initWithAttribute:dictionary] autorelease];
                        [mutableArray addObject:forecast];
                    }
                }
                self.forecastArray = mutableArray;
            }
        }
    }
    
    return self;
}

+ (NSArray *)parseFromeDictionary:(NSDictionary *)dictionary
{
    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:0];
    
    if(dictionary && [dictionary isKindOfClass:[NSDictionary class]])
    {
        if([dictionary objectForKey:@"data"])
        {
            dictionary = [dictionary objectForKey:@"data"];
        }
        
        if([dictionary isKindOfClass:[NSArray class]])
        {
            for(NSDictionary *attribute in (NSArray *)dictionary)
            {
                Weather *weather = [[Weather alloc] initWithAttribute:attribute];
                [mutableArray addObject:weather];
                [weather release];
            }
        }
        else if([dictionary isKindOfClass:[NSDictionary class]])
        {
            Weather *weather = [[Weather alloc] initWithAttribute:dictionary];
            [mutableArray addObject:weather];
            [weather release];
        }
    }
    else if([dictionary isKindOfClass:[NSArray class]])
    {
        for(NSDictionary *attribute in (NSArray *)dictionary)
        {
            Weather *weather = [[Weather alloc] initWithAttribute:attribute];
            [mutableArray addObject:weather];
            [weather release];
        }
    }
    
    return mutableArray;
}

+ (void)getCityForecastWithCityId:(NSInteger)cityId
                          success:(LPObjectSuccessBlock)successBlock
                          failure:(LPObjectFailureBlock)failureBlock
{
    [[LPAPIClient sharedAPIClient] getCityForecastWithCityId:cityId
                                                     success:^(id respondObject) {
                                                         if(successBlock)
                                                         {
                                                             successBlock([Weather parseFromeDictionary:respondObject]);
                                                         }
                                                     } failure:^(NSError *error) {
                                                         if(failureBlock)
                                                         {
                                                             failureBlock(error);
                                                         }
                                                     }];
}

@end
