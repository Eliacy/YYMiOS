//
//  Function.m
//  YYMiOS
//
//  Created by 关旭 on 15-1-21.
//  Copyright (c) 2015年 Lide. All rights reserved.
//

#import "Function.h"
#import "Constant.h"

@implementation Function

#pragma mark - 创建通用label
+ (UILabel *)createLabelWithFrame:(CGRect)frame FontSize:(int)fontSize Text:(NSString *)text
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:fontSize];
    label.textAlignment = NSTextAlignmentLeft;
    label.text = text;
    return label;
}

#pragma mark - 创建cell右侧箭头
+ (UIImageView *)createArrowImageViewWithPoint:(CGPoint)point
{
    UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(point.x, point.y, 8, 12)];
    arrowImageView.image = [UIImage imageNamed:@"icon_right"];
    return arrowImageView;
}

#pragma mark - 创建textfield背景
+ (UIView *)createTextFieldBGWithFrame:(CGRect)frame
{
    UIView *textFieldBG = [[UIView alloc] initWithFrame:frame];
    textFieldBG.backgroundColor = [UIColor colorWithRed:245.0 / 255.0 green:245.0 / 255.0 blue:245.0 / 255.0 alpha:1.0];
    textFieldBG.layer.borderWidth = 0.5;
    textFieldBG.layer.borderColor = [UIColor colorWithRed:200.0 / 255.0 green:200.0 / 255.0 blue:200.0 / 255.0 alpha:1.0].CGColor;
    textFieldBG.layer.cornerRadius = 3.0;
    textFieldBG.layer.masksToBounds = YES;
    return textFieldBG;
}

#pragma mark - 创建textfield
+ (UITextField *)createTextFieldWithFrame:(CGRect)frame Target:(id)target
{
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.backgroundColor = [UIColor clearColor];
    textField.delegate = target;
    return textField;
}

#pragma mark - 创建分割线
+ (UIView *)createSeparatorViewWithFrame:(CGRect)frame
{
    UIView *bgView = [[UIView alloc] initWithFrame:frame];
    bgView.backgroundColor = GColor(223, 223, 221);
    return bgView;
}

#pragma mark - 添加一条默认数据
+ (EMMessage *)addMessageWithSender:(NSString *)sender Receiver:(NSString *)receiver Text:(NSString *)text
{
    EMChatText *chatText = [[EMChatText alloc] initWithText:text];
    EMTextMessageBody *messageBody = [[EMTextMessageBody alloc] initWithChatObject:chatText];
    NSArray *bodies = [[NSArray alloc] initWithObjects:messageBody, nil];
    EMMessage *message = [[EMMessage alloc] initMessageWithID:nil sender:sender receiver:receiver bodies:bodies];
    return message;
}

//通过颜色创建图片
+ (UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

#pragma mark - 持久化存储
+ (void)setAsynchronousWithObject:(id)object Key:(NSString *)key
{
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    [info setObject:object forKey:key];
    [info synchronize];
}

#pragma mark - 清空数据
+ (void)clearAsynchronousWithKey:(NSString *)key
{
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    [info removeObjectForKey:key];
    [info synchronize];
}

#pragma mark - 获取保存数据
+ (id)getAsynchronousWithKey:(NSString *)key
{
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    return [info valueForKey:key];
}

@end
