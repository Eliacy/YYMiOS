//
//  LPUtility.m
//  YYMiOS
//
//  Created by Lide on 14-11-6.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "LPUtility.h"
#include <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>
#import "QNEtag.h"
#import "QNUrlSafeBase64.h"

#define kAccessKey @"WOc4A537RGp5nKavmURZqF1v86h9zjDBJN8R_gfW"
#define kSecretKey @"D9qkmHQ91RXRmD1tMz6AzyLNMMirsUEsNeKulJSZ"

@implementation LPUtility

+ (NSString *)hmacsha1:(NSString *)data secret:(NSString *)key
{
    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [data cStringUsingEncoding:NSASCIIStringEncoding];
    
    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
    
    NSString *hash = [QNUrlSafeBase64 encodeData:HMAC];//encodeString:output];
    
    return hash;
}

+ (NSString *)getQiniuImageURLStringWithBaseString:(NSString *)baseString imageSize:(CGSize)imageSize
{
    
    NSString *downloadString = [NSString stringWithFormat:@"%@?imageView2/2/w/%i/h/%i&e=%i", baseString, (int)imageSize.width, (int)imageSize.height, (int)[[NSDate date] timeIntervalSince1970] + 30];
    
    NSString *secretKey = [LPUtility hmacsha1:downloadString secret:kSecretKey];
    
    return [NSString stringWithFormat:@"%@&token=%@:%@", downloadString, kAccessKey, secretKey];
}

@end
