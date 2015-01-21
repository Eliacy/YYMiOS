//
//  Function.h
//  YYMiOS
//
//  Created by 关旭 on 15-1-21.
//  Copyright (c) 2015年 Lide. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Function : NSObject

/**
 *  创建通用label
 *  @param Frame    尺寸
 *  @param FontSize 字号
 *  @param Text     文本
 */
+ (UILabel *)createLabelWithFrame:(CGRect)frame FontSize:(int)fontSize Text:(NSString *)text;

@end
