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
        
        //时间
        _timeLabel = [[[UILabel alloc] initWithFrame:CGRectMake(15, 0, [UIScreen mainScreen].bounds.size.width - 15 * 2, 20)] autorelease];
        _timeLabel.backgroundColor = [UIColor colorWithRed:204.0 / 255.0 green:204.0 / 255.0 blue:204.0 / 255.0 alpha:1.0];
        _timeLabel.layer.cornerRadius = 5.0f;
        _timeLabel.layer.masksToBounds = YES;
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.font = [UIFont systemFontOfSize:10.0f];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_timeLabel];
        
        //对方头像
        _otherAvatarImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(15, 33, 40, 40)] autorelease];
        _otherAvatarImageView.backgroundColor = [UIColor clearColor];
        _otherAvatarImageView.layer.cornerRadius = 20.0f;
        _otherAvatarImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_otherAvatarImageView];
        
        //自己头像
        _selfAvatarImageView = [[[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 15 - 40, 33, 40, 40)] autorelease];
        _selfAvatarImageView.backgroundColor = [UIColor clearColor];
        _selfAvatarImageView.layer.cornerRadius = 20.0f;
        _selfAvatarImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_selfAvatarImageView];
        
        //消息背景
        _messageBackImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(_otherAvatarImageView.frame.origin.x + _otherAvatarImageView.frame.size.width + 15, _otherAvatarImageView.frame.origin.y, 170, 40)] autorelease];
        _messageBackImageView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_messageBackImageView];
        
        //消息文字内容
        _contentLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 10, _messageBackImageView.frame.size.width - 10 * 2, _messageBackImageView.frame.size.height - 10 * 2)] autorelease];
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.textColor = [UIColor colorWithRed:51.0 / 255.0 green:51.0 / 255.0 blue:51.0 / 255.0 alpha:1.0];
        _contentLabel.font = [UIFont systemFontOfSize:14.0f];
        _contentLabel.numberOfLines = 0;
        [_messageBackImageView addSubview:_contentLabel];
        
        //消息图片内容
        _contentImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, _messageBackImageView.frame.size.width - 10 * 2, _messageBackImageView.frame.size.height - 10 * 2)] autorelease];
        [_messageBackImageView addSubview:_contentImageView];
        
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
    
    //需要对消息类型进行判断
    if([(EMTextMessageBody *)message.messageBodies.lastObject messageBodyType]==eMessageBodyType_Text){
        
        //文本消息
        _contentLabel.hidden = NO;
        _contentImageView.hidden = YES;
        
        //文本
        CGSize textSize = [LPUtility getTextHeightWithText:[(EMTextMessageBody *)message.messageBodies.lastObject text] font:_contentLabel.font size:CGSizeMake(150, 2000)];
        
        if([message.from isEqualToString:_user.emUsername])
        {
            _otherAvatarImageView.hidden = NO;
            [_otherAvatarImageView setImageWithURL:[NSURL URLWithString:[LPUtility getQiniuImageURLStringWithBaseString:_user.userIcon.imageURL imageSize:CGSizeMake(80, 80)]]];
            
            _messageBackImageView.frame = CGRectMake(_otherAvatarImageView.frame.origin.x + _otherAvatarImageView.frame.size.width + 15, _otherAvatarImageView.frame.origin.y, textSize.width + 10 * 2, textSize.height + 10 * 2);
        }
        else
        {
            _selfAvatarImageView.hidden = NO;
            [_selfAvatarImageView setImageWithURL:[NSURL URLWithString:[LPUtility getQiniuImageURLStringWithBaseString:[[[User sharedUser] userIcon] imageURL] imageSize:CGSizeMake(80, 80)]]];
            
            _messageBackImageView.frame = CGRectMake(_selfAvatarImageView.frame.origin.x - textSize.width - 10 * 2 - 15, _selfAvatarImageView.frame.origin.y, textSize.width + 10 * 2, textSize.height + 10 * 2);
        }
        _contentLabel.frame = CGRectMake(10, 10, textSize.width, textSize.height);
        _contentLabel.text = [(EMTextMessageBody *)message.messageBodies.lastObject text];
    }else if([(EMTextMessageBody *)message.messageBodies.lastObject messageBodyType]==eMessageBodyType_Image){
        
        //图片消息
        _contentLabel.hidden = YES;
        _contentImageView.hidden = NO;
        
        //预览图片尺寸
        CGSize imageSize = [(EMImageMessageBody *)message.messageBodies.lastObject thumbnailSize];
        
        if([message.from isEqualToString:_user.emUsername])
        {
            _otherAvatarImageView.hidden = NO;
            [_otherAvatarImageView setImageWithURL:[NSURL URLWithString:[LPUtility getQiniuImageURLStringWithBaseString:_user.userIcon.imageURL imageSize:CGSizeMake(80, 80)]]];
            
            _messageBackImageView.frame = CGRectMake(_otherAvatarImageView.frame.origin.x + _otherAvatarImageView.frame.size.width + 15, _otherAvatarImageView.frame.origin.y, imageSize.width + 10 * 2, imageSize.height + 10 * 2);
        }
        else
        {
            _selfAvatarImageView.hidden = NO;
            [_selfAvatarImageView setImageWithURL:[NSURL URLWithString:[LPUtility getQiniuImageURLStringWithBaseString:[[[User sharedUser] userIcon] imageURL] imageSize:CGSizeMake(80, 80)]]];
            
            _messageBackImageView.frame = CGRectMake(_selfAvatarImageView.frame.origin.x - imageSize.width - 10 * 2 - 15, _selfAvatarImageView.frame.origin.y, imageSize.width + 10 * 2, imageSize.height + 10 * 2);
        }
        
        _contentImageView.frame = CGRectMake(10, 10, imageSize.width, imageSize.height);
        
        //预览图
        EMChatImage *thumbnailImage = [(EMImageMessageBody *)message.messageBodies.lastObject thumbnailImage];
        _contentImageView.image = [UIImage imageWithContentsOfFile:thumbnailImage.localPath];
        
    }else{
        //其他类型
        
        
    }
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
