//
//  NearbyViewController.h
//  YYMiOS
//
//  Created by lide on 14-9-22.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "BaseViewController.h"
#import "SRRefreshView.h"

@class TabViewController;

@interface NearbyViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate, SRRefreshDelegate, UISearchBarDelegate, UISearchDisplayDelegate>
{
    TabViewController   *_tabVC;
    
    SRRefreshView   *_slimeView;
    UITableView     *_tableView;
    
    UIButton        *_filterButton;
    UIButton        *_mapButton;
    
    NSInteger       _range;
    NSInteger       _areaId;
    NSInteger       _categoryId;
    NSInteger       _order;
    
    
}

@property (assign, nonatomic) TabViewController *tabVC;
@property (assign, nonatomic) NSMutableArray *nearbyArray;


@property (assign, nonatomic) NSInteger areaId;
@property (assign, nonatomic) NSInteger categoryId;
@property (assign, nonatomic) NSInteger order;

//筛选界面所选数据
@property (assign, nonatomic) NSMutableArray *selectedAreaChildArray;
@property (assign, nonatomic) NSMutableArray *selectedCategoryChildArray;
@property (assign, nonatomic) NSMutableArray *selectedOrderChildArray;

@end
