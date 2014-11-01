//
//  LPAPIClient.h
//  YYMiOS
//
//  Created by lide on 14-9-30.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^LPAPISuccessBlock)(id respondObject);
typedef void (^LPAPIFailureBlock)(NSError *error);

@interface LPAPIClient : NSObject
{
    NSMutableDictionary         *_headDictionary;
}

+ (id)sharedAPIClient;

/*
 获取时间戳
 */
- (void)getServerTimeStampSuccess:(LPAPISuccessBlock)successBlock
                          failure:(LPAPIFailureBlock)failureBlcok;

/*
 支持最低API协议版本
 */
- (void)getLowestVersionSuccess:(LPAPISuccessBlock)successBlock
                        failure:(LPAPIFailureBlock)failureBlcok;

/*
 获取服务器缓存时间
 */
- (void)getServerCacheTimeSuccess:(LPAPISuccessBlock)successBlock
                          failure:(LPAPIFailureBlock)failureBlcok;

/*
 获取分类及子分类列表
 */
- (void)getCategoryListWithCategoryId:(NSInteger)categoryId
                              success:(LPAPISuccessBlock)successBlock
                              failure:(LPAPIFailureBlock)failureBlock;

/*
 获取国家列表
 */
- (void)getCountryListWithCountryId:(NSInteger)countryId
                            success:(LPAPISuccessBlock)successBlock
                            failure:(LPAPIFailureBlock)failureBlock;

/*
 获取城市列表
 */
- (void)getCityListWithCityId:(NSInteger)cityId
                      success:(LPAPISuccessBlock)successBlock
                      failure:(LPAPIFailureBlock)failureBlcok;

/*
 POI列表搜索
 */
- (void)getPOIListWithPOIId:(NSInteger)POIId
                      brief:(NSInteger)brief
                     offset:(NSInteger)offset
                      limit:(NSInteger)limit
                    keyword:(NSString *)keyword
                       area:(NSInteger)area
                       city:(NSInteger)city
                      range:(NSInteger)range
                   category:(NSInteger)category
                      order:(NSInteger)order
                  longitude:(CGFloat)longitude
                   latitude:(CGFloat)latitude
                    success:(LPAPISuccessBlock)successBlock
                    failure:(LPAPIFailureBlock)failureBlock;

/*
 获取晒单列表
 */
- (void)getDealDetailListWithBrief:(NSInteger)brief
                          selected:(NSInteger)selected
                         published:(NSInteger)published
                            offset:(NSInteger)offset
                             limit:(NSInteger)limit
                              user:(NSInteger)user
                              site:(NSInteger)site
                              city:(NSInteger)city
                           success:(LPAPISuccessBlock)successBlock
                           failure:(LPAPIFailureBlock)failureBlcok;

/*
 删除晒单
 */
- (void)deleteDealDetailWithDealId:(NSInteger)dealId
                           success:(LPAPISuccessBlock)successBlock
                           failure:(LPAPIFailureBlock)failureBlcok;

/*
 创建晒单
 */
- (void)createDealDetailWithPublished:(NSInteger)published
                               userId:(NSInteger)userId
                               atList:(NSString *)atList
                                 star:(float)star
                              content:(NSString *)content
                               images:(NSString *)images
                             keywords:(NSString *)keywords
                                total:(NSInteger)total
                             currency:(NSString *)currency
                               siteId:(NSInteger)siteId
                              success:(LPAPISuccessBlock)successBlock
                              failure:(LPAPIFailureBlock)failureBlcok;

/*
 修改晒单
 */
- (void)updateDealDetailWithDealId:(NSInteger)dealId
                         published:(NSInteger)published
                            userId:(NSInteger)userId
                            atList:(NSString *)atList
                              star:(float)star
                           content:(NSString *)content
                            images:(NSString *)images
                          keywords:(NSString *)keywords
                             total:(NSInteger)total
                          currency:(NSString *)currency
                            siteId:(NSInteger)siteId
                           success:(LPAPISuccessBlock)successBlock
                           failure:(LPAPIFailureBlock)failureBlcok;

/*
 获取评论
 */
- (void)getCommentListWithCommentId:(NSInteger)commentId
                             offset:(NSInteger)offset
                              limit:(NSInteger)limit
                          articleId:(NSInteger)articleId
                           reviewId:(NSInteger)reviewId
                            success:(LPAPISuccessBlock)successBlock
                            failure:(LPAPIFailureBlock)failureBlock;

/*
 删除评论
 */
- (void)deleteCommentWithId:(NSInteger)commentId
                    success:(LPAPISuccessBlock)successBlock
                    failure:(LPAPIFailureBlock)failureBlock;

/*
 创建评论
 */
- (void)createCommentWithDealId:(NSInteger)dealId
                      articleId:(NSInteger)articleId
                         userId:(NSInteger)userId
                         atList:(NSString *)atList
                        content:(NSString *)content
                        success:(LPAPISuccessBlock)successBlock
                        failure:(LPAPIFailureBlock)failureBlcok;

/*
 修改评论
 */
- (void)modifyCommentWithCommentId:(NSInteger)commentId
                          reviewId:(NSInteger)reviewId
                         articleId:(NSInteger)articleId
                            userId:(NSInteger)userId
                            atList:(NSString *)atList
                           content:(NSString *)content
                           success:(LPAPISuccessBlock)successBlock
                           failure:(LPAPIFailureBlock)failureBlock;

/*
 登录
 */
- (void)loginWithUserName:(NSString *)userName
                 password:(NSString *)password
                    token:(NSString *)token
                   device:(NSString *)device
                  success:(LPAPISuccessBlock)successBlock
                  failure:(LPAPIFailureBlock)failureBlcok;

/*
 注册
 */
- (void)registerWithIconId:(NSInteger)iconId
                  userName:(NSString *)userName
                    mobile:(NSString *)mobile
                  password:(NSString *)password
                    gender:(NSString *)gender
                     token:(NSString *)token
                    device:(NSString *)device
                   success:(LPAPISuccessBlock)successBlock
                   failure:(LPAPIFailureBlock)failureBlcok;

/*
 获取用户信息
 */
- (void)getUserInfoWithUserId:(NSInteger)userId
                       offset:(NSInteger)offset
                        limit:(NSInteger)limit
                     followId:(NSInteger)followId
                        fanId:(NSInteger)fanId
                      success:(LPAPISuccessBlock)successBlock
                      failure:(LPAPIFailureBlock)failureBlock;

/*
 修改用户信息
 */
- (void)modifyUserInfoWithUserId:(NSInteger)userId
                          iconId:(NSInteger)iconId
                        userName:(NSString *)userName
                        password:(NSString *)password
                          gender:(NSString *)gender
                         success:(LPAPISuccessBlock)successBlock
                         failure:(LPAPIFailureBlock)failureBlock;

/*
 获取Tips
 */
- (void)getTipsListWithArticleId:(NSInteger)articleId
                           brief:(NSInteger)brief
                          cityId:(NSInteger)cityId
                         success:(LPAPISuccessBlock)successBlock
                         failure:(LPAPIFailureBlock)failureBlcok;

@end
