//
//  CommentCell.m
//  YYMiOS
//
//  Created by lide on 14-10-8.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "CommentCell.h"

@implementation CommentCell

@synthesize comment = _comment;

#pragma mark - private

- (void)clickReplyButton:(id)sender
{

}

#pragma mark - super

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self != nil)
    {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 50, 50)];
        _avatarImageView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_avatarImageView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_avatarImageView.frame.origin.x + _avatarImageView.frame.size.width + 15, _avatarImageView.frame.origin.y, 190, 20)];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textColor = [UIColor darkGrayColor];
        _nameLabel.font = [UIFont systemFontOfSize:16.0f];
        [self.contentView addSubview:_nameLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.frame.origin.x, _nameLabel.frame.origin.y + _nameLabel.frame.size.height + 10, _nameLabel.frame.size.width, _nameLabel.frame.size.height)];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.textColor = [UIColor grayColor];
        _timeLabel.font = [UIFont systemFontOfSize:14.0f];
        [self.contentView addSubview:_timeLabel];
        
        _replyButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        _replyButton.frame = CGRectMake(320 - 40 - 15, 15, 40, 40);
        _replyButton.backgroundColor = [UIColor clearColor];
        [_replyButton setTitle:@"回复" forState:UIControlStateNormal];
        [_replyButton setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
        _replyButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [_replyButton addTarget:self action:@selector(clickReplyButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_replyButton];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(_avatarImageView.frame.origin.x, _avatarImageView.frame.origin.y + _avatarImageView.frame.size.height + 5, 290, 30)];
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.textColor = [UIColor darkGrayColor];
        _contentLabel.font = [UIFont systemFontOfSize:14.0f];
        _contentLabel.numberOfLines = 0;
        [self.contentView addSubview:_contentLabel];
    }
    
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setComment:(Comment *)comment
{
    if(_comment != nil)
    {
        LP_SAFE_RELEASE(_comment);
    }
    _comment = [comment retain];
    
    [_avatarImageView setImageWithURL:[NSURL URLWithString:[LPUtility getQiniuImageURLStringWithBaseString:comment.user.userIcon.imageURL imageSize:CGSizeMake(100, 100)]]];
    _nameLabel.text = comment.user.userName;
    _timeLabel.text = comment.updateTime;
    
    CGSize contentSize = [LPUtility getTextHeightWithText:comment.content
                                                     font:_contentLabel.font
                                                     size:CGSizeMake(_contentLabel.frame.size.width, 2000)];
    
    _contentLabel.frame = CGRectMake(_contentLabel.frame.origin.x, _contentLabel.frame.origin.y, _contentLabel.frame.size.width, contentSize.height);
    _contentLabel.text = comment.content;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
