//
//  LPAPIClient.m
//  YYMiOS
//
//  Created by lide on 14-9-30.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "LPAPIClient.h"
#import <CommonCrypto/CommonCrypto.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

#define kAPIKey     @"4nM_mLISvh"
#define kAPISecret  @"Yu8{Lnka%Y"

#define kHTTPRequestPrefix @"http://rpc.youyoumm.com"

@interface LPAPIClient () <UIAlertViewDelegate>

- (void)sendRequestPath:(NSString *)path
                 params:(NSDictionary *)params
                 method:(NSString *)method
                success:(LPAPISuccessBlock)successBlock
                failure:(LPAPIFailureBlock)failureBlock;

@end

@implementation LPAPIClient

#pragma mark - private

NSString *hashedValue(NSString *key, NSString *data) {
    
    const char *cKey  = [key cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [data cStringUsingEncoding:NSUTF8StringEncoding];
    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSString *hash;
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", cHMAC[i]];
    hash = output;
    return hash;
}

- (NSString *)stringFromBaseURL:(NSString *)baseURL withParams:(NSDictionary *)dictionary
{
    NSString *fullString = [NSString stringWithString:[baseURL stringByAppendingFormat:@"?"]];
    
    for(id key in [_headDictionary allKeys])
    {
        fullString = [fullString stringByAppendingFormat:@"%@=%@&", key, [_headDictionary objectForKey:key]];
    }
    
    for(id key in [dictionary allKeys])
    {
        fullString = [fullString stringByAppendingFormat:@"%@=%@&", key, [dictionary objectForKey:key]];
    }
    
    fullString = [fullString substringToIndex:([fullString length] - 1)];
    
    return fullString;
}

#pragma mark - public

static id APIClient = nil;
+ (id)sharedAPIClient
{
    @synchronized(APIClient){
        if(APIClient == nil)
        {
            APIClient = [[self alloc] init];
        }
    }
    
    return APIClient;
}

- (id)init
{
    self = [super init];
    if(self != nil)
    {
        _headDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
        //设置默认参数
        
        [_headDictionary setObject:kAPIKey forKey:@"key"];
    }
    
    return self;
}

- (void)dealloc
{
    LP_SAFE_RELEASE(_headDictionary);
    
    [super dealloc];
}

- (void)sendRequestPath:(NSString *)path
                 params:(NSDictionary *)params
                 method:(NSString *)method
                success:(LPAPISuccessBlock)successBlock
                failure:(LPAPIFailureBlock)failureBlock
{
//    NSString * result = hashedValue(kAPISecret, @"/rpc/sites?city=1中文&timestamp=1412998371&key=4nM_mLISvh");
//    NSLog(@"%@", result);
    
    if([method isEqualToString:@"GET"])
    {
        NSLog(@"%lf", [[[NSUserDefaults standardUserDefaults] objectForKey:@"OffsetTimeStamp"] doubleValue]);
        int time = (int)([[NSDate date] timeIntervalSince1970] + [[[NSUserDefaults standardUserDefaults] objectForKey:@"OffsetTimeStamp"] doubleValue]);
        [_headDictionary setObject:[NSString stringWithFormat:@"%i", time] forKey:@"timestamp"];
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"user_access_token"] && ![[[NSUserDefaults standardUserDefaults] objectForKey:@"user_access_token"] isEqualToString:@""])
        {
            [_headDictionary setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"user_access_token"] forKey:@"token"];
        }
        NSString *string = [self stringFromBaseURL:path withParams:params];
        
        ASIHTTPRequest *request = [[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:[[kHTTPRequestPrefix stringByAppendingString:string] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]] autorelease];
        [request addRequestHeader:@"X-Auth-Signature" value:hashedValue(kAPISecret, string)];
        
        [request setCompletionBlock:^{
            
            NSData *data = [request responseData];
            NSDictionary *respondObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            NSLog(@"%@", respondObject);
            
            if(respondObject && [respondObject isKindOfClass:[NSDictionary class]])
            {
                if([respondObject objectForKey:@"status"] && [[respondObject objectForKey:@"status"] integerValue] <= 201)
                {
                    successBlock(respondObject);
                }
                else
                {
                    failureBlock(nil);
                }
            }
            else
            {
                failureBlock(nil);
            }
            
        }];
        
        [request setFailedBlock:^{
            
            NSError *error = [request error];
            failureBlock(error);
            
        }];
        
        [request startAsynchronous];
    }
    else if([method isEqualToString:@"POST"])
    {
        int time = (int)([[NSDate date] timeIntervalSince1970] + [[[NSUserDefaults standardUserDefaults] objectForKey:@"OffsetTimeStamp"] doubleValue]);
        [_headDictionary setObject:[NSString stringWithFormat:@"%i", time] forKey:@"timestamp"];
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"user_access_token"] && ![[[NSUserDefaults standardUserDefaults] objectForKey:@"user_access_token"] isEqualToString:@""])
        {
            [_headDictionary setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"user_access_token"] forKey:@"token"];
        }
        
        NSString *string = [self stringFromBaseURL:path withParams:nil];
        NSString *urlStr = [kHTTPRequestPrefix stringByAppendingFormat:@"%@", string];
        
        ASIFormDataRequest *request  = [[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]] autorelease];
        
        NSString *charset = (NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
        [request addRequestHeader:@"Content-Type" value:[NSString stringWithFormat:@"application/json; charset=%@", charset]];
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
        NSMutableData *data = [NSMutableData dataWithData:jsonData];
        [request setPostBody:data];
        
        NSString *jsonString = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
        NSString *hashString = hashedValue(kAPISecret, [string stringByAppendingString:jsonString]);
        [request addRequestHeader:@"X-Auth-Signature" value:hashString];
        
        [request setCompletionBlock:^{
            
            NSData *data = [request responseData];
            NSDictionary *respondObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            NSLog(@"%@", respondObject);
            
            if(respondObject && [respondObject isKindOfClass:[NSDictionary class]])
            {
                if([respondObject objectForKey:@"status"] && [[respondObject objectForKey:@"status"] integerValue] <= 201)
                {
                    successBlock(respondObject);
                }
                else
                {
                    failureBlock(nil);
                }
            }
            else
            {
                failureBlock(nil);
            }
            
        }];
        
        [request setFailedBlock:^{
            
            NSError *error = [request error];
            failureBlock(error);
            
        }];
        
        [request startAsynchronous];
    }
    else if([method isEqualToString:@"DELETE"])
    {
        int time = (int)([[NSDate date] timeIntervalSince1970] + [[[NSUserDefaults standardUserDefaults] objectForKey:@"OffsetTimeStamp"] doubleValue]);
        [_headDictionary setObject:[NSString stringWithFormat:@"%i", time] forKey:@"timestamp"];
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"user_access_token"] && ![[[NSUserDefaults standardUserDefaults] objectForKey:@"user_access_token"] isEqualToString:@""])
        {
            [_headDictionary setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"user_access_token"] forKey:@"token"];
        }
        NSString *string = [self stringFromBaseURL:path withParams:params];
        
        ASIHTTPRequest *request = [[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:[[kHTTPRequestPrefix stringByAppendingString:string] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]] autorelease];
        [request addRequestHeader:@"X-Auth-Signature" value:hashedValue(kAPISecret, string)];
        [request setRequestMethod:@"DELETE"];
        [request setCompletionBlock:^{
            
            NSData *data = [request responseData];
            NSDictionary *respondObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            NSLog(@"%@", respondObject);
            
            if(respondObject && [respondObject isKindOfClass:[NSDictionary class]])
            {
                if([respondObject objectForKey:@"status"] && [[respondObject objectForKey:@"status"] integerValue] <= 201)
                {
                    successBlock(respondObject);
                }
                else
                {
                    failureBlock(nil);
                }
            }
            else
            {
                failureBlock(nil);
            }
            
        }];
        
        [request setFailedBlock:^{
            
            NSError *error = [request error];
            failureBlock(error);
            
        }];
        
        [request startAsynchronous];
    }
    else if([method isEqualToString:@"PUT"])
    {
        int time = (int)([[NSDate date] timeIntervalSince1970] + [[[NSUserDefaults standardUserDefaults] objectForKey:@"OffsetTimeStamp"] doubleValue]);
        [_headDictionary setObject:[NSString stringWithFormat:@"%i", time] forKey:@"timestamp"];
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"user_access_token"] && ![[[NSUserDefaults standardUserDefaults] objectForKey:@"user_access_token"] isEqualToString:@""])
        {
            [_headDictionary setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"user_access_token"] forKey:@"token"];
        }
        NSString *string = [self stringFromBaseURL:path withParams:params];
        
        ASIFormDataRequest *request  = [[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:[[kHTTPRequestPrefix stringByAppendingString:string] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]] autorelease];
        
        [request addRequestHeader:@"X-Auth-Signature" value:hashedValue(kAPISecret, string)];
        [request setRequestMethod:@"PUT"];
        
        [request setCompletionBlock:^{
            
            NSData *data = [request responseData];
            NSDictionary *respondObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            NSLog(@"%@", respondObject);
            
            if(respondObject && [respondObject isKindOfClass:[NSDictionary class]])
            {
                if([respondObject objectForKey:@"status"] && [[respondObject objectForKey:@"status"] integerValue] <= 201)
                {
                    successBlock(respondObject);
                }
                else
                {
                    failureBlock(nil);
                }
            }
            else
            {
                failureBlock(nil);
            }
            
        }];
        
        [request setFailedBlock:^{
            
            NSError *error = [request error];
            failureBlock(error);
            
        }];
        
        [request startAsynchronous];
    }
}

