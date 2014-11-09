//
//  NearbyCell.m
//  YYMiOS
//
//  Created by lide on 14-9-24.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "NearbyCell.h"

@implementation NearbyCell

@synthesize poi = _poi;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self != nil)
    {
        self.backgroundColor = [UIColor clearColor];
        
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 145)];
        _backView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_backView];
        
        _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 60, 60)];
        _avatarImageView.backgroundColor = [UIColor clearColor];
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        _avatarImageView.layer.masksToBounds = YES;
        [_backView addSubview:_avatarImageView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_avatarImageView.frame.origin.x + _avatarImageView.frame.size.width + 10, _avatarImageView.frame.origin.y, 230, 15)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor darkGrayColor];
        _titleLabel.font = [UIFont systemFontOfSize:15.0f];
        _titleLabel.text = @"利贝尔王国";
        [_backView addSubview:_titleLabel];
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _avatarImageView.frame.origin.y + _avatarImageView.frame.size.height, self.contentView.frame.size.width, _backView.frame.size.height - _avatarImageView.frame.origin.y - _avatarImageView.frame.size.height)];
        _scrollView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_scrollView];
    }
    
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setPoi:(POI *)poi
{
    if(_poi != nil)
    {
        LP_SAFE_RELEASE(_poi);
    }
    _poi = [poi retain];
    
    _titleLabel.text = poi.name;
    
    [_avatarImageView setImageWithURL:[NSURL URLWithString:[LPUtility getQiniuImageURLStringWithBaseString:poi.logo.imageURL imageSize:CGSizeMake(100, 100)]]];
    
    for(UIView *view in _scrollView.subviews)
    {
        [view removeFromSuperview];
    }
    
    _scrollView.contentSize = CGSizeMake([poi.topImageArray count] * 80, _scrollView.frame.size.height);
    for(NSInteger i = 0; i < [poi.topImageArray count]; i++)
    {
        UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(5 + i * 80, 5, 70, 70)] autorelease];
        imageView.layer.borderWidth = 0.5;
        imageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [imageView setImageWithURL:[NSURL URLWithString:[LPUtility getQiniuImageURLStringWithBaseString:[[poi.topImageArray objectAtIndex:i] imageURL] imageSize:CGSizeMake(100, 100)]]];
        [_scrollView addSubview:imageView];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
