//
//  FollowingViewController.h
//  YYMiOS
//
//  Created by Lide on 14/12/1.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "BaseViewController.h"

@interface FollowingViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSInteger       _userId;
    
    UITableView     *_tableView;
    NSMutableArray  *_followingArray;
}

@property (assign, nonatomic) NSInteger userId;

@end
