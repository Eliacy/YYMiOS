//
//  DynamicCell.m
//  YYMiOS
//
//  Created by lide on 14-9-22.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "DynamicCell.h"

@implementation DynamicCell

@synthesize deal = _deal;

#pragma mark - private

- (void)clickFollowButton:(id)sender
{

}

- (void)clickShareButton:(id)sender
{

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
        [self.contentView addSubview:_backImageView];
        
        _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 60, 60)];
        _avatarImageView.backgroundColor = [UIColor clearColor];
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        _avatarImageView.layer.masksToBounds = YES;
        [_backImageView addSubview:_avatarImageView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_avatarImageView.frame.origin.x + _avatarImageView.frame.size.width + 10, _avatarImageView.frame.origin.y, 130, 20)];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textColor = [UIColor darkGrayColor];
        _nameLabel.font = [UIFont systemFontOfSize:16.0f];
        [_backImageView addSubview:_nameLabel];
        
        _lastTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.frame.origin.x, _nameLabel.frame.origin.y + _nameLabel.frame.size.height, _nameLabel.frame.size.width, _nameLabel.frame.size.height)];
        _lastTimeLabel.backgroundColor = [UIColor clearColor];
        _lastTimeLabel.textColor = [UIColor grayColor];
        _lastTimeLabel.font = [UIFont systemFontOfSize:13.0f];
        [_backImageView addSubview:_lastTimeLabel];
        
        _followButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        _followButton.frame = CGRectMake(320 - 15 - 60, 15, 60, 30);
        _followButton.backgroundColor = [UIColor clearColor];
        [_followButton setTitle:@"+关注" forState:UIControlStateNormal];
        [_followButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _followButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        _followButton.layer.borderWidth = 1.0;
        _followButton.layer.borderColor = [[UIColor grayColor] CGColor];
        [_followButton addTarget:self action:@selector(clickFollowButton:) forControlEvents:UIControlEventTouchUpInside];
        [_backImageView addSubview:_followButton];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, _avatarImageView.frame.origin.y + _avatarImageView.frame.size.height + 5, 290, 35)];
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.textColor = [UIColor darkGrayColor];
        _contentLabel.font = [UIFont systemFontOfSize:14.0f];
        _contentLabel.numberOfLines = 0;
        _contentLabel.text = @"本作是法庭辩论AVG《逆转裁判》系列的最新一作，主题围绕法庭的黑暗时代展开的，久违的成步堂律师将再次站上辩护席，为大家带来精彩的法庭辩护，下面由ACG字幕组和巴士联合为玩家带来《逆转裁判5》全中文流程视频。我们会在近期更新完毕，玩家们敬请期待。";
        [_backImageView addSubview:_contentLabel];
        
        _goodsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_contentLabel.frame.origin.x, _contentLabel.frame.origin.y + _contentLabel.frame.size.height + 5, 290, 250)];
        _goodsImageView.backgroundColor = [UIColor clearColor];
        _goodsImageView.contentMode = UIViewContentModeScaleAspectFill;
        _goodsImageView.layer.masksToBounds = YES;
        [_backImageView addSubview:_goodsImageView];
        
        _floatView = [[UIView alloc] initWithFrame:CGRectMake(0, _goodsImageView.frame.size.height - 25, _goodsImageView.frame.size.width, 25)];
        _floatView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        [_goodsImageView addSubview:_floatView];
        
        _likeLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 50, _floatView.frame.size.height)];
        _likeLabel.backgroundColor = [UIColor clearColor];
        _likeLabel.textColor = [UIColor whiteColor];
        _likeLabel.font = [UIFont systemFontOfSize:12.0f];
        _likeLabel.text = @"赞7";
        [_floatView addSubview:_likeLabel];
        
        _commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(_likeLabel.frame.origin.x + _likeLabel.frame.size.width, 0, 50, _floatView.frame.size.height)];
        _commentLabel.backgroundColor = [UIColor clearColor];
        _commentLabel.textColor = [UIColor whiteColor];
        _commentLabel.font = [UIFont systemFontOfSize:12.0f];
        _commentLabel.text = @"评论3";
        [_floatView addSubview:_commentLabel];
        
        _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(_floatView.frame.size.width - 55, 0, 50, _floatView.frame.size.height)];
        _numberLabel.backgroundColor = [UIColor clearColor];
        _numberLabel.textColor = [UIColor whiteColor];
        _numberLabel.font = [UIFont systemFontOfSize:12.0f];
        _numberLabel.textAlignment = NSTextAlignmentRight;
        [_floatView addSubview:_numberLabel];
        
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_goodsImageView.frame.origin.x, _goodsImageView.frame.origin.y + _goodsImageView.frame.size.height + 10, 290, 15)];
        _priceLabel.backgroundColor = [UIColor clearColor];
        _priceLabel.textColor = [UIColor grayColor];
        _priceLabel.font = [UIFont systemFontOfSize:13.0f];
        _priceLabel.text = @"3000美元";
        [_backImageView addSubview:_priceLabel];
        
        _locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(_priceLabel.frame.origin.x, _priceLabel.frame.origin.y + _priceLabel.frame.size.height + 10, 290, 15)];
        _locationLabel.backgroundColor = [UIColor clearColor];
        _locationLabel.textColor = [UIColor grayColor];
        _locationLabel.font = [UIFont systemFontOfSize:13.0f];
        _locationLabel.text = @"纽约，二马仕第五大道酒店";
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
    _lastTimeLabel.text = deal.updateTime;
    _contentLabel.text = deal.content;
    
    if(deal.imageArray && [deal.imageArray isKindOfClass:[NSArray class]] && [deal.imageArray count] > 0)
    {
        [_goodsImageView setImageWithURL:[NSURL URLWithString:[LPUtility getQiniuImageURLStringWithBaseString:[[deal.imageArray objectAtIndex:0] imageURL] imageSize:CGSizeMake(580, 500)]]];
    }
    else
    {
        _goodsImageView.image = nil;
    }
    
    _numberLabel.text = [NSString stringWithFormat:@"%i张", (int)deal.imageCount];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
