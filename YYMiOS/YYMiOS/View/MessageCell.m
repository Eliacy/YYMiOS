//
//  MessageCell.m
//  YYMiOS
//
//  Created by Lide on 14/12/21.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "MessageCell.h"

@implementation MessageCell

@synthesize message = _message;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self != nil)
    {
        _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 65, 65)];
        _avatarImageView.backgroundColor = [UIColor clearColor];
        _avatarImageView.layer.cornerRadius = 32.5;
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_avatarImageView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_avatarImageView.frame.origin.x + _avatarImageView.frame.size.width + 15, _avatarImageView.frame.origin.y, [UIScreen mainScreen].bounds.size.width - _avatarImageView.frame.origin.x - _avatarImageView.frame.size.width - 15 - 15, 25)];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textColor = [UIColor colorWithRed:51.0 / 255.0 green:51.0 / 255.0 blue:51.0 / 255.0 alpha:1.0];
        _nameLabel.font = [UIFont systemFontOfSize:16.0f];
        [self.contentView addSubview:_nameLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:_nameLabel.frame];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.textColor = [UIColor colorWithRed:153.0 / 255.0 green:153.0 / 255.0 blue:153.0 / 255.0 alpha:1.0];
        _timeLabel.font = [UIFont systemFontOfSize:14.0f];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_timeLabel];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.frame.origin.x, _nameLabel.frame.origin.y + _nameLabel.frame.size.height, _nameLabel.frame.size.width, 40)];
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.textColor = [UIColor colorWithRed:153.0 / 255.0 green:153.0 / 255.0 blue:153.0 / 255.0 alpha:1.0];
        _contentLabel.font = [UIFont systemFontOfSize:14.0f];
        _contentLabel.numberOfLines = 2;
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

- (void)setMessage:(Message *)message
{
    if(_message != nil)
    {
        LP_SAFE_RELEASE(_message);
    }
    _message = [message retain];
    
    [_avatarImageView setImageWithURL:[NSURL URLWithString:[LPUtility getQiniuImageURLStringWithBaseString:message.user.userIcon.imageURL imageSize:CGSizeMake(130, 130)]]];
    _nameLabel.text = message.user.userName;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:(CGFloat)[message.conversation.latestMessage timestamp] / 1000.0];
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"MM月dd日 hh:mm"];
    _timeLabel.text = [dateFormatter stringFromDate:date];
    
    //显示文本类型消息
    if([(EMTextMessageBody *)[[[message.conversation latestMessage] messageBodies] firstObject] messageBodyType]==eMessageBodyType_Text)
    {
        _contentLabel.text = [(EMTextMessageBody *)[[[message.conversation latestMessage] messageBodies] firstObject] text];
    }else if([(EMTextMessageBody *)[[[message.conversation latestMessage] messageBodies] firstObject] messageBodyType]==eMessageBodyType_Image){
        _contentLabel.text = @"[图片]";
    }
}

@end
