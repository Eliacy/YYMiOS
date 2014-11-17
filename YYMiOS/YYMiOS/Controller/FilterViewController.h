//
//  FilterViewController.h
//  YYMiOS
//
//  Created by lide on 14-10-2.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "BaseViewController.h"

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
}

@end