/*
 获取时间戳
 */
- (void)getServerTimeStampSuccess:(LPAPISuccessBlock)successBlock
                          failure:(LPAPIFailureBlock)failureBlock
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [self sendRequestPath:@"/rpc/time"
                   params:params
                   method:@"GET"
                  success:successBlock
                  failure:failureBlock];
}

/*
 支持最低API协议版本
 */
- (void)getLowestVersionSuccess:(LPAPISuccessBlock)successBlock
                        failure:(LPAPIFailureBlock)failureBlock
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [self sendRequestPath:@"/rpc/version"
                   params:params
                   method:@"GET"
                  success:successBlock
                  failure:failureBlock];
}

/*
 获取服务器缓存时间
 */
- (void)getServerCacheTimeSuccess:(LPAPISuccessBlock)successBlock
                          failure:(LPAPIFailureBlock)failureBlock
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [self sendRequestPath:@"/rpc/cache_time"
                   params:params
                   method:@"GET"
                  success:successBlock
                  failure:failureBlock];
}

/*
 获取分类及子分类列表
 */
- (void)getCategoryListWithCategoryId:(NSInteger)categoryId
                              success:(LPAPISuccessBlock)successBlock
                              failure:(LPAPIFailureBlock)failureBlock
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    
    if(categoryId > 0)
    {
        [params setObject:[NSString stringWithFormat:@"%i", (int)categoryId] forKey:@"id"];
    }
    
    [self sendRequestPath:@"/rpc/categories"
                   params:params
                   method:@"GET"
                  success:successBlock
                  failure:failureBlock];
}

