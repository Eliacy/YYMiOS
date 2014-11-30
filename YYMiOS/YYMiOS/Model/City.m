//
//  City.m
//  YYMiOS
//
//  Created by lide on 14-10-15.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "City.h"
#import "Area.h"

@implementation City

@synthesize cityId = _cityId;
@synthesize cityLatitude = _cityLatitude;
@synthesize cityLongitude = _cityLongitude;
@synthesize cityName = _cityName;
@synthesize cityOrder = _cityOrder;
@synthesize areaArray = _areaArray;
@synthesize title = _title;

- (id)initWithAttribute:(NSDictionary *)attribute
{
    self = [super init];
    if(self != nil)
    {
        if(attribute != nil)
        {
            if([attribute objectForKey:@"id"] && ![[attribute objectForKey:@"id"] isEqual:[NSNull null]])
            {
                self.cityId = [[attribute objectForKey:@"id"] integerValue];
            }
            if([attribute objectForKey:@"latitude"] && ![[attribute objectForKey:@"latitude"] isEqual:[NSNull null]])
            {
                self.cityLatitude = [[attribute objectForKey:@"latitude"] doubleValue];
            }
            if([attribute objectForKey:@"longitude"] && ![[attribute objectForKey:@"longitude"] isEqual:[NSNull null]])
            {
                self.cityLongitude = [[attribute objectForKey:@"longitude"] doubleValue];
            }
            if([attribute objectForKey:@"name"] && ![[attribute objectForKey:@"name"] isEqual:[NSNull null]])
            {
                self.cityName = [attribute objectForKey:@"name"];
            }
            if([attribute objectForKey:@"order"] && ![[attribute objectForKey:@"order"] isEqual:[NSNull null]])
            {
                self.cityOrder = [[attribute objectForKey:@"order"] integerValue];
            }
            if([attribute objectForKey:@"areas"] && ![[attribute objectForKey:@"areas"] isEqual:[NSNull null]])
            {
                NSArray *array = [attribute objectForKey:@"areas"];
                NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:0];
                if(array && [array isKindOfClass:[NSArray class]] && [array count] > 0)
                {
                    for(NSDictionary *dictionary in array)
                    {
                        Area *area = [[Area alloc] initWithAttribute:dictionary];
                        [mutableArray addObject:area];
                        [area release];
                    }
                }
                self.areaArray = mutableArray;
            }
            if([attribute objectForKey:@"name"] && ![[attribute objectForKey:@"name"] isEqual:[NSNull null]])
            {
                self.title = [attribute objectForKey:@"name"];
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
                City *city = [[City alloc] initWithAttribute:attribute];
                [mutableArray addObject:city];
                [city release];
            }
        }
        else if([dictionary isKindOfClass:[NSDictionary class]])
        {
            City *city = [[City alloc] initWithAttribute:dictionary];
            [mutableArray addObject:city];
            [city release];
        }
    }
    else if([dictionary isKindOfClass:[NSArray class]])
    {
        for(NSDictionary *attribute in (NSArray *)dictionary)
        {
            City *city = [[City alloc] initWithAttribute:attribute];
            [mutableArray addObject:city];
            [city release];
        }
    }
    
    return mutableArray;
}

+ (void)getCityListWithCityId:(NSInteger)cityId
                      success:(LPObjectSuccessBlock)successBlock
                      failure:(LPObjectFailureBlock)failureBlock
{
    [[LPAPIClient sharedAPIClient] getCityListWithCityId:cityId
                                                 success:^(id respondObject) {
                                                     if(successBlock)
                                                     {
                                                         successBlock([City parseFromeDictionary:respondObject]);
                                                     }
                                                 } failure:^(NSError *error) {
                                                     if(failureBlock)
                                                     {
                                                         failureBlock(error);
                                                     }
                                                 }];
}

@end
