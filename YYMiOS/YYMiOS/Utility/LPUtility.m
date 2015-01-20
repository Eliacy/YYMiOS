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
#import "QNUploadOption.h"

#define kQiniuBucket @"youyoumm.qiniudn.com"

#define kAccessKey @"WOc4A537RGp5nKavmURZqF1v86h9zjDBJN8R_gfW"
#define kSecretKey @"D9qkmHQ91RXRmD1tMz6AzyLNMMirsUEsNeKulJSZ"

@implementation LPUtility

//序列化写入缓存
+ (void)archiveData:(NSArray *)array IntoCache:(NSString *)path
{
    NSArray *myPathList = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *myPath    = [myPathList  objectAtIndex:0];
    
    myPath = [myPath stringByAppendingPathComponent:path];
    if(![[NSFileManager defaultManager] fileExistsAtPath:myPath])
    {
        NSFileManager *fileManager = [NSFileManager defaultManager ];
        [fileManager URLForDirectory:NSApplicationSupportDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:NULL];
        [[NSFileManager defaultManager] createFileAtPath:myPath contents:nil attributes:nil];
    }
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:array];
    
    dispatch_queue_t queue = dispatch_queue_create("com.liepin.archive", NULL);
    dispatch_sync(queue, ^{
        if(![data writeToFile:myPath atomically:YES])
        {
            
        }
    });
}

+ (NSArray *)unarchiveDataFromCache:(NSString *)path
{
    NSArray *myPathList = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *myPath    = [myPathList  objectAtIndex:0];
    NSData *fData       = nil;
    
    myPath = [myPath stringByAppendingPathComponent:path];
    if([[NSFileManager defaultManager] fileExistsAtPath:myPath])
    {
        fData = [NSData dataWithContentsOfFile:myPath];
    }
    else
    {
    }
    if (fData == nil ) {
        return nil;
    }
    return [NSKeyedUnarchiver unarchiveObjectWithData:fData];
}

+ (void)deleteArchiveDataWithPath:(NSString *)path
{
    NSArray *myPathList = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *myPath    = [myPathList  objectAtIndex:0];
    NSError *err        = nil;
    
    myPath = [myPath stringByAppendingPathComponent:path];
    
    [[NSFileManager defaultManager] removeItemAtPath:myPath error:&err];
}

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
    double systemTimeStamp = [[[NSUserDefaults standardUserDefaults] objectForKey:@"SystemTimeStamp"] doubleValue];
    if([[NSDate date] timeIntervalSince1970] - systemTimeStamp > 86400)
    {
        systemTimeStamp = [[NSDate date] timeIntervalSince1970];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithDouble:systemTimeStamp] forKey:@"SystemTimeStamp"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    NSString *downloadString = [NSString stringWithFormat:@"%@?imageMogr2/thumbnail/!%ix%ir/quality/96&e=%i", baseString, (int)imageSize.width, (int)imageSize.height, (int)systemTimeStamp + 86400];
    
    NSString *secretKey = [LPUtility hmacsha1:downloadString secret:kSecretKey];
    
    return [NSString stringWithFormat:@"%@&token=%@:%@", downloadString, kAccessKey, secretKey];
}

+ (CGSize)getTextHeightWithText:(NSString *)text
                           font:(UIFont *)font
                           size:(CGSize)size
{
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        CGRect rect = [text boundingRectWithSize:size
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSFontAttributeName:font}
                                         context:nil];
        return rect.size;
    }
    else
    {
        CGSize textSize = [text sizeWithFont:font
                           constrainedToSize:size
                               lineBreakMode:NSLineBreakByWordWrapping];
        return textSize;
    }
}

