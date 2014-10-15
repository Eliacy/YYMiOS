//
//  Area.h
//  YYMiOS
//
//  Created by lide on 14-10-15.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "LPObject.h"

@interface Area : LPObject
{
    NSInteger       _areaId;
    CGFloat         _areaLatitude;
    CGFloat         _areaLongitude;
    NSString        *_areaName;
    NSInteger       _areaOrder;
}

@property (assign, nonatomic) NSInteger areaId;
@property (assign, nonatomic) CGFloat areaLatitude;
@property (assign, nonatomic) CGFloat areaLongitude;
@property (retain, nonatomic) NSString *areaName;
@property (assign, nonatomic) NSInteger areaOrder;

- (id)initWithAttribute:(NSDictionary *)attribute;

@end
