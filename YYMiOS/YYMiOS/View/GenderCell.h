//
//  GenderCell.h
//  YYMiOS
//
//  Created by 关旭 on 15-1-22.
//  Copyright (c) 2015年 Lide. All rights reserved.
//

#import <UIKit/UIKit.h>

//性别
#define genderStrArray @[@"男",@"女"]

@interface GenderCell : UITableViewCell

/**
 *  布局
 *
 *  @param Row      行数
 *  @param Gender   性别状态
 */
- (void)layoutCellWithRow:(int)row Gender:(NSString *)gender;

@end
