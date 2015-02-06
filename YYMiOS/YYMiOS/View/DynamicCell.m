//
//  DynamicCell.m
//  YYMiOS
//
//  Created by lide on 14-9-22.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "DynamicCell.h"
#import "Function.h"

@implementation DynamicCell

@synthesize deal = _deal;
@synthesize delegate = _delegate;

#pragma mark - private

- (void)clickFollowButton:(id)sender
{
    if(_delegate && [_delegate respondsToSelector:@selector(dynamicCellDidClickFollowButton:)])
    {
        [_delegate dynamicCellDidClickFollowButton:self];
    }
}

- (void)clickShareButton:(id)sender
{
    if(_delegate && [_delegate respondsToSelector:@selector(dynamicCellDidClickShareButton:)])
    {
        [_delegate dynamicCellDidClickShareButton:self];
    }
}

- (void)clickLikeButton:(id)sender
{
    if(_delegate && [_delegate respondsToSelector:@selector(dynamicCellDidClickLikeButton:)])
    {
        [_delegate dynamicCellDidClickLikeButton:self];
    }
}

#pragma mark - super

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self != nil)
    {
        self.backgroundColor = [UIColor clearColor];
        
        _backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 435)];
        _backImageView.backgroundColor = [UIColor whiteColor];
        _backImageView.userInteractionEnabled = YES;
        [self.contentView addSubview:_backImageView];

        _backUserView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 90)];
        _backUserView.backgroundColor = [UIColor clearColor];
        _backUserView.userInteractionEnabled = YES;
        [_backImageView addSubview:_backUserView];
        
        _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 60, 60)];
        _avatarImageView.backgroundColor = [UIColor clearColor];
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.userInteractionEnabled = YES;
        _avatarImageView.layer.cornerRadius = 30.0;
        [_backUserView addSubview:_avatarImageView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_avatarImageView.frame.origin.x + _avatarImageView.frame.size.width + 10, _avatarImageView.frame.origin.y, 130, 20)];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textColor = [UIColor darkGrayColor];
        _nameLabel.font = [UIFont systemFontOfSize:16.0f];
        [_backUserView addSubview:_nameLabel];
        
        _lastTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.frame.origin.x, _nameLabel.frame.origin.y + _nameLabel.frame.size.height, _nameLabel.frame.size.width, _nameLabel.frame.size.height)];
        _lastTimeLabel.backgroundColor = [UIColor clearColor];
        _lastTimeLabel.textColor = [UIColor grayColor];
        _lastTimeLabel.font = [UIFont systemFontOfSize:13.0f];
        [_backUserView addSubview:_lastTimeLabel];
        
        _followButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        _followButton.frame = CGRectMake(320 - 15 - 60, 15, 60, 30);
        _followButton.backgroundColor = [UIColor clearColor];
        [_followButton setTitle:@"关注" forState:UIControlStateNormal];
        [_followButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _followButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        _followButton.layer.borderWidth = 1.0;
        _followButton.layer.borderColor = [[UIColor grayColor] CGColor];
        [_followButton addTarget:self action:@selector(clickFollowButton:) forControlEvents:UIControlEventTouchUpInside];
        [_backUserView addSubview:_followButton];
        
        UITapGestureRecognizer *oneFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAvatarImageView:)];
        [_avatarImageView addGestureRecognizer:oneFingerTap];
        [_backUserView addGestureRecognizer:oneFingerTap];
        [oneFingerTap release];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, _avatarImageView.frame.origin.y + _avatarImageView.frame.size.height + 5, 290, 35)];
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.textColor = [UIColor darkGrayColor];
        _contentLabel.font = [UIFont systemFontOfSize:14.0f];
        _contentLabel.numberOfLines = 0;
        _contentLabel.text = @"本作是法庭辩论AVG《逆转裁判》系列的最新一作，主题围绕法庭的黑暗时代展开的，久违的成步堂律师将再次站上辩护席，为大家带来精彩的法庭辩护，下面由ACG字幕组和巴士联合为玩家带来《逆转裁判5》全中文流程视频。我们会在近期更新完毕，玩家们敬请期待。";
        [_backImageView addSubview:_contentLabel];
        
        _goodsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_contentLabel.frame.origin.x, _contentLabel.frame.origin.y + _contentLabel.frame.size.height + 5, 290, 250)];
        _goodsImageView.backgroundColor = [UIColor clearColor];
        _goodsImageView.userInteractionEnabled = YES;
        _goodsImageView.contentMode = UIViewContentModeScaleAspectFill;
        _goodsImageView.layer.masksToBounds = YES;
        [_backImageView addSubview:_goodsImageView];
        
        _floatView = [[UIView alloc] initWithFrame:CGRectMake(0, _goodsImageView.frame.size.height - 25, _goodsImageView.frame.size.width, 25)];
        _floatView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        [_goodsImageView addSubview:_floatView];
        
