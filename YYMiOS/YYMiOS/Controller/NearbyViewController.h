//
//  NearbyViewController.h
//  YYMiOS
//
//  Created by lide on 14-9-22.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "BaseViewController.h"

@class TabViewController;

@interface NearbyViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>
{
    TabViewController   *_tabVC;
    
    UITableView     *_tableView;
    NSMutableArray  *_nearbyArray;
    
    UIButton        *_filterButton;
    UIButton        *_mapButton;
    
    NSInteger       _areaId;
    NSInteger       _categoryId;
    NSInteger       _order;
}

@property (assign, nonatomic) TabViewController *tabVC;

@property (assign, nonatomic) NSInteger areaId;
@property (assign, nonatomic) NSInteger categoryId;
@property (assign, nonatomic) NSInteger order;

@end
