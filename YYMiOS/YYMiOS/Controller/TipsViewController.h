//
//  TipsViewController.h
//  YYMiOS
//
//  Created by lide on 14-9-22.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "BaseViewController.h"

@interface TipsViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>
{
    UITableView     *_tableView;
    NSMutableArray  *_tipsArray;
}

@end
