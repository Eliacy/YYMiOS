//
//  User.h
//  YYMiOS
//
//  Created by lide on 14-10-10.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "LPObject.h"
#import "LPImage.h"

@interface User : LPObject
{
    LPImage     *_userIcon;
    NSInteger   _userId;
    NSString    *_userName;
    BOOL        _anonymous;
    NSArray    *_badges;
    NSDate    *_createTime;
    NSInteger   _exp;
    NSInteger   _fanCount;
    NSInteger   _favouriiteCount;
    NSInteger   _followCount;
    BOOL        _followed;
    NSString    *_gender;
    NSInteger   _level;
    NSInteger   _likeCount;
    NSString    *_mobile;
    NSInteger   _reviewCount;
    NSInteger   _shareCount;
    NSDate    *_updateTime;
    NSString    *_loginName;
    NSString    *_emUsername;
    NSString    *_emPassword;
}

@property (retain, nonatomic) LPImage *userIcon;
@property (assign, nonatomic) NSInteger userId;
@property (retain, nonatomic) NSString *userName;
@property (assign, nonatomic) BOOL anonymous;
@property (retain, nonatomic) NSArray *badges;
@property (retain, nonatomic) NSDate *createTime;
@property (assign, nonatomic) NSInteger exp;
@property (assign, nonatomic) NSInteger fanCount;
@property (assign, nonatomic) NSInteger favouriteCount;
@property (assign, nonatomic) NSInteger followCount;
@property (assign, nonatomic) BOOL followed;
@property (retain, nonatomic) NSString *gender;
@property (assign, nonatomic) NSInteger level;
@property (assign, nonatomic) NSInteger likeCount;
@property (retain, nonatomic) NSString *mobile;
@property (assign, nonatomic) NSInteger reviewCount;
@property (assign, nonatomic) NSInteger shareCount;
@property (retain, nonatomic) NSDate *updateTime;
@property (retain, nonatomic) NSString *loginName;
@property (retain, nonatomic) NSString *emUsername;
@property (retain, nonatomic) NSString *emPassword;

+ (id)sharedUser;

- (id)initWithAttribute:(NSDictionary *)attribute;

+ (void)getUserInfoWithUserId:(NSInteger)userId
                       offset:(NSInteger)offset
                        limit:(NSInteger)limit
                     followId:(NSInteger)followId
                        fanId:(NSInteger)fanId
                      success:(LPObjectSuccessBlock)successBlock
                      failure:(LPObjectFailureBlock)failureBlock;

+ (void)modifyUserInfoWithUserId:(NSInteger)userId
                          iconId:(NSInteger)iconId
                        userName:(NSString *)userName
                     oldPassword:(NSString *)oldPassword
                        password:(NSString *)password
                          gender:(NSString *)gender
                         success:(LPObjectSuccessBlock)successBlock
                         failure:(LPObjectFailureBlock)failureBlock;

+ (void)followSomeoneWithUserId:(NSInteger)userId
                     fromUserId:(NSInteger)fromUserId
                        success:(LPObjectSuccessBlock)successBlock
                        failure:(LPObjectFailureBlock)failureBlock;

+ (void)unfollowSomeoneWithUserId:(NSInteger)userId
                       fromUserId:(NSInteger)fromUserId
                          success:(LPObjectSuccessBlock)successBlock
                          failure:(LPObjectFailureBlock)failureBlock;

+ (void)getUserListWithEmIds:(NSString *)emIds
                       brief:(NSInteger)brief
                     success:(LPObjectSuccessBlock)successBlock
                     failure:(LPObjectFailureBlock)failureBlock;

@end
