//
//  ShopViewController.h
//  YYMiOS
//
//  Created by lide on 14-10-2.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "BaseViewController.h"
#import <MapKit/MapKit.h>

@interface ShopViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>
{
    UIView          *_footerView;
    UITextField     *_textField;
    UIButton        *_sendButton;
    
    UITableView     *_tableView;
    NSMutableArray  *_dealArray;
    
    UIView          *_tableHeaderView;
    MKMapView       *_mapView;
    UIView          *_floatView;
    UILabel         *_mapLabel;
}

@end