/*
 获取国家列表
 */
- (void)getCountryListWithCountryId:(NSInteger)countryId
                            success:(LPAPISuccessBlock)successBlock
                            failure:(LPAPIFailureBlock)failureBlock
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    
    if(countryId > 0)
    {
        [params setObject:[NSString stringWithFormat:@"%i", (int)countryId] forKey:@"id"];
    }
    
    [self sendRequestPath:@"/rpc/countries"
                   params:params
                   method:@"GET"
                  success:successBlock
                  failure:failureBlock];
}

/*
 获取城市列表
 */
- (void)getCityListWithCityId:(NSInteger)cityId
                      success:(LPAPISuccessBlock)successBlock
                      failure:(LPAPIFailureBlock)failureBlock
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    
    if(cityId > 0)
    {
        [params setObject:[NSString stringWithFormat:@"%i", (int)cityId] forKey:@"id"];
    }
    
    [self sendRequestPath:@"/rpc/cities"
                   params:params
                   method:@"GET"
                  success:successBlock
                  failure:failureBlock];
}

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
                    failure:(LPAPIFailureBlock)failureBlock
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    
    if(POIId > 0)
    {
        [params setObject:[NSNumber numberWithInteger:POIId] forKey:@"id"];
    }
    
    if(brief >= 0)
    {
        [params setObject:[NSNumber numberWithInteger:brief] forKey:@"brief"];
    }
    else
    {
        [params setObject:[NSNumber numberWithInteger:1] forKey:@"brief"];
    }
    
    if(offset > 0)
    {
        [params setObject:[NSNumber numberWithInteger:offset] forKey:@"offset"];
    }
    
    if(limit > 0)
    {
        [params setObject:[NSNumber numberWithInteger:limit] forKey:@"limit"];
    }
    
    if(keyword && ![keyword isEqualToString:@""])
    {
        [params setObject:keyword forKey:@"keywords"];
    }
    
    if(area > 0)
    {
        [params setObject:[NSNumber numberWithInteger:area] forKey:@"area"];
    }
    
    if(city > 0)
    {
        [params setObject:[NSNumber numberWithInteger:city] forKey:@"city"];
    }
    
    if(range > 0)
    {
        [params setObject:[NSNumber numberWithInteger:range] forKey:@"range"];
    }
    
    if(category > 0)
    {
        [params setObject:[NSNumber numberWithInteger:category] forKey:@"category"];
    }
    
    if(order > 0)
    {
        [params setObject:[NSNumber numberWithInteger:order] forKey:@"order"];
    }
    
    if(longitude > 0)
    {
        [params setObject:[NSNumber numberWithFloat:longitude] forKey:@"longitude"];
    }
    
    if(latitude > 0)
    {
        [params setObject:[NSNumber numberWithFloat:latitude] forKey:@"latitude"];
    }
    
    [self sendRequestPath:@"/rpc/sites"
                   params:params
                   method:@"GET"
                  success:successBlock
                  failure:failureBlock];
}

