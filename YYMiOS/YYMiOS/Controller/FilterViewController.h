//
//  FilterViewController.h
//  YYMiOS
//
//  Created by lide on 14-10-2.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "BaseViewController.h"
#import "NearbyViewController.h"

@interface FilterViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>
{
    UIButton        *_searchButton;
    
    UITableView     *_tableView;
    NSMutableArray  *_rangeArray;
    NSMutableArray  *_areaArray;
    NSMutableArray  *_categoryArray;
    
    UIButton        *_scaleButton;
    UIButton        *_categoryButton;
    UIButton        *_orderButton;
    
    BOOL            _scaleExpandFlag;
    BOOL            _categoryExpandFlag;
    BOOL            _orderExpandFlag;
    
    NSInteger       _range;
    NSInteger       _areaId;
    NSInteger       _categoryId;
    NSInteger       _order;
    
    NearbyViewController    *_nearbyVC;
}

@property (assign, nonatomic) NSInteger areaId;
@property (assign, nonatomic) NSInteger categoryId;
@property (assign, nonatomic) NSInteger order;

@property (assign, nonatomic) NearbyViewController *nearbyVC;

@end
