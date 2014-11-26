//
//  LPUtility.h
//  YYMiOS
//
//  Created by Lide on 14-11-6.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "LPObject.h"

@interface LPUtility : LPObject

//序列化写入缓存
+ (void)archiveData:(NSArray *)array IntoCache:(NSString *)path;
+ (NSArray *)unarchiveDataFromCache:(NSString *)path;

+ (void)deleteArchiveDataWithPath:(NSString *)path;

+ (NSString *)getQiniuImageURLStringWithBaseString:(NSString *)baseString imageSize:(CGSize)imageSize;
//计算文本高度
+ (CGSize)getTextHeightWithText:(NSString *)text
                           font:(UIFont *)font
                           size:(CGSize)size;

@end
