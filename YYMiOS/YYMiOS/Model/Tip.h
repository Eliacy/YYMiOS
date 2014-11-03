//
//  Tip.h
//  YYMiOS
//
//  Created by Lide on 14-11-4.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "LPObject.h"

@interface Tip : LPObject
{
    NSString    *_content;
    NSString    *_createTime;
    BOOL        _defaultFlag;
    NSInteger   _tipId;
    NSString    *_title;
    NSString    *_updateTime;
}

@property (retain, nonatomic) NSString *content;
@property (retain, nonatomic) NSString *createTime;
@property (assign, nonatomic) BOOL defaultFlag;
@property (assign, nonatomic) NSInteger tipId;
@property (retain, nonatomic) NSString *title;
@property (retain, nonatomic) NSString *updateTime;

@end
