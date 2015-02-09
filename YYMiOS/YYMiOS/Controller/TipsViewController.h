//
//  TipsViewController.h
//  YYMiOS
//
//  Created by lide on 14-9-22.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "BaseViewController.h"
#import "Tip.h"
#import "TitleExpandKit.h"

@interface TipsViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>
{
    TitleExpandKit *_expandKit;
    Tip             *_tip;
    NSMutableArray  *_tipArray;
    
    UIButton        *_moreButton;
    
    UITableView     *_tableView;
}

@property (retain, nonatomic) Tip *tip;

@end
