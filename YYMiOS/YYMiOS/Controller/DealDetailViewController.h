//
//  DealDetailViewController.h
//  YYMiOS
//
//  Created by lide on 14-10-5.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "BaseViewController.h"

@interface DealDetailViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>
{
    UIButton        *_shareButton;
    
    UIView          *_footerView;
    UITextField     *_textField;
    UIButton        *_sendButton;
    
    UITableView     *_tableView;
    NSMutableArray  *_commentArray;
    
    UIView          *_tableHeaderView;
    UIImageView     *_avatarImageView;
    UILabel         *_nameLabel;
    UILabel         *_timeLabel;
    UIButton        *_followButton;
    UIButton        *_followingButton;
    UIButton        *_followerButton;
    UILabel         *_contentLabel;
}

@end