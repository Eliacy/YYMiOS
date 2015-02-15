//
//  Function.m
//  YYMiOS
//
//  Created by 关旭 on 15-1-21.
//  Copyright (c) 2015年 Lide. All rights reserved.
//

#import "Function.h"
#import "Constant.h"

#define kBadgesImageViewTag 18926

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
    message.timestamp = [[NSDate date] timeIntervalSince1970] * 1000;   // 设置消息发送时间为当前时间。
    return message;
}

#pragma mark - 生成用户勋章标签
+ (NSMutableArray *)addBadgesWithArray:(NSArray *)tagsArray OffsetX:(CGFloat)offsetX OffsetY:(CGFloat)offsetY Width:(CGFloat)width
{
    NSMutableArray *badges = [[NSMutableArray alloc] init];
    
    for(NSInteger i = 0; i < [tagsArray count]; i++)
    {
        NSString *badge = [tagsArray objectAtIndex:i];
        CGSize badgeSize = [LPUtility getTextHeightWithText:badge
                                                       font:[UIFont systemFontOfSize:10.0f]
                                                       size:CGSizeMake(200, 100)];
        if(offsetX + badgeSize.width + 5 + 10 > width - 15)
        {
            // TODO: 这里本来应该把用户的勋章显示全，但由于“个人主页”的“喜欢”按钮那一行没有做位置自适应，因而还没做到。
            break;
            //            offsetX = _followingButton.frame.origin.x;
            //            offsetY += 25;
        }
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(offsetX, offsetY + 2, badgeSize.width + 5, 14)];
        imageView.backgroundColor = [UIColor clearColor];
        imageView.image = [[UIImage imageNamed:[NSString stringWithFormat:@"%i.png", (int)(i % 6 + 1)]] stretchableImageWithLeftCapWidth:5 topCapHeight:0];
        imageView.tag = kBadgesImageViewTag + i;
        [badges addObject:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 1, imageView.frame.size.width, 12)];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:10.0f];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = badge;
        [imageView addSubview:label];
        
        offsetX += badgeSize.width + 5 + 10;
    }

    return badges;
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

#pragma mark - 返回当前时间的毫秒格式
+ (UInt64)getCurrentSysTime
{
    return [[NSDate date] timeIntervalSince1970];
}

#pragma mark - 根据两点的经纬度算距离
+ (CLLocationDistance)getDistanceFromLocation1Lat:(double)location1Lat Location1Lon:(double)location1Lon Location2Lat:(double)location2Lat Location2Lon:(double)location2Lon
{
    CLLocation  *location1=[[CLLocation alloc] initWithLatitude:location1Lat  longitude:location1Lon];
    CLLocation  *location2=[[CLLocation alloc] initWithLatitude:location2Lat  longitude:location2Lon];
    return [location1 distanceFromLocation:location2]/1000;
}

@end
