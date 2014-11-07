//
//  LPUtility.h
//  YYMiOS
//
//  Created by Lide on 14-11-6.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "LPObject.h"

@interface LPUtility : LPObject

+ (NSString *)getQiniuImageURLStringWithBaseString:(NSString *)baseString imageSize:(CGSize)imageSize;

@end
