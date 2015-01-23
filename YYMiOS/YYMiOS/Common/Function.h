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
 *
 *  @param Frame    尺寸
 *  @param FontSize 字号
 *  @param Text     文本
 */
+ (UILabel *)createLabelWithFrame:(CGRect)frame FontSize:(int)fontSize Text:(NSString *)text;

/**
 *  创建cell右侧箭头
 *
 *  @param Point    坐标
 */
+ (UIImageView *)createArrowImageViewWithPoint:(CGPoint)point;

/**
 *  创建textfield背景
 *
 *  @param Frame    尺寸
 */
+ (UIView *)createTextFieldBGWithFrame:(CGRect)frame;

/**
 *  创建textfield
 *
 *  @param Frame    尺寸
 *  @param Target   代理
 */
+ (UITextField *)createTextFieldWithFrame:(CGRect)frame Target:(id)target;


@end
