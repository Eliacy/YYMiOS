//
//  GenderViewController.h
//  YYMiOS
//
//  Created by lide on 14-9-28.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "BaseViewController.h"

@interface GenderViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>
{
    UITableView     *_tableView;
}

@end
