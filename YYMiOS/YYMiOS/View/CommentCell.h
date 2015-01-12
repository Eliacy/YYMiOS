//
//  CommentCell.h
//  YYMiOS
//
//  Created by lide on 14-10-8.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comment.h"

@protocol CommentCellDelegate;

@interface CommentCell : UITableViewCell
{
    Comment         *_comment;
    
    UIImageView     *_avatarImageView;
    UILabel         *_nameLabel;
    UILabel         *_timeLabel;
    UILabel         *_contentLabel;
    UIButton        *_replyButton;
    
    id<CommentCellDelegate> _delegate;
}

@property (retain, nonatomic) Comment *comment;
@property (assign, nonatomic) id<CommentCellDelegate> delegate;

@end

@protocol CommentCellDelegate <NSObject>

- (void)commentCellDidClickReplyButton:(CommentCell *)commentCell;

@end
