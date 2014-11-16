//
//  TipsDetailViewController.h
//  YYMiOS
//
//  Created by Lide on 14/11/17.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "BaseViewController.h"
#import "Tip.h"

@interface TipsDetailViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSInteger       _tipsId;
    Tip             *_tip;
    
    UITableView     *_tableView;
}

@property (assign, nonatomic) NSInteger tipsId;
@property (retain, nonatomic) Tip *tip;

@end
