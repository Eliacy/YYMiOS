//
//  Country.m
//  YYMiOS
//
//  Created by lide on 14-10-15.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "Country.h"
#import "City.h"

@implementation Country

@synthesize countryId = _countryId;
@synthesize defaultCityId = _defaultCityId;
@synthesize countryName = _countryName;
@synthesize countryOrder = _countryOrder;
@synthesize cityArray = _cityArray;

- (id)initWithAttribute:(NSDictionary *)attribute
{
    self = [super init];
    if(self != nil)
    {
        if(attribute != nil)
        {
            if([attribute objectForKey:@"id"] && ![[attribute objectForKey:@"id"] isEqual:[NSNull null]])
            {
                self.countryId = [[attribute objectForKey:@"id"] integerValue];
            }
            if([attribute objectForKey:@"default_city_id"] && ![[attribute objectForKey:@"default_city_id"] isEqual:[NSNull null]])
            {
                self.defaultCityId = [[attribute objectForKey:@"default_city_id"] integerValue];
            }
            if([attribute objectForKey:@"name"] && ![[attribute objectForKey:@"name"] isEqual:[NSNull null]])
            {
                self.countryName = [attribute objectForKey:@"name"];
            }
            if([attribute objectForKey:@"order"] && ![[attribute objectForKey:@"order"] isEqual:[NSNull null]])
            {
                self.countryOrder = [[attribute objectForKey:@"order"] integerValue];
            }
            if([attribute objectForKey:@"cities"] && ![[attribute objectForKey:@"cities"] isEqual:[NSNull null]])
            {
                NSArray *array = [attribute objectForKey:@"cities"];
                NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:0];
                if(array && [array isKindOfClass:[NSArray class]] && [array count] > 0)
                {
                    for(NSDictionary *dictionary in array)
                    {
                        City *city = [[City alloc] initWithAttribute:dictionary];
                        [mutableArray addObject:city];
                        [city release];
                    }
                }
                self.cityArray = mutableArray;
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
                Country *country = [[Country alloc] initWithAttribute:attribute];
                [mutableArray addObject:country];
                [country release];
            }
        }
        else if([dictionary isKindOfClass:[NSDictionary class]])
        {
            Country *country = [[Country alloc] initWithAttribute:dictionary];
            [mutableArray addObject:country];
            [country release];
        }
    }
    else if([dictionary isKindOfClass:[NSArray class]])
    {
        for(NSDictionary *attribute in (NSArray *)dictionary)
        {
            Country *country = [[Country alloc] initWithAttribute:attribute];
            [mutableArray addObject:country];
            [country release];
        }
    }
    
    return mutableArray;
}

+ (void)getCountryListWithCountryId:(NSInteger)countryId
                          longitude:(float)longitude
                           latitude:(float)latitude
                              success:(LPObjectSuccessBlock)successBlock
                              failure:(LPObjectFailureBlock)failureBlock
{
    [[LPAPIClient sharedAPIClient] getCountryListWithCountryId:countryId
                                                     longitude:longitude
                                                      latitude:latitude
                                                         success:^(id respondObject) {
                                                             if(successBlock)
                                                             {
                                                                 successBlock([Country parseFromeDictionary:respondObject]);
                                                             }
                                                         } failure:^(NSError *error) {
                                                             if(failureBlock)
                                                             {
                                                                 failureBlock(error);
                                                             }
                                                         }];
}


@end
