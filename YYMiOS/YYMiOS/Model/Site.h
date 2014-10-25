//
//  Site.h
//  YYMiOS
//
//  Created by Lide on 14-10-25.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "LPObject.h"

@interface Site : LPObject
{
    NSString    *_cityName;
    NSInteger   _siteId;
    NSString    *_siteName;
}

@property (retain, nonatomic) NSString *cityName;
@property (assign, nonatomic) NSInteger siteId;
@property (retain, nonatomic) NSString *siteName;

- (id)initWithAttribute:(NSDictionary *)attribute;

@end
