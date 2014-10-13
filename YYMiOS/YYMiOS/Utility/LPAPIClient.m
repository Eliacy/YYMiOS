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
    
    NSMutableString* output = [NSMutableString   stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
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
    if([method isEqualToString:@"GET"])
    {
        int time = (int)[[NSDate date] timeIntervalSince1970];
        [_headDictionary setObject:[NSString stringWithFormat:@"%i", time] forKey:@"timestamp"];
        NSString *string = [self stringFromBaseURL:path withParams:params];
        
        ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:[[kHTTPRequestPrefix stringByAppendingString:string] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]];
        [request addRequestHeader:@"X-Auth-Signature" value:hashedValue(kAPISecret, string)];
        
        [request setCompletionBlock:^{
            
            NSData *data = [request responseData];
            NSDictionary *respondObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"%@", [respondObject description]);
            
        }];
        
        [request setFailedBlock:^{
            
            NSError *error = [request error];
            NSLog(@"%@", [error description]);
            
        }];
        
        [request startAsynchronous];
    }
    else if([method isEqualToString:@"POST"])
    {
    
    }
    else
    {
    
    }
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
                      failure:(LPAPIFailureBlock)failureBlcok
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
                  failure:failureBlcok];
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

@end