+ (void)uploadImageToQiniuWithImage:(UIImage *)image
                            imageId:(NSInteger)imageId
                               type:(NSInteger)type
                             userId:(NSInteger)userId
                               note:(NSString *)note
                               name:(NSString *)name
                           complete:(QNUpCompletionHandler)completionHandler
{
    [[LPAPIClient sharedAPIClient] getQiniuUploadTokenWithImageId:imageId
                                                             type:type
                                                           userId:userId
                                                             note:note
                                                             name:name
                                                            width:image.size.width
                                                           height:image.size.height
                                                          success:^(id respondObject) {
                                                              
                                                              if(respondObject && [respondObject objectForKey:@"data"])
                                                              {
                                                                  respondObject = [respondObject objectForKey:@"data"];
                                                              }
                                                              
                                                              if([respondObject objectForKey:@"token"] && ![[respondObject objectForKey:@"token"] isEqual:[NSNull null]])
                                                              {
                                                                  NSString *uploadToken = [respondObject objectForKey:@"token"];
                                                                  
                                                                  QNUploadManager *uploadManager = [[QNUploadManager alloc] init];
                                                                  
                                                                  NSData *uploadData = UIImagePNGRepresentation(image);
                                                                  
                                                                  QNUploadOption *opt = [[QNUploadOption alloc] initWithMime:@"image/png" progressHandler:nil params:nil checkCrc:YES cancellationSignal:nil];
                                                                  
                                                                  [uploadManager putData:uploadData
                                                                                     key:name
                                                                                   token:uploadToken
                                                                                complete:completionHandler
                                                                                  option:opt];
                                                              }
                                                              
                                                          } failure:^(NSError *error) {
                                                              
                                                          }];
    
//    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
//    
//    [params setObject:[NSString stringWithFormat:@"%@:%@", kQiniuBucket, name] forKey:@"scope"];
//    double systemTimeStamp = [[[NSUserDefaults standardUserDefaults] objectForKey:@"SystemTimeStamp"] doubleValue];
//    if([[NSDate date] timeIntervalSince1970] - systemTimeStamp > 86400)
//    {
//        systemTimeStamp = [[NSDate date] timeIntervalSince1970];
//        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithDouble:systemTimeStamp] forKey:@"SystemTimeStamp"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }
//    [params setObject:[NSNumber numberWithInt:(int)systemTimeStamp + 86400] forKey:@"deadline"];
//    [params setObject:@"http://rpc.youyoumm.com/rpc/images/call" forKey:@"callbackUrl"];
//    
//    NSMutableDictionary *callbackBody = [NSMutableDictionary dictionaryWithCapacity:0];
//    if(imageId > 0)
//    {
//        [callbackBody setObject:[NSNumber numberWithInteger:imageId] forKey:@"id"];
//    }
//    [callbackBody setObject:[NSNumber numberWithInteger:type] forKey:@"type"];
//    [callbackBody setObject:[NSNumber numberWithInteger:userId] forKey:@"user"];
//    if(note && ![note isEqualToString:@""])
//    {
//        [callbackBody setObject:note forKey:@"note"];
//    }
//    if(name && ![name isEqualToString:@""])
//    {
//        [callbackBody setObject:name forKey:@"name"];
//    }
//    [callbackBody setObject:@"$(fsize)" forKey:@"size"];
//    [callbackBody setObject:@"$(mimeType)" forKey:@"mime"];
//    [callbackBody setObject:[NSNumber numberWithInteger:image.size.width] forKey:@"width"];
//    [callbackBody setObject:[NSNumber numberWithInteger:image.size.height] forKey:@"height"];
//    [callbackBody setObject:@"$(etag)" forKey:@"hash"];
//    [params setObject:callbackBody forKey:@"callbackBody"];
//    
//    NSData *putPolicy = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
//    NSString *encodePutPolicy = [QNUrlSafeBase64 encodeData:putPolicy];
//    NSString *encodeSign = [LPUtility hmacsha1:encodePutPolicy secret:kSecretKey];
//    
//    NSString *uploadToken = [NSString stringWithFormat:@"%@:%@:%@", kAccessKey, encodeSign, encodePutPolicy];
//    
//    QNUploadManager *uploadManager = [[[QNUploadManager alloc] init] autorelease];
//    
//    NSData *uploadData = UIImagePNGRepresentation(image);
//    
//    [uploadManager putData:uploadData
//                       key:name
//                     token:uploadToken
//                  complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
//                      
//                      NSLog(@"%@", [resp description]);
//                      
//                  } option:nil];
}