/*
 获取晒单列表
 */
- (void)getDealDetailListWithDealId:(NSInteger)dealId
                              brief:(NSInteger)brief
                           selected:(NSInteger)selected
                          published:(NSInteger)published
                             offset:(NSInteger)offset
                              limit:(NSInteger)limit
                               user:(NSInteger)user
                               site:(NSInteger)site
                               city:(NSInteger)city
                            success:(LPAPISuccessBlock)successBlock
                            failure:(LPAPIFailureBlock)failureBlock
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [params setObject:[NSNumber numberWithInteger:dealId] forKey:@"id"];
    [params setObject:[NSNumber numberWithInteger:brief] forKey:@"brief"];
    [params setObject:[NSNumber numberWithInteger:selected] forKey:@"selected"];
    [params setObject:[NSNumber numberWithInteger:published] forKey:@"published"];
    [params setObject:[NSNumber numberWithInteger:offset] forKey:@"offset"];
    [params setObject:[NSNumber numberWithInteger:limit] forKey:@"limit"];
    [params setObject:[NSNumber numberWithInteger:user] forKey:@"user"];
    [params setObject:[NSNumber numberWithInteger:site] forKey:@"site"];
    [params setObject:[NSNumber numberWithInteger:city] forKey:@"city"];
    
    [self sendRequestPath:@"/rpc/reviews"
                   params:params
                   method:@"GET"
                  success:successBlock
                  failure:failureBlock];
}


/*
 删除晒单
 */
- (void)deleteDealDetailWithDealId:(NSInteger)dealId
                           success:(LPAPISuccessBlock)successBlock
                           failure:(LPAPIFailureBlock)failureBlock
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [params setObject:[NSNumber numberWithInteger:dealId] forKey:@"id"];
    
    [self sendRequestPath:@"/rpc/reviews"
                   params:params
                   method:@"DELETE"
                  success:successBlock
                  failure:failureBlock];
}

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
                              failure:(LPAPIFailureBlock)failureBlock
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [params setObject:[NSNumber numberWithInteger:published] forKey:@"published"];
    [params setObject:[NSNumber numberWithInteger:userId] forKey:@"user_id"];
    if(atList && ![atList isEqualToString:@""])
    {
        [params setObject:atList forKey:@"at_list"];
    }
    [params setObject:[NSNumber numberWithFloat:star] forKey:@"stars"];
    if(content && ![content isEqualToString:@""])
    {
        [params setObject:content forKey:@"content"];
    }
    if(images && ![images isEqualToString:@""])
    {
        [params setObject:images forKey:@"images"];
    }
    if(keywords && ![keywords isEqualToString:@""])
    {
        [params setObject:keywords forKey:@"keywords"];
    }
    [params setObject:[NSNumber numberWithInteger:total] forKey:@"total"];
    if(currency && ![currency isEqualToString:@""])
    {
        [params setObject:currency forKey:@"currency"];
    }
    [params setObject:[NSNumber numberWithInteger:siteId] forKey:@"site_id"];
    
    [self sendRequestPath:@"/rpc/reviews"
                   params:params
                   method:@"POST"
                  success:successBlock
                  failure:failureBlock];
}

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
                           failure:(LPAPIFailureBlock)failureBlock
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [params setObject:[NSNumber numberWithInteger:dealId] forKey:@"id"];
    [params setObject:[NSNumber numberWithInteger:published] forKey:@"published"];
    [params setObject:[NSNumber numberWithInteger:userId] forKey:@"user_id"];
    if(atList && ![atList isEqualToString:@""])
    {
        [params setObject:atList forKey:@"at_list"];
    }
    [params setObject:[NSNumber numberWithFloat:star] forKey:@"stars"];
    if(content && ![content isEqualToString:@""])
    {
        [params setObject:content forKey:@"content"];
    }
    if(images && ![images isEqualToString:@""])
    {
        [params setObject:images forKey:@"images"];
    }
    if(keywords && ![keywords isEqualToString:@""])
    {
        [params setObject:keywords forKey:@"keywords"];
    }
    [params setObject:[NSNumber numberWithInteger:total] forKey:@"total"];
    if(currency && ![currency isEqualToString:@""])
    {
        [params setObject:currency forKey:@"currency"];
    }
    [params setObject:[NSNumber numberWithInteger:siteId] forKey:@"site"];
    
    [self sendRequestPath:@"/rpc/reviews"
                   params:params
                   method:@"PUT"
                  success:successBlock
                  failure:failureBlock];
}

