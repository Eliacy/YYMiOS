//
//  User.m
//  YYMiOS
//
//  Created by lide on 14-10-10.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "User.h"

@implementation User

@synthesize userIcon = _userIcon;
@synthesize userId = _userId;
@synthesize userName = _userName;

- (id)initWithAttribute:(NSDictionary *)attribute
{
    self = [super init];
    if(self != nil)
    {
        if(attribute != nil)
        {
            if([attribute objectForKey:@"icon"] && ![[attribute objectForKey:@"icon"] isEqual:[NSNull null]])
            {
                NSDictionary *dictionary = [attribute objectForKey:@"icon"];
                if(dictionary && [dictionary isKindOfClass:[NSDictionary class]])
                {
                    LPImage *icon = [[[LPImage alloc] initWithAttribute:dictionary] autorelease];
                    self.userIcon = icon;
                }
            }
            if([attribute objectForKey:@"id"] && ![[attribute objectForKey:@"id"] isEqual:[NSNull null]])
            {
                self.userId = [[attribute objectForKey:@"id"] integerValue];
            }
            if([attribute objectForKey:@"name"] && ![[attribute objectForKey:@"name"] isEqual:[NSNull null]])
            {
                self.userName = [attribute objectForKey:@"name"];
            }
        }
    }
    
    return self;
}

@end
