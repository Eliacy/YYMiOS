//
//  Home.h
//  YYMiOS
//
//  Created by lide on 14-9-28.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "LPObject.h"
#import "LPImage.h"

@interface Article : LPObject
{
    LPImage     *_caption;
    NSInteger   _commentCount;
    NSArray     *_contentArray;
    NSString    *_createTime;
    NSInteger   _articleId;
    NSArray     *_keywordArray;
    NSString    *_title;
    NSString    *_updateTime;
}

@property (retain, nonatomic) LPImage *caption;
@property (assign, nonatomic) NSInteger commentCount;
@property (retain, nonatomic) NSArray *contentArray;
@property (retain, nonatomic) NSString *createTime;
@property (assign, nonatomic) NSInteger articleId;
@property (retain, nonatomic) NSArray *keywordArray;
@property (retain, nonatomic) NSString *title;
@property (retain, nonatomic) NSString *updateTime;

- (id)initWithAttribute:(NSDictionary *)attribute;

+ (void)getArticleListWithArticleId:(NSInteger)articleId
                              brief:(NSInteger)brief
                             offset:(NSInteger)offset
                              limit:(NSInteger)limit
                             cityId:(NSInteger)cityId
                            success:(LPObjectSuccessBlock)successBlock
                            failure:(LPObjectFailureBlock)failureBlcok;

@end