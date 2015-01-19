//
//  POISelectViewController.h
//  YYMiOS
//
//  Created by Lide on 15/1/19.
//  Copyright (c) 2015年 Lide. All rights reserved.
//

#import "BaseViewController.h"
#import "POI.h"
#import "SRRefreshView.h"

@protocol POISelectViewControllerDelegate;

@interface POISelectViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate, SRRefreshDelegate>
{
    id<POISelectViewControllerDelegate> _delegate;
    
    UITableView     *_tableView;
    SRRefreshView   *_slimeView;
    NSMutableArray  *_poiArray;
}

@property (assign, nonatomic) id<POISelectViewControllerDelegate> delegate;

@end

@protocol POISelectViewControllerDelegate <NSObject>

- (void)poiSelectViewControllerDidSelectPOI:(POI *)poi;

@end