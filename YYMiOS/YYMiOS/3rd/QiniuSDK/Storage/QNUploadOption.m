//
//  QNUploadOption.m
//  QiniuSDK
//
//  Created by bailong on 14/10/4.
//  Copyright (c) 2014年 Qiniu. All rights reserved.
//

#import "QNUploadOption+Private.h"
#import "QNUploadManager.h"

@implementation QNUploadOption

- (instancetype)initWithProgessHandler:(QNUpProgressHandler)progress {
	if (self = [super init]) {
		_progressHandler = progress;
	}
	return self;
}

+ (NSDictionary *)filteParam:(NSDictionary *)params {
	if (params == nil) {
		return nil;
	}
	NSMutableDictionary *ret = [NSMutableDictionary dictionary];

	[params enumerateKeysAndObjectsUsingBlock: ^(NSString *key, NSString *obj, BOOL *stop) {
	    if ([key hasPrefix:@"x:"] && ![obj isEqualToString:@""]) {
	        ret[key] = obj;
		}
	}];

	return ret;
}

- (instancetype)initWithMime:(NSString *)mimeType
             progressHandler:(QNUpProgressHandler)progress
                      params:(NSDictionary *)params
                    checkCrc:(BOOL)check
          cancellationSignal:(QNUpCancellationSignal)cancel {
	if (self = [super init]) {
		_mimeType = mimeType;
		_progressHandler = progress;
		_params = [QNUploadOption filteParam:params];
		_checkCrc = check;
		_cancellationSignal = cancel;
	}

	return self;
}

- (BOOL)priv_isCancelled {
	return _cancellationSignal && _cancellationSignal();
}

@end
