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

@end
