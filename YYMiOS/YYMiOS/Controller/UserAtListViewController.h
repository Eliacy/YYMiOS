//
//  UserAtListViewController.h
//  YYMiOS
//
//  Created by Lide on 15/1/20.
//  Copyright (c) 2015年 Lide. All rights reserved.
//

#import "BaseViewController.h"

@protocol UserAtListViewControllerDelegate;

@interface UserAtListViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>
{
    id<UserAtListViewControllerDelegate>    _delegate;
    
    UIButton            *_confirmButton;
    NSMutableArray      *_selectArray;
    
    NSInteger           _type;
    NSMutableArray      *_followingArray;
    NSMutableArray      *_followerArray;
    
    UITableView         *_tableView;
    UIView              *_tableHeaderView;
    UIButton            *_followingButton;
    UIButton            *_followerButton;
}

@property (assign, nonatomic) id<UserAtListViewControllerDelegate> delegate;
@property (retain, nonatomic) NSMutableArray *selectArray;

@end

@protocol UserAtListViewControllerDelegate <NSObject>

- (void)userAtListViewControllerDidClickConfirmButton:(UserAtListViewController *)userAtListVC;

@end
