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
    
    UIButton        *_titleButton;
    UIButton        *_bestButton;
    UIButton        *_addButton;
    
    //国家、城市
    NSInteger       _citySelected;
    //精选、最新
    NSInteger       _newSelected;
    
    //无数据时底图
    UIImageView     *_noneDataImageView;
    
}

@property (assign, nonatomic) TabViewController *tabVC;

@end
