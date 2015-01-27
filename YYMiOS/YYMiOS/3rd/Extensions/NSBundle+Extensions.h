//
//  NSBundle+Extentions.h
//  DiabetesManager
//
//  Created by majianglin on 13-5-30.
//  Copyright (c) 2013年 totemtec.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSBundle(Extentions)

//应用标识
+ (NSString *)bundleIdentifier;

//应用名称
+ (NSString *)bundleName;

//应用显示名称
+ (NSString *)bundleDisplayName;

//应用版本号
+ (NSString *)bundleVersion;

//读取文件内容，返回对象。支持plist和json，通过文件名后缀判断文件类型
+ (id)objectFromFile:(NSString *)fileName;

@end
