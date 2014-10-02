//
//  SettingCell.h
//  YYMiOS
//
//  Created by lide on 14-9-30.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingCell : UITableViewCell
{
    UILabel     *_titleLabel;
    UISwitch    *_switchButton;
}

@property (retain, nonatomic) UILabel *titleLabel;
@property (retain, nonatomic) UISwitch *switchButton;

@end
