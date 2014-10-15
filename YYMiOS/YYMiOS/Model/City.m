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
        }
    }
    
    return self;
}

@end
