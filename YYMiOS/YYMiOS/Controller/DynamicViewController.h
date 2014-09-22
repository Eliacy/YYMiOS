//
//  DynamicViewController.h
//  YYMiOS
//
//  Created by lide on 14-9-22.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "BaseViewController.h"

@class TabViewController;

@interface DynamicViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>
{
    TabViewController   *_tabVC;
    
    UITableView     *_tableView;
    NSMutableArray  *_dynamicArray;
}

@property (assign, nonatomic) TabViewController *tabVC;

@end
