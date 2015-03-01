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
}

@property (retain, nonatomic) POIDetail *poiDetail;

@property (retain, nonatomic) UITableView *tableView;
//各cell当期高度
@property (retain, nonatomic) NSMutableArray *cellCurrentHeightArray;
//各cell实际高度
@property (retain, nonatomic) NSMutableArray *cellActualHeightArray;

@property (assign, nonatomic) BOOL isNotification;


+ (CGFloat)getShopDetailViewHeightWithPOIDetail:(POIDetail *)poiDetail;

@end
