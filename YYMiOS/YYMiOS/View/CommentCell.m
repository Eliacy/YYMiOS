//
//  CommentCell.m
//  YYMiOS
//
//  Created by lide on 14-10-8.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "CommentCell.h"
#import "Function.h"
#import "Constant.h"

@implementation CommentCell

@synthesize comment = _comment;
@synthesize delegate = _delegate;

#pragma mark - private
#pragma mark - 点击回复
- (void)clickReplyButton:(id)sender
{
    if(_delegate && [_delegate respondsToSelector:@selector(commentCellDidClickReplyButton:)])
    {
        [_delegate commentCellDidClickReplyButton:self];
    }
}

#pragma mark - 点击@用户
- (void)clickAtButton:(id)sender
{
    if(_delegate && [_delegate respondsToSelector:@selector(commentCellDidClickAtButton:)])
    {
        [_delegate commentCellDidClickAtButton:self];
    }
}

#pragma mark - super

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self != nil)
    {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        //头像
        _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 50, 50)];
        _avatarImageView.backgroundColor = [UIColor clearColor];
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        _avatarImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_avatarImageView];
        
        //姓名
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_avatarImageView.frame.origin.x + _avatarImageView.frame.size.width + 15, _avatarImageView.frame.origin.y, 190, 20)];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textColor = [UIColor darkGrayColor];
        _nameLabel.font = [UIFont systemFontOfSize:16.0f];
        [self.contentView addSubview:_nameLabel];
        
        //时间
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.frame.origin.x, _nameLabel.frame.origin.y + _nameLabel.frame.size.height + 10, _nameLabel.frame.size.width, _nameLabel.frame.size.height)];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.textColor = [UIColor grayColor];
        _timeLabel.font = [UIFont systemFontOfSize:14.0f];
        [self.contentView addSubview:_timeLabel];
        
        //回复按钮
        _replyButton = [[[UIButton buttonWithType:UIButtonTypeCustom] retain] autorelease];
        _replyButton.frame = CGRectMake(320 - 40 - 15, 15, 40, 40);
        _replyButton.backgroundColor = [UIColor clearColor];
        [_replyButton setTitle:@"回复" forState:UIControlStateNormal];
        [_replyButton setTitleColor:GColor(251, 94, 128) forState:UIControlStateNormal];
        [_replyButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        _replyButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [_replyButton addTarget:self action:@selector(clickReplyButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_replyButton];
        
        //评论内容
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(_avatarImageView.frame.origin.x, _avatarImageView.frame.origin.y + _avatarImageView.frame.size.height + 5, 290, 30)];
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.textColor = [UIColor darkGrayColor];
        _contentLabel.font = [UIFont systemFontOfSize:13.0f];
        _contentLabel.numberOfLines = 0;
        [self.contentView addSubview:_contentLabel];
        
        //@用户名按钮
        _atButton = [[[UIButton buttonWithType:UIButtonTypeCustom] retain] autorelease];
        _atButton.frame = CGRectMake(15, _avatarImageView.frame.origin.y + _avatarImageView.frame.size.height + 5, 100, 17);
        _atButton.backgroundColor = [UIColor clearColor];
        [_atButton setTitleColor:GColor(251, 91, 126) forState:UIControlStateNormal];
        [_atButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        _atButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [_atButton addTarget:self action:@selector(clickAtButton:) forControlEvents:UIControlEventTouchUpInside];
        _atButton.hidden = YES;
        [self.contentView addSubview:_atButton];
        
        //线
        [self.contentView addSubview:[Function createSeparatorViewWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, 1)]];
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
    _timeLabel.text = [LPUtility friendlyStringFromDate:comment.updateTime];
    
    //如果有@用户的情况
    if(_comment.atList.count>0){
        _atButton.hidden = NO;
        User *user = [_comment.atList objectAtIndex:0];
        CGSize userNameSize = [LPUtility getTextHeightWithText:[NSString stringWithFormat:@"%@%@",@"@",user.userName]
                                                          font:_atButton.titleLabel.font
                                                          size:CGSizeMake(300, 100)];
        //@用户名
        [_atButton setTitle:[NSString stringWithFormat:@"%@%@",@"@",user.userName] forState:UIControlStateNormal];
        [_atButton setFrame:CGRectMake(15, _avatarImageView.frame.origin.y + _avatarImageView.frame.size.height + 5, userNameSize.width, 17)];
        
        //拼接后续评论
        NSString *placeStr = @"";
        for(int i=0;i<user.userName.length;i++){
            placeStr = [placeStr stringByAppendingString:@"   "];
        }
        NSString *allStr = [NSString stringWithFormat:@"%@%@",placeStr,comment.content];
        CGSize contentSize = [LPUtility getTextHeightWithText:allStr
                                                         font:_contentLabel.font
                                                         size:CGSizeMake(_contentLabel.frame.size.width, 2000)];
        _contentLabel.frame = CGRectMake(_contentLabel.frame.origin.x, _contentLabel.frame.origin.y, _contentLabel.frame.size.width, contentSize.height);
        _contentLabel.text = [NSString stringWithFormat:@"%@%@",placeStr,comment.content];
        
    }else{
        _atButton.hidden = YES;
        //评论内容
        CGSize contentSize = [LPUtility getTextHeightWithText:comment.content
                                                         font:_contentLabel.font
                                                         size:CGSizeMake(_contentLabel.frame.size.width, 2000)];
        
        _contentLabel.frame = CGRectMake(_contentLabel.frame.origin.x, _contentLabel.frame.origin.y, _contentLabel.frame.size.width, contentSize.height);
        _contentLabel.text = comment.content;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
