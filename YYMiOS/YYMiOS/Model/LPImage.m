//
//  LPImage.m
//  YYMiOS
//
//  Created by Lide on 14-10-25.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "LPImage.h"

@implementation LPImage

@synthesize imageId = _imageId;
@synthesize imageURL = _imageURL;

- (id)initWithAttribute:(NSDictionary *)attribute
{
    self = [super init];
    if(self != nil)
    {
        if(attribute != nil)
        {
            if([attribute objectForKey:@"id"] && ![[attribute objectForKey:@"id"] isEqual:[NSNull null]])
            {
                self.imageId = [[attribute objectForKey:@"id"] integerValue];
            }
            if([attribute objectForKey:@"url"] && ![[attribute objectForKey:@"url"] isEqual:[NSNull null]])
            {
                self.imageURL = [attribute objectForKey:@"url"];
            }
        }
    }
    
    return self;
}

@end
