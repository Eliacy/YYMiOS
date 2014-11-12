//
//  ShopDetailView.h
//  YYMiOS
//
//  Created by Lide on 14/11/13.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "POIDetail.h"

@interface ShopDetailView : UIView <UITableViewDataSource, UITableViewDelegate>
{
    POIDetail       *_poiDetail;
    
    UITableView     *_tableView;
}

@property (retain, nonatomic) POIDetail *poiDetail;

+ (CGFloat)getShopDetailViewHeightWithPOIDetail:(POIDetail *)poiDetail;

@end
