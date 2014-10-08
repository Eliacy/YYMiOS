//
//  CommentCell.m
//  YYMiOS
//
//  Created by lide on 14-10-8.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "CommentCell.h"

@implementation CommentCell

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
        _avatarImageView.backgroundColor = [UIColor brownColor];
        [self.contentView addSubview:_avatarImageView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_avatarImageView.frame.origin.x + _avatarImageView.frame.size.width + 15, _avatarImageView.frame.origin.y, 190, 20)];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textColor = [UIColor darkGrayColor];
        _nameLabel.font = [UIFont systemFontOfSize:16.0f];
        _nameLabel.text = @"红豆包女王";
        [self.contentView addSubview:_nameLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.frame.origin.x, _nameLabel.frame.origin.y + _nameLabel.frame.size.height + 10, _nameLabel.frame.size.width, _nameLabel.frame.size.height)];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.textColor = [UIColor grayColor];
        _timeLabel.font = [UIFont systemFontOfSize:14.0f];
        _timeLabel.text = @"17分钟前";
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
        _contentLabel.text = @"而“圣痕”除了具有宗教意义之外，也广泛地在文学作品中成为某种象征。例如世界名著《红字》，在作品末尾，男主人公由于长期的精神压力、负罪意识的折磨，竟使他的胸口真的出现一个红字的印迹。";
        [self.contentView addSubview:_contentLabel];
    }
    
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