//        _likeLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 50, _floatView.frame.size.height)];
//        _likeLabel.backgroundColor = [UIColor clearColor];
//        _likeLabel.textColor = [UIColor whiteColor];
//        _likeLabel.font = [UIFont systemFontOfSize:12.0f];
//        _likeLabel.text = @"赞7";
//        [_floatView addSubview:_likeLabel];
        
        _likeButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        _likeButton.frame = CGRectMake(5, 0, 50, _floatView.frame.size.height);
        _likeButton.backgroundColor = [UIColor clearColor];
        [_likeButton setTitleColor:[UIColor colorWithRed:233.0 / 255.0 green:233.0 / 255.0 blue:233.0 / 255.0 alpha:1.0] forState:UIControlStateNormal];
        _likeButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        _likeButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        [_likeButton setImage:[UIImage imageNamed:@"like_white.png"] forState:UIControlStateNormal];
        [_likeButton addTarget:self action:@selector(clickLikeButton:) forControlEvents:UIControlEventTouchUpInside];
        [_floatView addSubview:_likeButton];
        
//        _commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(_likeLabel.frame.origin.x + _likeLabel.frame.size.width, 0, 50, _floatView.frame.size.height)];
//        _commentLabel.backgroundColor = [UIColor clearColor];
//        _commentLabel.textColor = [UIColor whiteColor];
//        _commentLabel.font = [UIFont systemFontOfSize:12.0f];
//        _commentLabel.text = @"评论3";
//        [_floatView addSubview:_commentLabel];
        
        _commentButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        _commentButton.frame = CGRectMake(_likeButton.frame.origin.x + _likeButton.frame.size.width, 0, 50, _floatView.frame.size.height);
        _commentButton.backgroundColor = [UIColor clearColor];
        [_commentButton setTitleColor:[UIColor colorWithRed:233.0 / 255.0 green:233.0 / 255.0 blue:233.0 / 255.0 alpha:1.0] forState:UIControlStateNormal];
        _commentButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        _commentButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        [_commentButton setImage:[UIImage imageNamed:@"comment_white.png"] forState:UIControlStateNormal];
        [_floatView addSubview:_commentButton];
        
        _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(_floatView.frame.size.width - 55, 0, 50, _floatView.frame.size.height)];
        _numberLabel.backgroundColor = [UIColor clearColor];
        _numberLabel.textColor = [UIColor whiteColor];
        _numberLabel.font = [UIFont systemFontOfSize:12.0f];
        _numberLabel.textAlignment = NSTextAlignmentRight;
        [_floatView addSubview:_numberLabel];
        
        _priceIcon = [[UIImageView alloc] initWithFrame:CGRectMake(_goodsImageView.frame.origin.x, _goodsImageView.frame.origin.y + _goodsImageView.frame.size.height + 10, 13, 14)];
        _priceIcon.backgroundColor = [UIColor clearColor];
        _priceIcon.image = [UIImage imageNamed:@"dynamic_price.png"];
        [_backImageView addSubview:_priceIcon];
        
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_goodsImageView.frame.origin.x + _priceIcon.frame.size.width + 10, _goodsImageView.frame.origin.y + _goodsImageView.frame.size.height + 10, 290, 15)];
        _priceLabel.backgroundColor = [UIColor clearColor];
        _priceLabel.textColor = [UIColor grayColor];
        _priceLabel.font = [UIFont systemFontOfSize:13.0f];
        [_backImageView addSubview:_priceLabel];
        
        _locationIcon = [[UIImageView alloc] initWithFrame:CGRectMake(_priceIcon.frame.origin.x, _priceIcon.frame.origin.y + _priceIcon.frame.size.height + 10, 12, 16)];
        _locationIcon.backgroundColor = [UIColor clearColor];
        _locationIcon.image = [UIImage imageNamed:@"dynamic_location.png"];
        [_backImageView addSubview:_locationIcon];
        
        _locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(_priceLabel.frame.origin.x, _priceLabel.frame.origin.y + _priceLabel.frame.size.height + 10, 200, 15)];
        _locationLabel.backgroundColor = [UIColor clearColor];
        _locationLabel.textColor = [UIColor grayColor];
        _locationLabel.font = [UIFont systemFontOfSize:13.0f];
        [_backImageView addSubview:_locationLabel];
        
        _shareButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        _shareButton.frame = CGRectMake(320 - 15 - 60, _backImageView.frame.size.height - 45, 60, 30);
        _shareButton.backgroundColor = [UIColor clearColor];
        [_shareButton setTitle:@"分享" forState:UIControlStateNormal];
        [_shareButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _shareButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        _shareButton.layer.borderWidth = 1.0;
        _shareButton.layer.borderColor = [[UIColor grayColor] CGColor];
        [_shareButton addTarget:self action:@selector(clickShareButton:) forControlEvents:UIControlEventTouchUpInside];
        [_backImageView addSubview:_shareButton];
    }
    
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setDeal:(Deal *)deal
{
    if(_deal != nil)
    {
        LP_SAFE_RELEASE(_deal);
    }
    _deal = [deal retain];
    
    [_avatarImageView setImageWithURL:[NSURL URLWithString:[LPUtility getQiniuImageURLStringWithBaseString:deal.user.userIcon.imageURL imageSize:CGSizeMake(120, 120)]]];
    _nameLabel.text = deal.user.userName;
    _lastTimeLabel.text = [LPUtility friendlyStringFromDate:deal.updateTime];
    _contentLabel.text = deal.content;
    
    if(_deal.user.followed)
    {
        [_followButton setTitle:@"取消" forState:UIControlStateNormal];
    }
    else
    {
        [_followButton setTitle:@"关注" forState:UIControlStateNormal];
    }
    
    NSMutableArray *badges = [Function addBadgesWithArray:deal.user.badges
                                                  OffsetX:_lastTimeLabel.frame.origin.x
                                                  OffsetY:_lastTimeLabel.frame.origin.y + _lastTimeLabel.frame.size.height + 1
                                                    Width:_backImageView.frame.size.width
                              ];
    for (UIImageView *badge in badges)
    {
        [_backUserView addSubview:badge];
    }
    
    if(deal.imageArray && [deal.imageArray isKindOfClass:[NSArray class]] && [deal.imageArray count] > 0)
    {
        [_goodsImageView setImageWithURL:[NSURL URLWithString:[LPUtility getQiniuImageURLStringWithBaseString:[[deal.imageArray objectAtIndex:0] imageURL] imageSize:CGSizeMake(580, 500)]]];
    }
    else
    {
        _goodsImageView.image = nil;
    }
    
    CGSize size = [LPUtility getTextHeightWithText:[NSString stringWithFormat:@"%i", (int)deal.likeCount]
                                              font:[UIFont systemFontOfSize:12.0f]
                                              size:CGSizeMake(200, 100)];
    
    if(deal.liked)
    {
        [_likeButton setImage:[UIImage imageNamed:@"deal_detail_like.png"] forState:UIControlStateNormal];
    }
    else
    {
        [_likeButton setImage:[UIImage imageNamed:@"like_white.png"] forState:UIControlStateNormal];
    }
    
    _likeButton.frame = CGRectMake(_likeButton.frame.origin.x, _likeButton.frame.origin.y, size.width + 20, _likeButton.frame.size.height);
    [_likeButton setTitle:[NSString stringWithFormat:@"%i", (int)deal.likeCount] forState:UIControlStateNormal];
    [_commentButton setTitle:[NSString stringWithFormat:@"%i", (int)deal.commentCount] forState:UIControlStateNormal];
    _numberLabel.text = [NSString stringWithFormat:@"%i张", (int)deal.imageCount];
    
    _priceLabel.text = [NSString stringWithFormat:@"%i%@", (int)deal.total, deal.currency];
    _locationLabel.text = [deal.site siteName];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UIGestureRecognizer

- (void)tapAvatarImageView:(UITapGestureRecognizer *)gestureRecognizer
{
    if(gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        if(_delegate && [_delegate respondsToSelector:@selector(dynamicCellDidTapAvatarImageView:)])
        {
            [_delegate dynamicCellDidTapAvatarImageView:self];
        }
    }
}

@end
