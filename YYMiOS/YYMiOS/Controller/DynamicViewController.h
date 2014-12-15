//
//  DynamicViewController.h
//  YYMiOS
//
//  Created by lide on 14-9-22.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "BaseViewController.h"
#import "SRRefreshView.h"

@class TabViewController;

@interface DynamicViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate, SRRefreshDelegate>
{
    TabViewController   *_tabVC;
    
    SRRefreshView   *_slimeView;
    UITableView     *_tableView;
    NSMutableArray  *_dynamicArray;
    
    UIButton        *_bestButton;
    UIButton        *_addButton;
}

@property (assign, nonatomic) TabViewController *tabVC;

@end
