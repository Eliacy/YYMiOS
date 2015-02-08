//
//  MessageDetailCell.m
//  YYMiOS
//
//  Created by Lide on 14/12/23.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "MessageDetailCell.h"

@implementation MessageDetailCell

@synthesize message = _message;
@synthesize user = _user;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self != nil)
    {
        self.backgroundColor = [UIColor clearColor];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, [UIScreen mainScreen].bounds.size.width - 15 * 2, 20)];
        _timeLabel.backgroundColor = [UIColor colorWithRed:204.0 / 255.0 green:204.0 / 255.0 blue:204.0 / 255.0 alpha:1.0];
        _timeLabel.layer.cornerRadius = 5.0f;
        _timeLabel.layer.masksToBounds = YES;
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.font = [UIFont systemFontOfSize:10.0f];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_timeLabel];
        
        _otherAvatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 33, 40, 40)];
        _otherAvatarImageView.backgroundColor = [UIColor clearColor];
        _otherAvatarImageView.layer.cornerRadius = 20.0f;
        _otherAvatarImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_otherAvatarImageView];
        
        _messageBackImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_otherAvatarImageView.frame.origin.x + _otherAvatarImageView.frame.size.width + 15, _otherAvatarImageView.frame.origin.y, 170, 40)];
        _messageBackImageView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_messageBackImageView];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, _messageBackImageView.frame.size.width - 10 * 2, _messageBackImageView.frame.size.height - 10 * 2)];
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.textColor = [UIColor colorWithRed:51.0 / 255.0 green:51.0 / 255.0 blue:51.0 / 255.0 alpha:1.0];
        _contentLabel.font = [UIFont systemFontOfSize:14.0f];
        _contentLabel.numberOfLines = 0;
        [_messageBackImageView addSubview:_contentLabel];
        
        _selfAvatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 15 - 40, 33, 40, 40)];
        _selfAvatarImageView.backgroundColor = [UIColor clearColor];
        _selfAvatarImageView.layer.cornerRadius = 20.0f;
        _selfAvatarImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_selfAvatarImageView];
    }
    
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setMessage:(EMMessage *)message
{
    if(_message != nil)
    {
        LP_SAFE_RELEASE(_message);
    }
    _message = [message retain];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:message.timestamp / 1000.0];
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"YYYY年MM月dd日 hh:mm"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    CGSize dateStringSize = [LPUtility getTextHeightWithText:dateString font:_timeLabel.font size:CGSizeMake(300, 20)];
    _timeLabel.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - dateStringSize.width - 10) / 2, _timeLabel.frame.origin.y, dateStringSize.width + 10, _timeLabel.frame.size.height);
    _timeLabel.text = dateString;
    
    _otherAvatarImageView.hidden = YES;
    _selfAvatarImageView.hidden = YES;
    
    CGSize textSize = [LPUtility getTextHeightWithText:[(EMTextMessageBody *)message.messageBodies.lastObject text] font:_contentLabel.font size:CGSizeMake(150, 2000)];
    
    if([message.from isEqualToString:_user.emUsername])
    {
        _otherAvatarImageView.hidden = NO;
        [_otherAvatarImageView setImageWithURL:[NSURL URLWithString:[LPUtility getQiniuImageURLStringWithBaseString:_user.userIcon.imageURL imageSize:CGSizeMake(80, 80)]]];
        
        _messageBackImageView.frame = CGRectMake(_otherAvatarImageView.frame.origin.x + _otherAvatarImageView.frame.size.width + 15, _otherAvatarImageView.frame.origin.y, textSize.width + 10 * 2, textSize.height + 10 * 2);
        _contentLabel.frame = CGRectMake(10, 10, textSize.width, textSize.height);
        _contentLabel.text = [(EMTextMessageBody *)message.messageBodies.lastObject text];
    }
    else
    {
        _selfAvatarImageView.hidden = NO;
        [_selfAvatarImageView setImageWithURL:[NSURL URLWithString:[LPUtility getQiniuImageURLStringWithBaseString:[[[User sharedUser] userIcon] imageURL] imageSize:CGSizeMake(80, 80)]]];
        
        _messageBackImageView.frame = CGRectMake(_selfAvatarImageView.frame.origin.x - textSize.width - 10 * 2 - 15, _selfAvatarImageView.frame.origin.y, textSize.width + 10 * 2, textSize.height + 10 * 2);
        _contentLabel.frame = CGRectMake(10, 10, textSize.width, textSize.height);
        _contentLabel.text = [(EMTextMessageBody *)message.messageBodies.lastObject text];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
