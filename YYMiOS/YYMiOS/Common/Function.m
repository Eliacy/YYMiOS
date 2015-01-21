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

@end
