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
    NSArray     *_contentArray;
    NSString    *_createTime;
    BOOL        _defaultFlag;
    NSInteger   _tipId;
    NSString    *_title;
    NSString    *_updateTime;
}

@property (retain, nonatomic) NSArray *contentArray;
@property (retain, nonatomic) NSString *createTime;
@property (assign, nonatomic) BOOL defaultFlag;
@property (assign, nonatomic) NSInteger tipId;
@property (retain, nonatomic) NSString *title;
@property (retain, nonatomic) NSString *updateTime;

- (id)initWithAttribute:(NSDictionary *)attribute;

+ (void)getTipsListWithTipsId:(NSInteger)tipsId
                        brief:(NSInteger)brief
                       cityId:(NSInteger)cityId
                      success:(LPObjectSuccessBlock)successBlock
                      failure:(LPObjectFailureBlock)failureBlock;

@end