- (void)getCommentListWithCommentId:(NSInteger)commentId
                             offset:(NSInteger)offset
                              limit:(NSInteger)limit
                          articleId:(NSInteger)articleId
                           reviewId:(NSInteger)reviewId
                            success:(LPAPISuccessBlock)successBlock
                            failure:(LPAPIFailureBlock)failureBlock
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [params setObject:[NSNumber numberWithInteger:commentId] forKey:@"id"];
    [params setObject:[NSNumber numberWithInteger:offset] forKey:@"offset"];
    [params setObject:[NSNumber numberWithInteger:limit] forKey:@"limit"];
    [params setObject:[NSNumber numberWithInteger:articleId] forKey:@"article"];
    [params setObject:[NSNumber numberWithInteger:reviewId] forKey:@"review"];
    
    [self sendRequestPath:@"/rpc/comments"
                   params:params
                   method:@"GET"
                  success:successBlock
                  failure:failureBlock];
}

/*
 删除评论
 */
- (void)deleteCommentWithId:(NSInteger)commentId
                    success:(LPAPISuccessBlock)successBlock
                    failure:(LPAPIFailureBlock)failureBlock
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [params setObject:[NSNumber numberWithInteger:commentId] forKey:@"id"];
    
    [self sendRequestPath:@"/rpc/comments"
                   params:params
                   method:@"DELETE"
                  success:successBlock
                  failure:failureBlock];
}

/*
 创建评论
 */
- (void)createCommentWithDealId:(NSInteger)dealId
                      articleId:(NSInteger)articleId
                         userId:(NSInteger)userId
                         atList:(NSString *)atList
                        content:(NSString *)content
                        success:(LPAPISuccessBlock)successBlock
                        failure:(LPAPIFailureBlock)failureBlock
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [params setObject:[NSNumber numberWithInteger:dealId] forKey:@"review"];
    [params setObject:[NSNumber numberWithInteger:articleId] forKey:@"article"];
    [params setObject:[NSNumber numberWithInteger:userId] forKey:@"user"];
    if(atList && ![atList isEqualToString:@""])
    {
        [params setObject:atList forKey:@"at_list"];
    }
    if(content && ![content isEqualToString:@""])
    {
        [params setObject:content forKey:@"content"];
    }
    
    [self sendRequestPath:@"/rpc/comments"
                   params:params
                   method:@"POST"
                  success:successBlock
                  failure:failureBlock];
}

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
                           failure:(LPAPIFailureBlock)failureBlock
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [params setObject:[NSNumber numberWithInteger:commentId] forKey:@"id"];
    [params setObject:[NSNumber numberWithInteger:reviewId] forKey:@"review"];
    [params setObject:[NSNumber numberWithInteger:articleId] forKey:@"article"];
    [params setObject:[NSNumber numberWithInteger:userId] forKey:@"user"];
    if(atList && ![atList isEqualToString:@""])
    {
        [params setObject:atList forKey:@"at_list"];
    }
    if(content && ![content isEqualToString:@""])
    {
        [params setObject:content forKey:@"content"];
    }
    
    [self sendRequestPath:@"/rpc/comments"
                   params:params
                   method:@"PUT"
                  success:successBlock
                  failure:failureBlock];
}

/*
 登录
 */
- (void)loginWithUserName:(NSString *)userName
                 password:(NSString *)password
                    token:(NSString *)token
                   device:(NSString *)device
                  success:(LPAPISuccessBlock)successBlock
                  failure:(LPAPIFailureBlock)failureBlock
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    
    if(userName && ![userName isEqualToString:@""])
    {
        [params setObject:userName forKey:@"username"];
    }
    if(password && ![password isEqualToString:@""])
    {
        [params setObject:password forKey:@"password"];
    }
    if(token && ![token isEqualToString:@""])
    {
        [params setObject:token forKey:@"token"];
    }
    if(device && ![device isEqualToString:@""])
    {
        [params setObject:device forKey:@"device"];
    }
    
    [self sendRequestPath:@"/rpc/tokens"
                   params:params
                   method:@"POST"
                  success:successBlock
                  failure:failureBlock];
}

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
                   failure:(LPAPIFailureBlock)failureBlock
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [params setObject:[NSNumber numberWithInteger:iconId] forKey:@"icon"];
    if(userName && ![userName isEqualToString:@""])
    {
        [params setObject:userName forKey:@"name"];
    }
    if(mobile && ![mobile isEqualToString:@""])
    {
        [params setObject:mobile forKey:@"mobile"];
    }
    if(password && ![password isEqualToString:@""])
    {
        [params setObject:password forKey:@"password"];
    }
    if(gender && ![gender isEqualToString:@""])
    {
        [params setObject:gender forKey:@"gender"];
    }
    if(token && ![token isEqualToString:@""])
    {
        [params setObject:token forKey:@"token"];
    }
    if(device && ![device isEqualToString:@""])
    {
        [params setObject:device forKey:@"device"];
    }
    
    [self sendRequestPath:@"/rpc/users"
                   params:params
                   method:@"POST"
                  success:successBlock
                  failure:failureBlock];
}

