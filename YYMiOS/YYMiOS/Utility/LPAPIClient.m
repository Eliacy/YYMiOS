//
//  LPAPIClient.m
//  YYMiOS
//
//  Created by lide on 14-9-30.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "LPAPIClient.h"

@interface LPAPIClient () <UIAlertViewDelegate>

- (void)sendRequestPath:(NSString *)path
                 params:(NSDictionary *)params
                 method:(NSString *)method
                success:(LPAPISuccessBlock)successBlock
                failure:(LPAPIFailureBlock)failureBlock;

@end

@implementation LPAPIClient

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
    
}

@end
