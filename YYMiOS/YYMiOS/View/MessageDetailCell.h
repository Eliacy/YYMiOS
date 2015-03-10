//
//  MessageDetailCell.h
//  YYMiOS
//
//  Created by Lide on 14/12/23.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMMessage.h"

@interface MessageDetailCell : UITableViewCell
{
    EMMessage       *_message;
    User            *_user;
    
    UILabel         *_timeLabel;
    UIImageView     *_otherAvatarImageView;
    UIImageView     *_messageBackImageView;
    UILabel         *_contentLabel;
    UIImageView     *_selfAvatarImageView;
    UIImageView     *_contentImageView;
}

@property (retain, nonatomic) EMMessage *message;
@property (retain, nonatomic) User *user;

@end
