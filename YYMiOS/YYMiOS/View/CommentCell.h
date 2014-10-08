//
//  CommentCell.h
//  YYMiOS
//
//  Created by lide on 14-10-8.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentCell : UITableViewCell
{
    UIImageView     *_avatarImageView;
    UILabel         *_nameLabel;
    UILabel         *_timeLabel;
    UILabel         *_contentLabel;
    UIButton        *_replyButton;
}

@end
