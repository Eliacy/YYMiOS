//
//  QNResponseInfo.h
//  QiniuSDK
//
//  Created by bailong on 14/10/2.
//  Copyright (c) 2014年 Qiniu. All rights reserved.
//

#import <Foundation/Foundation.h>

extern const int kQNRequestCancelled;
extern const int kQNNetworkError;
extern const int kQNInvalidArgument;
extern const int kQNFileError;

@interface QNResponseInfo : NSObject

@property (readonly) int statusCode;
@property (nonatomic, copy, readonly) NSString *reqId;
@property (nonatomic, copy, readonly) NSString *xlog;
@property (nonatomic, copy, readonly) NSError *error;
@property (nonatomic, readonly, getter = isCancelled) BOOL canceled;
@property (nonatomic, readonly, getter = isOK) BOOL ok;
@property (nonatomic, readonly, getter = isConnectionBroken) BOOL broken;
@property (nonatomic, readonly) BOOL couldRetry;

+ (instancetype)cancel;

+ (instancetype)responseInfoWithInvalidArgument:(NSString *)desc;

+ (instancetype)responseInfoWithNetError:(NSError *)error;

+ (instancetype)responseInfoWithFileError:(NSError *)error;

- (instancetype)init:(int)status
           withReqId:(NSString *)reqId
            withXLog:(NSString *)xlog
            withBody:(NSData *)body;

@end
