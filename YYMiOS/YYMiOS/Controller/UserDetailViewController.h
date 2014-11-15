//
//  UserDetailViewController.h
//  YYMiOS
//
//  Created by Lide on 14/11/15.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "BaseViewController.h"

@interface UserDetailViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>
{
    UITableView     *_tableView;
    NSMutableArray  *_dealArray;
    
    UIView          *_tableHeaderView;
}

@end
