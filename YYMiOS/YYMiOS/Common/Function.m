//
//  Function.m
//  YYMiOS
//
//  Created by 关旭 on 15-1-21.
//  Copyright (c) 2015年 Lide. All rights reserved.
//

#import "Function.h"

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

@end
