//
//  HomeViewController.h
//  YYMiOS
//
//  Created by lide on 14-9-19.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "BaseViewController.h"

@class TabViewController;

@interface HomeViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>
{
    TabViewController   *_tabVC;
    
    UITableView     *_tableView;
    NSMutableArray  *_homeArray;
    
    UIButton        *_tipsButton;
    UIButton        *_messageButton;
}

@property (assign, nonatomic) TabViewController *tabVC;

@end