+ (void)uploadImageToQiniuWithFilePath:(NSString *)filePath
                               imageId:(NSInteger)imageId
                                  type:(NSInteger)type
                                userId:(NSInteger)userId
                                  note:(NSString *)note
                                  name:(NSString *)name
                              complete:(QNUpCompletionHandler)completionHandler
{
    [[LPAPIClient sharedAPIClient] getQiniuUploadTokenWithImageId:imageId
                                                             type:type
                                                           userId:userId
                                                             note:note
                                                             name:name
                                                            width:640
                                                           height:480
                                                          success:^(id respondObject) {
                                                              
                                                              if(respondObject && [respondObject objectForKey:@"data"])
                                                              {
                                                                  respondObject = [respondObject objectForKey:@"data"];
                                                              }
                                                              
                                                              if([respondObject objectForKey:@"token"] && ![[respondObject objectForKey:@"token"] isEqual:[NSNull null]])
                                                              {
                                                                  NSString *uploadToken = [respondObject objectForKey:@"token"];
                                                                  
                                                                  QNUploadManager *uploadManager = [[QNUploadManager alloc] init];
                                                                  QNUploadOption *opt = [[QNUploadOption alloc] initWithMime:@"image/png" progressHandler:nil params:nil checkCrc:YES cancellationSignal:nil];
                                                                  
                                                                  [uploadManager putFile:filePath
                                                                                     key:name
                                                                                   token:uploadToken
                                                                                complete:completionHandler
                                                                                  option:opt];
                                                              }
                                                              
                                                          } failure:^(NSError *error) {
                                                              
                                                          }];
}

//解析字符串时间戳：
//参考自：http://zurb.com/forrst/posts/NSDate_from_Internet_Date_Time_String-evA
+ (NSDate *)dateFromInternetDateTimeString:(NSString *)dateString
{
    // Setup Date & Formatter
    NSDate *date = nil;
    static NSDateFormatter *formatter = nil;
    if (!formatter) {
        // ToDo: 不确定这一段对不对。解析时候每次都把时区当做 0 时区是对的么？是否 model 中永远存 0 时区的，输出时根据当前时区再做处理？
        NSLocale *en_US_POSIX = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        formatter = [[NSDateFormatter alloc] init];
        [formatter setLocale:en_US_POSIX];
        [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        [en_US_POSIX release];
    }
    
    /*
     *  RFC3339
     */
    
    NSString *RFC3339String = [[NSString stringWithString:dateString] uppercaseString];
    RFC3339String = [RFC3339String stringByReplacingOccurrencesOfString:@"Z" withString:@"-0000"];
    
    // Remove colon in timezone as iOS 4+ NSDateFormatter breaks
    // See https://devforums.apple.com/thread/45837
    if (RFC3339String.length > 20) {
        RFC3339String = [RFC3339String stringByReplacingOccurrencesOfString:@":"
                                                                 withString:@""
                                                                    options:0
                                                                      range:NSMakeRange(20, RFC3339String.length-20)];
    }
    
    if (!date) { // 1996-12-19T16:39:57-0800
        [formatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"];
        date = [formatter dateFromString:RFC3339String];
    }
    if (!date) { // 1937-01-01T12:00:27.87+0020
        [formatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSSZZZ"];
        date = [formatter dateFromString:RFC3339String];
    }
    if (!date) { // 1937-01-01T12:00:27
        [formatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss"]; 
        date = [formatter dateFromString:RFC3339String];
    }
    if (date) return date;
    
    // Failed
    return nil;
    
}

//以用户友好的方式输出时间戳：
+ (NSString *)friendlyStringFromDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    
    [formatter setTimeZone:timeZone];
    // ToDo: 希望改成仿微信式的时间显示风格。。
    [formatter setDateFormat : @"yyyy年M月d日 H点m分"];
    
    return [formatter stringFromDate:date];
}

@end
