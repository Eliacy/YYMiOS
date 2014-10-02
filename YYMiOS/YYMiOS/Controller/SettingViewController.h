//
//  SettingViewController.h
//  YYMiOS
//
//  Created by lide on 14-9-24.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "BaseViewController.h"

@interface SettingViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>
{
    UITableView     *_tableView;
   
    UIView          *_tableHeaderView;
    UIView          *_tableBackView;
    UILabel         *_tableHeaderLabel;
}

@end
