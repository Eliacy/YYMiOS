//
//  Site.m
//  YYMiOS
//
//  Created by Lide on 14-10-25.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "Site.h"

@implementation Site

@synthesize cityName = _cityName;
@synthesize siteId = _siteId;
@synthesize siteName = _siteName;

- (id)initWithAttribute:(NSDictionary *)attribute
{
    self = [super init];
    if(self != nil)
    {
        if(attribute != nil)
        {
            if([attribute objectForKey:@"city_name"] && ![[attribute objectForKey:@"city_name"] isEqual:[NSNull null]])
            {
                self.cityName = [attribute objectForKey:@"city_name"];
            }
            if([attribute objectForKey:@"id"] && ![[attribute objectForKey:@"id"] isEqual:[NSNull null]])
            {
                self.siteId = [[attribute objectForKey:@"id"] integerValue];
            }
            if([attribute objectForKey:@"name"] && ![[attribute objectForKey:@"name"] isEqual:[NSNull null]])
            {
                self.siteName = [attribute objectForKey:@"name"];
            }
        }
    }
    
    return self;
}

@end
