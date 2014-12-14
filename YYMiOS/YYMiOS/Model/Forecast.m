//
//  Forecast.m
//  YYMiOS
//
//  Created by Lide on 14/12/7.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "Forecast.h"

@implementation Forecast

@synthesize condiction = _condiction;
@synthesize high = _high;
@synthesize low = _low;
@synthesize temp = _temp;
@synthesize time = _time;
@synthesize typeId = _typeId;
@synthesize typeName = _typeName;
@synthesize weekday = _weekday;
@synthesize isNight = _isNight;

- (id)initWithAttribute:(NSDictionary *)attribute
{
    self = [super init];
    if(self != nil)
    {
        if(attribute != nil)
        {
            if([attribute objectForKey:@"conditions"] && ![[attribute objectForKey:@"conditions"] isEqual:[NSNull null]])
            {
                self.condiction = [attribute objectForKey:@"conditions"];
            }
            if([attribute objectForKey:@"high"] && ![[attribute objectForKey:@"high"] isEqual:[NSNull null]])
            {
                self.high = [[attribute objectForKey:@"high"] integerValue];
            }
            if([attribute objectForKey:@"low"] && ![[attribute objectForKey:@"low"] isEqual:[NSNull null]])
            {
                self.low = [[attribute objectForKey:@"low"] integerValue];
            }
            if([attribute objectForKey:@"temp"] && ![[attribute objectForKey:@"temp"] isEqual:[NSNull null]])
            {
                self.temp = [[attribute objectForKey:@"temp"] integerValue];
            }
            if([attribute objectForKey:@"time"] && ![[attribute objectForKey:@"time"] isEqual:[NSNull null]])
            {
                self.time = [attribute objectForKey:@"time"];
            }
            if([attribute objectForKey:@"type_id"] && ![[attribute objectForKey:@"type_id"] isEqual:[NSNull null]])
            {
                self.typeId = [[attribute objectForKey:@"type_id"] integerValue];
            }
            if([attribute objectForKey:@"type_name"] && ![[attribute objectForKey:@"type_name"] isEqual:[NSNull null]])
            {
                self.typeName = [attribute objectForKey:@"type_name"];
            }
            if([attribute objectForKey:@"weekday"] && ![[attribute objectForKey:@"weekday"] isEqual:[NSNull null]])
            {
                self.weekday = [attribute objectForKey:@"weekday"];
            }
            if([attribute objectForKey:@"is_night"] && ![[attribute objectForKey:@"is_night"] isEqual:[NSNull null]])
            {
                self.isNight = [[attribute objectForKey:@"is_night"] boolValue];
            }
        }
    }
    
    return self;
}

@end
