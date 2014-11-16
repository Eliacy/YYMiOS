//
//  DealDetailViewController.h
//  YYMiOS
//
//  Created by lide on 14-10-5.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "BaseViewController.h"
#import "Deal.h"

@interface DealDetailViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>
{
    UIButton        *_shareButton;
    
    UIView          *_footerView;
    UIView          *_textBackView;
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
    UIView          *_line;
    
    Deal            *_deal;
    NSInteger       _dealId;
    NSInteger       _siteId;
}

@property (retain, nonatomic) Deal *deal;
@property (assign, nonatomic) NSInteger dealId;
@property (assign, nonatomic) NSInteger siteId;

@end
