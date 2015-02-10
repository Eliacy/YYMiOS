//
//  DynamicViewController.h
//  YYMiOS
//
//  Created by lide on 14-9-22.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "BaseViewController.h"
#import "SRRefreshView.h"
#import "TitleExpandKit.h"

@class TabViewController;

@interface DynamicViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate, SRRefreshDelegate>
{
    TitleExpandKit *_expandKit;
    NSMutableArray  *_optionsArray;
    
    TabViewController   *_tabVC;
    
    SRRefreshView   *_slimeView;
    UITableView     *_tableView;
    NSMutableArray  *_dynamicArray;
    
    UIButton        *_bestButton;
    UIButton        *_addButton;
    
    NSInteger       _selected;
}

@property (assign, nonatomic) TabViewController *tabVC;

@end