/*
 获取用户信息
 */
- (void)getUserInfoWithUserId:(NSInteger)userId
                       offset:(NSInteger)offset
                        limit:(NSInteger)limit
                     followId:(NSInteger)followId
                        fanId:(NSInteger)fanId
                      success:(LPAPISuccessBlock)successBlock
                      failure:(LPAPIFailureBlock)failureBlock
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [params setObject:[NSNumber numberWithInteger:userId] forKey:@"id"];
    [params setObject:[NSNumber numberWithInteger:offset] forKey:@"offset"];
    [params setObject:[NSNumber numberWithInteger:limit] forKey:@"limit"];
    [params setObject:[NSNumber numberWithInteger:followId] forKey:@"follow"];
    [params setObject:[NSNumber numberWithInteger:fanId] forKey:@"fan"];
    
    [self sendRequestPath:@"/rpc/users"
                   params:params
                   method:@"GET"
                  success:successBlock
                  failure:failureBlock];
}

/*
 修改用户信息
 */
- (void)modifyUserInfoWithUserId:(NSInteger)userId
                          iconId:(NSInteger)iconId
                        userName:(NSString *)userName
                        password:(NSString *)password
                          gender:(NSString *)gender
                         success:(LPAPISuccessBlock)successBlock
                         failure:(LPAPIFailureBlock)failureBlock
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [params setObject:[NSNumber numberWithInteger:userId] forKey:@"id"];
    [params setObject:[NSNumber numberWithInteger:iconId] forKey:@"icon"];
    if(userName && ![userName isEqualToString:@""])
    {
        [params setObject:userName forKey:@"name"];
    }
    if(password && ![password isEqualToString:@""])
    {
        [params setObject:password forKey:@"password"];
    }
    if(gender && ![gender isEqualToString:@""])
    {
        [params setObject:gender forKey:@"gender"];
    }
    
    [self sendRequestPath:@"/rpc/users"
                   params:params
                   method:@"PUT"
                  success:successBlock
                  failure:failureBlock];
}

/*
 获取Tips
 */
- (void)getTipsListWithTipsId:(NSInteger)tipsId
                        brief:(NSInteger)brief
                       cityId:(NSInteger)cityId
                      success:(LPAPISuccessBlock)successBlock
                      failure:(LPAPIFailureBlock)failureBlock
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [params setObject:[NSNumber numberWithInteger:tipsId] forKey:@"id"];
    [params setObject:[NSNumber numberWithInteger:brief] forKey:@"brief"];
    [params setObject:[NSNumber numberWithInteger:cityId] forKey:@"city"];
    
    [self sendRequestPath:@"/rpc/tips"
                   params:params
                   method:@"GET"
                  success:successBlock
                  failure:failureBlock];
}

/*
 获取文章列表
 */
- (void)getArticleListWithArticleId:(NSInteger)articleId
                              brief:(NSInteger)brief
                             offset:(NSInteger)offset
                              limit:(NSInteger)limit
                             cityId:(NSInteger)cityId
                            success:(LPAPISuccessBlock)successBlock
                            failure:(LPAPIFailureBlock)failureBlock
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [params setObject:[NSNumber numberWithInteger:articleId] forKey:@"id"];
    [params setObject:[NSNumber numberWithInteger:brief] forKey:@"brief"];
    [params setObject:[NSNumber numberWithInteger:offset] forKey:@"offset"];
    [params setObject:[NSNumber numberWithInteger:limit] forKey:@"limit"];
    [params setObject:[NSNumber numberWithInteger:cityId] forKey:@"city"];
    
    [self sendRequestPath:@"/rpc/articles"
                   params:params
                   method:@"GET"
                  success:successBlock
                  failure:failureBlock];
}

