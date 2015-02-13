//
//  CountryCell.h
//  YYMiOS
//
//  Created by 关旭 on 15-2-12.
//  Copyright (c) 2015年 Lide. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "City.h"

@interface CountryCell : UITableViewCell


/**
 *  布局
 *
 *  @param City                 接受城市实体
 *  @param SelectedCityName     所选城市名称
 */
- (void)layoutCellWithCity:(City *)city SelectedCityName:(NSString *)selectedCityName;

@end
