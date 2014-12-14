//
//  UserListCell.h
//  YYMiOS
//
//  Created by Lide on 14/12/13.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface UserListCell : UITableViewCell
{
    User            *_user;
    
    UIImageView     *_avatarImageView;
    UILabel         *_nameLabel;
    UILabel         *_levelLabel;
    UIButton        *_followingButton;
    UIButton        *_followerButton;
}

@property (retain, nonatomic) User *user;

@end