/*
 获取图片
 */
- (void)getImageListWithImageId:(NSInteger)imageId
                         offset:(NSInteger)offset
                          limit:(NSInteger)limit
                         siteId:(NSInteger)siteId
                       reviewId:(NSInteger)reviewId
                        success:(LPAPISuccessBlock)successBlock
                        failure:(LPAPIFailureBlock)failureBlock
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [params setObject:[NSNumber numberWithInteger:imageId] forKey:@"id"];
    [params setObject:[NSNumber numberWithInteger:offset] forKey:@"offset"];
    [params setObject:[NSNumber numberWithInteger:limit] forKey:@"limit"];
    [params setObject:[NSNumber numberWithInteger:siteId] forKey:@"site"];
    [params setObject:[NSNumber numberWithInteger:reviewId] forKey:@"review"];
    
    [self sendRequestPath:@"/rpc/images"
                   params:params
                   method:@"GET"
                  success:successBlock
                  failure:failureBlock];
}

/*
 删除图片
 */
- (void)deleteImageWithImageId:(NSInteger)imageId
                       success:(LPAPISuccessBlock)successBlock
                       failure:(LPAPIFailureBlock)failureBlock
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [params setObject:[NSNumber numberWithInteger:imageId] forKey:@"id"];
    
    [self sendRequestPath:@"/rpc/images"
                   params:params
                   method:@"DELETE"
                  success:successBlock
                  failure:failureBlock];
}

/*
 创建图片
 */
- (void)createImageWithType:(NSInteger)type
                       path:(NSString *)path
                     userId:(NSInteger)userId
                    success:(LPAPISuccessBlock)successBlock
                    failure:(LPAPIFailureBlock)failureBlock
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [params setObject:[NSNumber numberWithInteger:type] forKey:@"type"];
    if(path && ![path isEqualToString:@""])
    {
        [params setObject:path forKey:@"path"];
    }
    [params setObject:[NSNumber numberWithInteger:userId] forKey:@"user"];
    
    [self sendRequestPath:@"/rpc/images"
                   params:params
                   method:@"POST"
                  success:successBlock
                  failure:failureBlock];
}

/*
 关注
 */
- (void)followSomeoneWithUserId:(NSInteger)userId
                     fromUserId:(NSInteger)fromUserId
                        success:(LPAPISuccessBlock)successBlock
                        failure:(LPAPIFailureBlock)failureBlock
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [params setObject:[NSNumber numberWithInteger:userId] forKey:@"follow"];
    [params setObject:[NSNumber numberWithInteger:fromUserId] forKey:@"fan"];
    
    [self sendRequestPath:@"/rpc/follows"
                   params:params
                   method:@"POST"
                  success:successBlock
                  failure:failureBlock];
}

/*
 取消关注
 */
- (void)unfollowSomeoneWithUserId:(NSInteger)userId
                       fromUserId:(NSInteger)fromUserId
                          success:(LPAPISuccessBlock)successBlock
                          failure:(LPAPIFailureBlock)failureBlock
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [params setObject:[NSNumber numberWithInteger:userId] forKey:@"follow"];
    [params setObject:[NSNumber numberWithInteger:fromUserId] forKey:@"fan"];
    
    [self sendRequestPath:@"/rpc/follows"
                   params:params
                   method:@"DELETE"
                  success:successBlock
                  failure:failureBlock];
}

/*
 喜欢晒单评论
 */
- (void)likeReviewWithUserId:(NSInteger)userId
                    reviewId:(NSInteger)reviewId
                     success:(LPAPISuccessBlock)successBlock
                     failure:(LPAPIFailureBlock)failureBlock
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [params setObject:[NSNumber numberWithInteger:userId] forKey:@"user"];
    [params setObject:[NSNumber numberWithInteger:reviewId] forKey:@"review"];
    
    [self sendRequestPath:@"/rpc/likes"
                   params:params
                   method:@"POST"
                  success:successBlock
                  failure:failureBlock];
}

/*
 取消喜欢晒单评论
 */
- (void)unlikeReviewWithUserId:(NSInteger)userId
                      reviewId:(NSInteger)reviewId
                       success:(LPAPISuccessBlock)successBlock
                       failure:(LPAPIFailureBlock)failureBlock
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [params setObject:[NSNumber numberWithInteger:userId] forKey:@"user"];
    [params setObject:[NSNumber numberWithInteger:reviewId] forKey:@"review"];
    
    [self sendRequestPath:@"/rpc/likes"
                   params:params
                   method:@"DELETE"
                  success:successBlock
                  failure:failureBlock];
}

