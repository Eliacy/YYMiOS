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

#define kAPIKey     @"demo_key"//@"4nM^mLISvh"
#define kAPISecret  @"demo_secret"//@"Yu8{Lnka%Y"

@interface LPAPIClient () <UIAlertViewDelegate>

- (void)sendRequestPath:(NSString *)path
                 params:(NSDictionary *)params
                 method:(NSString *)method
                success:(LPAPISuccessBlock)successBlock
                failure:(LPAPIFailureBlock)failureBlock;

@end

@implementation LPAPIClient

#pragma mark - private

- (NSString *)sha1:(NSString *)input
{
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
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
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://rpc.youyoumm.com/rpc/accumulator?timestamp=%i&key=%@&a=10&b=100", (int)[[NSDate date] timeIntervalSince1970], kAPIKey]]];
    [request addRequestHeader:[self sha1:kAPISecret] value:@"X-Auth-Signature"];
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

- (void)send
{
    [self sendRequestPath:nil
                   params:nil
                   method:nil
                  success:nil
                  failure:nil];
}

@end
