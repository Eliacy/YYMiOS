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

@end
