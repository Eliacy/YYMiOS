//
//  HomeViewController.h
//  YYMiOS
//
//  Created by lide on 14-9-19.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "BaseViewController.h"
#import "SRRefreshView.h"
#import "TitleExpandKit.h"

@class TabViewController;

@interface HomeViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate, SRRefreshDelegate,NSFileManagerDelegate>
{
    
    TabViewController   *_tabVC;
    NSMutableArray  *_cityArray;
    
    SRRefreshView   *_slimeView;
    UITableView     *_tableView;
    NSMutableArray  *_homeArray;
    
    UIButton        *_tipsButton;
    UIButton        *_messageButton;
    
    UILabel         *_messageCountLabel;
    
}

@property (assign, nonatomic) TabViewController *tabVC;

- (void)refreshMessageCount:(NSInteger)count;

@end
