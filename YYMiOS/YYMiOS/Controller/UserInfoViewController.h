//
//  UserInfoViewController.h
//  YYMiOS
//
//  Created by lide on 14-9-25.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "BaseViewController.h"

@interface UserInfoViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>
{
    UITableView     *_tableView;
    
    UIView          *_tableFooterView;
    UIButton        *_logoutButton;
}

@end
