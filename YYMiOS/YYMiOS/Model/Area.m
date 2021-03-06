//
//  Area.m
//  YYMiOS
//
//  Created by lide on 14-10-15.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "Area.h"

@implementation Area

@synthesize areaId = _areaId;
@synthesize areaLatitude = _areaLatitude;
@synthesize areaLongitude = _areaLongitude;
@synthesize areaName = _areaName;
@synthesize areaOrder = _areaOrder;
@synthesize areaChildren = _areaChildren;

- (id)initWithAttribute:(NSDictionary *)attribute
{
    self = [super init];
    if(self != nil)
    {
        if(attribute != nil)
        {
            if([attribute objectForKey:@"id"] && ![[attribute objectForKey:@"id"] isEqual:[NSNull null]])
            {
                self.areaId = [[attribute objectForKey:@"id"] integerValue];
            }
            if([attribute objectForKey:@"latitude"] && ![[attribute objectForKey:@"latitude"] isEqual:[NSNull null]])
            {
                self.areaLatitude = [[attribute objectForKey:@"latitude"] doubleValue];
            }
            if([attribute objectForKey:@"longitude"] && ![[attribute objectForKey:@"longitude"] isEqual:[NSNull null]])
            {
                self.areaLongitude = [[attribute objectForKey:@"longitude"] doubleValue];
            }
            if([attribute objectForKey:@"name"] && ![[attribute objectForKey:@"name"] isEqual:[NSNull null]])
            {
                self.areaName = [attribute objectForKey:@"name"];
            }
            if([attribute objectForKey:@"order"] && ![[attribute objectForKey:@"order"] isEqual:[NSNull null]])
            {
                self.areaOrder = [[attribute objectForKey:@"order"] integerValue];
            }
            if([attribute objectForKey:@"children"] && ![[attribute objectForKey:@"children"] isEqual:[NSNull null]])
            {
                NSArray *array = [attribute objectForKey:@"children"];
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
                self.areaChildren = mutableArray;
            }
        }
    }
    
    return self;
}

@end
