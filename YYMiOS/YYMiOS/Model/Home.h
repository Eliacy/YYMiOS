//
//  Home.h
//  YYMiOS
//
//  Created by lide on 14-9-28.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "LPObject.h"

@interface Home : LPObject
{
    NSString    *_backImageURL;
    NSString    *_homeTitle;
    NSString    *_homeTime;
}

@property (retain, nonatomic) NSString *backImageURL;
@property (retain, nonatomic) NSString *homeTitle;
@property (retain, nonatomic) NSString *homeTime;

@end
