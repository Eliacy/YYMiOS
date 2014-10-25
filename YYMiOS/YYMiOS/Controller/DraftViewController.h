//
//  DraftViewController.h
//  YYMiOS
//
//  Created by lide on 14-9-28.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "BaseViewController.h"

@interface DraftViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>
{
    UIButton        *_addButton;
    
    UITableView     *_tableView;
    NSMutableArray  *_draftArray;
}

@end
