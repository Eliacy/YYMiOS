//
//  DealDetailExtView.m
//  YYMiOS
//
//  Created by Lide on 14/12/13.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "DealDetailExtView.h"

#define kKeywordImageViewTag 15412

@implementation DealDetailExtView

@synthesize deal = _deal;
@synthesize delegate = _delegate;

#pragma mark - private

- (void)clickLikeButton:(id)sender
{
    if(_delegate && [_delegate respondsToSelector:@selector(dealDetailExtViewDidClickLikeButton:)])
    {
        [_delegate dealDetailExtViewDidClickLikeButton:self];
    }
}

#pragma mark - super

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self != nil)
    {
        _keywordLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, frame.size.width - 15 * 2, 20)];
        _keywordLabel.backgroundColor = [UIColor clearColor];
        _keywordLabel.textColor = [UIColor colorWithRed:51.0 / 255.0 green:51.0 / 255.0 blue:51.0 / 255.0 alpha:1.0];
        _keywordLabel.font = [UIFont systemFontOfSize:13.0f];
        _keywordLabel.text = @"关键词：";
        [self addSubview:_keywordLabel];
        
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_keywordLabel.frame.origin.x, _keywordLabel.frame.origin.y + _keywordLabel.frame.size.height, _keywordLabel.frame.size.width, 20)];
        _priceLabel.backgroundColor = [UIColor clearColor];
        _priceLabel.textColor = [UIColor colorWithRed:51.0 / 255.0  green:51.0 / 255.0 blue:51.0 / 255.0 alpha:1.0];
        _priceLabel.font = [UIFont systemFontOfSize:12.0f];
        _priceLabel.text = @"总价：";
        [self addSubview:_priceLabel];
        
        _likeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(15, _priceLabel.frame.origin.y + _priceLabel.frame.size.height + 5, 12, 10)];
        _likeIcon.backgroundColor = [UIColor clearColor];
        _likeIcon.contentMode = UIViewContentModeScaleAspectFit;
        _likeIcon.layer.masksToBounds = YES;
        _likeIcon.image = [UIImage imageNamed:@"deal_detail_like.png"];
        [self addSubview:_likeIcon];
        
        _likeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_likeIcon.frame.origin.x + _likeIcon.frame.size.width + 2, _likeIcon.frame.origin.y, 40, _likeIcon.frame.size.height)];
        _likeLabel.backgroundColor = [UIColor clearColor];
        _likeLabel.textColor = [UIColor colorWithRed:153.0 / 255.0 green:153.0 / 255.0 blue:153.0 / 255.0 alpha:1.0];
        _likeLabel.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:_likeLabel];
        
        _commentIcon = [[UIImageView alloc] initWithFrame:CGRectMake(_likeIcon.frame.origin.x + _likeIcon.frame.size.width + 40, _likeIcon.frame.origin.y, 12, 10)];
        _commentIcon.backgroundColor = [UIColor clearColor];
        _commentIcon.contentMode = UIViewContentModeScaleAspectFit;
        _commentIcon.layer.masksToBounds = YES;
        _commentIcon.image = [UIImage imageNamed:@"deal_detail_comment.png"];
        [self addSubview:_commentIcon];
        
        _commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(_commentIcon.frame.origin.x + _commentIcon.frame.size.width + 2, _commentIcon.frame.origin.y, 40, _commentIcon.frame.size.height)];
        _commentLabel.backgroundColor = [UIColor clearColor];
        _commentLabel.textColor = [UIColor colorWithRed:153.0 / 255.0 green:153.0 / 255.0 blue:153.0 / 255.0 alpha:1.0];
        _commentLabel.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:_commentLabel];
        
        _likeButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        _likeButton.frame = CGRectMake(_likeIcon.frame.origin.x, _likeIcon.frame.origin.y - 10, 40, 40);
        _likeButton.backgroundColor = [UIColor clearColor];
        [_likeButton addTarget:self action:@selector(clickLikeButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_likeButton];
        
        _grayView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - 10, frame.size.width, 10)];
        _grayView.backgroundColor = [UIColor colorWithRed:246.0 / 255.0 green:246.0 / 255.0 blue:246.0 / 255.0 alpha:1.0];
        [self addSubview:_grayView];
    }
    
    return self;
}

- (void)setDeal:(Deal *)deal
{
    if(_deal != nil)
    {
        LP_SAFE_RELEASE(_deal);
    }
    _deal = deal;
    
    for(UIView *view in self.subviews)
    {
        if(view.tag >= kKeywordImageViewTag)
        {
            [view removeFromSuperview];
        }
    }
    
    CGSize textSize = [LPUtility getTextHeightWithText:_keywordLabel.text
                                                  font:_keywordLabel.font
                                                  size:CGSizeMake(200, 100)];
    CGFloat offsetX = textSize.width + 15;
    CGFloat offsetY = 10;
    
    for(NSInteger i = 0; i < [deal.keywordArray count]; i++)
    {
        NSString *keyword = [deal.keywordArray objectAtIndex:i];
        CGSize keywordSize = [LPUtility getTextHeightWithText:keyword
                                                         font:[UIFont systemFontOfSize:10.0f]
                                                         size:CGSizeMake(200, 100)];
        if(offsetX + keywordSize.width + 5 + 10 > self.frame.size.width - 15)
        {
            offsetX = textSize.width + 15;
            offsetY += 25;
        }
        
        UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(offsetX, offsetY + 3, keywordSize.width + 5, 14)] autorelease];
        imageView.backgroundColor = [UIColor clearColor];
        imageView.image = [[UIImage imageNamed:[NSString stringWithFormat:@"%i.png", (int)(i % 6 + 1)]] stretchableImageWithLeftCapWidth:5 topCapHeight:0];
        imageView.tag = kKeywordImageViewTag + i;
        [self addSubview:imageView];
        
        UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 1, imageView.frame.size.width, 12)] autorelease];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:10.0f];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = keyword;
        [imageView addSubview:label];
        
        offsetX += keywordSize.width + 5 + 10;
    }
    
    _priceLabel.text = [NSString stringWithFormat:@"总价：%i%@", deal.total, deal.currency];
    
    if(deal.liked)
    {
        _likeIcon.image = [UIImage imageNamed:@"deal_detail_like.png"];
    }
    else
    {
        _likeIcon.image = [UIImage imageNamed:@"deal_detail_unlike.png"];
    }
    
    _likeLabel.text = [NSString stringWithFormat:@"%i", (int)deal.likeCount];
    _commentLabel.text = [NSString stringWithFormat:@"%i", (int)deal.commentCount];
}

- (void)refresh
{
    if(_deal.liked)
    {
        _likeIcon.image = [UIImage imageNamed:@"deal_detail_like.png"];
    }
    else
    {
        _likeIcon.image = [UIImage imageNamed:@"deal_detail_unlike.png"];
    }
    
    _likeLabel.text = [NSString stringWithFormat:@"%i", (int)_deal.likeCount];
}

@end
