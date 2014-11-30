//
//  UserDetailViewController.h
//  YYMiOS
//
//  Created by Lide on 14/11/15.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "BaseViewController.h"

@interface UserDetailViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSInteger       _userId;
    User            *_user;
    
    UITableView     *_tableView;
    NSMutableArray  *_dealArray;
    
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
}

@property (assign, nonatomic) NSInteger userId;
@property (retain, nonatomic) User *user;

@end
