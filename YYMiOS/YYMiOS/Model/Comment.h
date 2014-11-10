//
//  Comment.h
//  YYMiOS
//
//  Created by Lide on 14-11-11.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "LPObject.h"
#import "User.h"

@interface Comment : LPObject
{
    NSInteger   _articleId;
    NSArray     *_atList;
    NSString    *_content;
    NSInteger   _commentId;
    NSString    *_publishTime;
    NSInteger   _reviewId;
    NSString    *_updateTime;
    User        *_user;
}

@property (assign, nonatomic) NSInteger articleId;
@property (retain, nonatomic) NSArray *atList;
@property (retain, nonatomic) NSString *content;
@property (assign, nonatomic) NSInteger commentId;
@property (retain, nonatomic) NSString *publishTime;
@property (assign, nonatomic) NSInteger reviewId;
@property (retain, nonatomic) NSString *updateTime;
@property (retain, nonatomic) User *user;

- (id)initWithAttribute:(NSDictionary *)attribute;

+ (void)getCommentListWithCommentId:(NSInteger)commentId
                             offset:(NSInteger)offset
                              limit:(NSInteger)limit
                          articleId:(NSInteger)articleId
                           reviewId:(NSInteger)reviewId
                            success:(LPObjectSuccessBlock)successBlock
                            failure:(LPObjectFailureBlock)failureBlock;

@end
