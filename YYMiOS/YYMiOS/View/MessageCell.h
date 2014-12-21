//
//  MessageCell.h
//  YYMiOS
//
//  Created by Lide on 14/12/21.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Message.h"

@interface MessageCell : UITableViewCell
{
    Message         *_message;
    
    UIImageView     *_avatarImageView;
    UILabel         *_nameLabel;
    UILabel         *_timeLabel;
    UILabel         *_contentLabel;
}

@property (retain, nonatomic) Message *message;

@end
