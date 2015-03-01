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

/**
 *  创建cell分割线
 *
 *  @param Frame    尺寸
 */
+ (UIView *)createSeparatorViewWithFrame:(CGRect)frame;

/**
 *  添加一条默认数据
 *
 *  @param Sender       发送方
 *  @param Receiver     接收方
 *  @param Text         文本
 *
 */
+ (EMMessage *)addMessageWithSender:(NSString *)sender Receiver:(NSString *)receiver Text:(NSString *)text;

/**
 *  添加一条默认数据
 *
 *  @param TagsArray    徽章文本组成的序列
 *  @param OffsetX      徽章显示起始位置偏移量（横轴）
 *  @param OffsetY      徽章显示起始位置偏移量（纵轴）
 *  @param Width        单行允许宽度
 *
 */
+ (NSMutableArray *)addBadgesWithArray:(NSArray *)tagsArray OffsetX:(CGFloat)offsetX OffsetY:(CGFloat)offsetY Width:(CGFloat)width;

/**
 *  通过色值创建图片
 *
 *  @param Color    色值
 */
+ (UIImage *)createImageWithColor:(UIColor *)color;

/**
 *  持久化存储
 *
 *  @param Object    存储内容
 *  @param Key       存储标示
 */
+ (void)setAsynchronousWithObject:(id)object Key:(NSString *)key;

/**
 *  清空存储数据
 *
 *  @param Key       存储标示
 */
+ (void)clearAsynchronousWithKey:(NSString *)key;

/**
 *  获取本地保存数据
 *
 *  @param Key       存储标示
 */
+ (id)getAsynchronousWithKey:(NSString *)key;


/**
 *  返回当前时间的毫秒格式
 */
+ (UInt64)getCurrentSysTime;

/**
 *  根据两点的经纬度算距离
 *
 *  @param Location1Lat    经度1
 *  @param Location1Lon    纬度1
 *  @param Location2Lat    经度2
 *  @param Location2Lon    纬度2
 */
+ (CLLocationDistance)getDistanceFromLocation1Lat:(double)location1Lat Location1Lon:(double)location1Lon Location2Lat:(double)location2Lat Location2Lon:(double)location2Lon;

/**
 *  布局标题按钮
 */
+ (void)layoutPlayWayBtnWithTitle:(NSString *)title Button:(UIButton *)titleBtn;

/**
 *  计算label高度
 *
 *  @param Content          内容
 *  @param BoundingSize     尺寸
 *  @param Font             字体
 */
+ (CGFloat)getLabelHeightWithContent:(NSString *)content BoundingSize:(CGSize)boundingSize Font:(UIFont *)font;
@end
