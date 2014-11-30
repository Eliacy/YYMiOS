//
//  MineViewController.h
//  YYMiOS
//
//  Created by lide on 14-9-22.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "BaseViewController.h"

@class TabViewController;

@interface MineViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>
{
    TabViewController   *_tabVC;
    
    UITableView     *_tableView;
    
    UIView          *_tableHeaderView;
    UIView          *_backView;
    UIImageView     *_avatarImageView;
    UILabel         *_nameLabel;
    UILabel         *_levelLabel;
    UIButton        *_followingButton;
    UIButton        *_followerButton;
    
    UIButton        *_likeButton;
    UIButton        *_shareButton;
    UIButton        *_commentButton;
    UIButton        *_favouriteButton;
    
    UIButton        *_settingButton;
    UIButton        *_messageButton;
    
    User            *_user;
}

@property (assign, nonatomic) TabViewController *tabVC;
@property (retain, nonatomic) User *user;

@end
