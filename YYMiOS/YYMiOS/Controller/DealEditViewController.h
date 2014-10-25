//
//  DealEditViewController.h
//  YYMiOS
//
//  Created by Lide on 14-10-25.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "BaseViewController.h"

@protocol DealEditViewControllerDelegate;

@interface DealEditViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>
{
    id<DealEditViewControllerDelegate>  _delegate;
    UIButton        *_deleteButton;
    
    UITableView     *_tableView;
    
    UIView          *_tableFooterView;
    UIButton        *_publishButton;
}

@property (assign, nonatomic) id<DealEditViewControllerDelegate> delegate;

@end

@protocol DealEditViewControllerDelegate <NSObject>

- (void)dealEditViewControllerDidClickDeleteButton:(DealEditViewController *)dealEditVC;
- (void)dealEditViewControllerDidClickPublishButton:(DealEditViewController *)dealEditVC;

@end