/*
 获取晒单喜欢列表
 */
- (void)getReviewLikeListWithOffset:(NSInteger)offset
                              limit:(NSInteger)limit
                             userId:(NSInteger)userId
                            success:(LPAPISuccessBlock)successBlock
                            failure:(LPAPIFailureBlock)failureBlock
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [params setObject:[NSNumber numberWithInteger:offset] forKey:@"offset"];
    [params setObject:[NSNumber numberWithInteger:limit] forKey:@"limit"];
    [params setObject:[NSNumber numberWithInteger:userId] forKey:@"user"];
    
    [self sendRequestPath:@"/rpc/likes"
                   params:params
                   method:@"GET"
                  success:successBlock
                  failure:failureBlock];
}

/*
 收藏POI
 */
- (void)collectPOIWithUserId:(NSInteger)userId
                       POIId:(NSInteger)POIId
                     success:(LPAPISuccessBlock)successBlock
                     failure:(LPAPIFailureBlock)failureBlock
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [params setObject:[NSNumber numberWithInteger:userId] forKey:@"user"];
    [params setObject:[NSNumber numberWithInteger:POIId] forKey:@"site"];
    
    [self sendRequestPath:@"/rpc/favorites"
                   params:params
                   method:@"POST"
                  success:successBlock
                  failure:failureBlock];
}

/*
 取消收藏POI
 */
- (void)cancelCollectPOIWithUserId:(NSInteger)userId
                             POIId:(NSInteger)POIId
                           success:(LPAPISuccessBlock)successBlock
                           failure:(LPAPIFailureBlock)failureBlock
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [params setObject:[NSNumber numberWithInteger:userId] forKey:@"user"];
    [params setObject:[NSNumber numberWithInteger:POIId] forKey:@"site"];
    
    [self sendRequestPath:@"/rpc/favorites"
                   params:params
                   method:@"DELETE"
                  success:successBlock
                  failure:failureBlock];
}

/*
 获取POI收藏列表
 */
- (void)getPOIFavouriteListWithOffset:(NSInteger)offset
                                limit:(NSInteger)limit
                               userId:(NSInteger)userId
                              success:(LPAPISuccessBlock)successBlock
                              failure:(LPAPIFailureBlock)failureBlock
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [params setObject:[NSNumber numberWithInteger:offset] forKey:@"offset"];
    [params setObject:[NSNumber numberWithInteger:limit] forKey:@"limit"];
    [params setObject:[NSNumber numberWithInteger:userId] forKey:@"user"];
    
    [self sendRequestPath:@"/rpc/favorites"
                   params:params
                   method:@"GET"
                  success:successBlock
                  failure:failureBlock];
}

/*
 获取Qiniu上传图片token
 */
- (void)getQiniuUploadTokenWithImageId:(NSInteger)imageId
                                  type:(NSInteger)type
                                userId:(NSInteger)userId
                                  note:(NSString *)note
                                  name:(NSString *)name
                                 width:(NSInteger)width
                                height:(NSInteger)height
                               success:(LPAPISuccessBlock)successBlock
                               failure:(LPAPIFailureBlock)failureBlock
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    
    NSMutableDictionary *imageDictionary = [NSMutableDictionary dictionaryWithCapacity:0];
    if(imageId > 0)
    {
        [imageDictionary setObject:[NSNumber numberWithInteger:imageId] forKey:@"id"];
    }
    [imageDictionary setObject:[NSNumber numberWithInteger:type] forKey:@"type"];
    [imageDictionary setObject:[NSNumber numberWithInteger:userId] forKey:@"user"];
    if(note && ![note isEqualToString:@""])
    {
        [imageDictionary setObject:note forKey:@"note"];
    }
    if(name && ![name isEqualToString:@""])
    {
        [imageDictionary setObject:name forKey:@"name"];
    }
    [imageDictionary setObject:@"$(fsize)" forKey:@"size"];
    [imageDictionary setObject:@"$(mimeType)" forKey:@"mime"];
    [imageDictionary setObject:[NSNumber numberWithInteger:width] forKey:@"width"];
    [imageDictionary setObject:[NSNumber numberWithInteger:height] forKey:@"height"];
    [imageDictionary setObject:@"$(etag)" forKey:@"hash"];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:imageDictionary options:NSJSONWritingPrettyPrinted error:nil];
    NSString *string = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    
    if(string && ![string isEqualToString:@""])
    {
        [params setObject:string forKey:@"params"];
    }
    
    [self sendRequestPath:@"/rpc/uptokens"
                   params:params
                   method:@"POST"
                  success:successBlock
                  failure:failureBlock];
}

@end
