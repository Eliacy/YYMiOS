//
//  UserDetailViewController.h
//  YYMiOS
//
//  Created by Lide on 14/11/15.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "BaseViewController.h"

typedef enum _detailType
{
    DetailLike = 0,
    DetailShare = 1,
    DetailComment = 2,
    DetailCollect = 3,
}DetailType;

@interface UserDetailViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSInteger       _userId;
    User            *_user;
    
    UIButton        *_followButton;
    
    UITableView     *_tableView;
    NSInteger       _type;
    
    NSMutableArray  *_likeArray;
    NSMutableArray  *_shareArray;
    NSMutableArray  *_commentArray;
    NSMutableArray  *_favouriteArray;
    
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
    
    UIView          *_footerView;
    UIButton        *_messageButton;
    
    DetailType      _detailType;
    
    //无数据时底图
    UIImageView     *_noneDataImageView;
}

@property (assign, nonatomic) NSInteger userId;
@property (retain, nonatomic) User *user;

@property (assign, nonatomic) DetailType detailType;

@end
