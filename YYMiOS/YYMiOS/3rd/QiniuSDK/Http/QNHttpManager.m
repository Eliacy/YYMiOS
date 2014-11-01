//
//  QNHttpManager.m
//  QiniuSDK
//
//  Created by bailong on 14/10/1.
//  Copyright (c) 2014年 Qiniu. All rights reserved.
//

#import "AFNetworking.h"

#import "QNConfig.h"
#import "QNHttpManager.h"
#import "QNUserAgent.h"
#import "QNResponseInfo.h"

@interface QNHttpManager ()
@property (nonatomic) AFHTTPRequestOperationManager *httpManager;
@end

static NSString *userAgent = nil;

@implementation QNHttpManager

+ (void)initialize {
	userAgent = QNUserAgent();
}

- (instancetype)init {
	if (self = [super init]) {
		_httpManager = [[AFHTTPRequestOperationManager alloc] init];
		_httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
	}

	return self;
}

+ (QNResponseInfo *)buildResponseInfo:(AFHTTPRequestOperation *)operation
                            withError:(NSError *)error
                         withResponse:(id)responseObject {
	QNResponseInfo *info;
	if (operation.response) {
		NSDictionary *headers = [operation.response allHeaderFields];
		NSString *reqId = headers[@"X-Reqid"];
		NSString *xlog = headers[@"X-Log"];
		int status =  (int)[operation.response statusCode];
		info = [[QNResponseInfo alloc] init:status withReqId:reqId withXLog:xlog withBody:responseObject];
	}
	else {
		info = [QNResponseInfo responseInfoWithNetError:error];
	}
	return info;
}

- (void)  sendRequest:(NSMutableURLRequest *)request
    withCompleteBlock:(QNCompleteBlock)completeBlock
    withProgressBlock:(QNInternalProgressBlock)progressBlock {
	AFHTTPRequestOperation *operation = [_httpManager
	                                     HTTPRequestOperationWithRequest:request
	                                                             success: ^(AFHTTPRequestOperation *operation, id responseObject) {
	    QNResponseInfo *info = [QNHttpManager buildResponseInfo:operation withError:nil withResponse:operation.responseData];
	    NSDictionary *resp = nil;
	    if (info.isOK) {
	        resp = responseObject;
		}
	    completeBlock(info, resp);
	}                                                                failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
	    QNResponseInfo *info = [QNHttpManager buildResponseInfo:operation withError:error withResponse:operation.responseData];
	    completeBlock(info, nil);
	}

	    ];

	if (progressBlock) {
		[operation setUploadProgressBlock: ^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
		    progressBlock(totalBytesWritten, totalBytesExpectedToWrite);
		}];
	}
	[request setTimeoutInterval:kQNTimeoutInterval];

	[request setValue:userAgent forHTTPHeaderField:@"User-Agent"];
	[request setValue:nil forHTTPHeaderField:@"Accept-Language"];
	[_httpManager.operationQueue addOperation:operation];
}

- (void)multipartPost:(NSString *)url
             withData:(NSData *)data
           withParams:(NSDictionary *)params
         withFileName:(NSString *)key
         withMimeType:(NSString *)mime
    withCompleteBlock:(QNCompleteBlock)completeBlock
    withProgressBlock:(QNInternalProgressBlock)progressBlock
      withCancelBlock:(QNCancelBlock)cancelBlock {
	NSMutableURLRequest *request = [_httpManager.requestSerializer
	                                multipartFormRequestWithMethod:@"POST"
	                                                     URLString:url
	                                                    parameters:params
	                                     constructingBodyWithBlock: ^(id < AFMultipartFormData > formData) {
	    [formData appendPartWithFileData:data name:@"file" fileName:key mimeType:mime];
	}

	                                                         error:nil];
	[self sendRequest:request
	    withCompleteBlock:completeBlock
	    withProgressBlock:progressBlock];
}

- (void)         post:(NSString *)url
             withData:(NSData *)data
           withParams:(NSDictionary *)params
          withHeaders:(NSDictionary *)headers
    withCompleteBlock:(QNCompleteBlock)completeBlock
    withProgressBlock:(QNInternalProgressBlock)progressBlock
      withCancelBlock:(QNCancelBlock)cancelBlock {
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:url]];
	if (headers) {
		[request setAllHTTPHeaderFields:headers];
	}

	[request setHTTPMethod:@"POST"];

	if (params) {
		[request setValuesForKeysWithDictionary:params];
	}
	[request setHTTPBody:data];
	[self sendRequest:request
	    withCompleteBlock:completeBlock
	    withProgressBlock:progressBlock];
}

@end
