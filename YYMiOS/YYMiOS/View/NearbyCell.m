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
        
        _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 68, 68)];
        _avatarImageView.backgroundColor = [UIColor clearColor];
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.layer.cornerRadius = 7;
        [_backView addSubview:_avatarImageView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_avatarImageView.frame.origin.x + _avatarImageView.frame.size.width + 10, _avatarImageView.frame.origin.y, 230, 15)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor darkGrayColor];
        _titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [_backView addSubview:_titleLabel];
        
        _levelImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_backView.frame.size.width - 8 - 15, 8, 15, 15)];
        _levelImageView.backgroundColor = [UIColor clearColor];
        [_backView addSubview:_levelImageView];
        
        _starView = [[StarView alloc] initWithFrame:CGRectMake(_titleLabel.frame.origin.x, _titleLabel.frame.origin.y + _titleLabel.frame.size.height + 15, 70, 10)];
        _starView.backgroundColor = [UIColor clearColor];
        [_backView addSubview:_starView];
        
        _reviewButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        _reviewButton.frame = CGRectMake(_starView.frame.origin.x + _starView.frame.size.width + 10, _starView.frame.origin.y, 100, 12);
        [_reviewButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_reviewButton setImage:[UIImage imageNamed:@"talk_gray.png"] forState:UIControlStateNormal];
        [_reviewButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
        _reviewButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [_backView addSubview:_reviewButton];
        
        _distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_reviewButton.frame.origin.x + _reviewButton.frame.size.width, _reviewButton.frame.origin.y - 1, _backView.frame.size.width - _reviewButton.frame.origin.x - _reviewButton.frame.size.width - 8, _reviewButton.frame.size.height)];
        _distanceLabel.backgroundColor = [UIColor clearColor];
        _distanceLabel.textColor = [UIColor lightGrayColor];
        _distanceLabel.font = [UIFont systemFontOfSize:12.0f];
        _distanceLabel.textAlignment = NSTextAlignmentRight;
        _distanceLabel.text = @"2.5km";
        [_backView addSubview:_distanceLabel];
        
        _locationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_starView.frame.origin.x, _avatarImageView.frame.origin.y + _avatarImageView.frame.size.height - 12, 8, 12)];
        _locationImageView.backgroundColor = [UIColor clearColor];
        _locationImageView.image = [UIImage imageNamed:@"location.png"];
        [_backView addSubview:_locationImageView];
        
        _locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(_locationImageView.frame.origin.x + _locationImageView.frame.size.width + 5, _locationImageView.frame.origin.y, _backView.frame.size.width - _locationImageView.frame.origin.x - _locationImageView.frame.size.width - 8, _locationImageView.frame.size.height)];
        _locationLabel.backgroundColor = [UIColor clearColor];
        _locationLabel.textColor = [UIColor darkGrayColor];
        _locationLabel.font = [UIFont systemFontOfSize:13.0f];
        [_backView addSubview:_locationLabel];
        
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
    
    if(poi.level && [poi.level isEqualToString:@"S"])
    {
        _levelImageView.frame = CGRectMake(self.contentView.frame.size.width - 8 - 15, _levelImageView.frame.origin.y, 15, 15);
        _levelImageView.image = [UIImage imageNamed:@"rank_S.png"];
    }
    else if(poi.level && [poi.level isEqualToString:@"SS"])
    {
        _levelImageView.frame = CGRectMake(self.contentView.frame.size.width - 8 - 31, _levelImageView.frame.origin.y, 31, 15);
        _levelImageView.image = [UIImage imageNamed:@"rank_SS.png"];
    }
    else if(poi.level && [poi.level isEqualToString:@"A+"])
    {
        _levelImageView.frame = CGRectMake(self.contentView.frame.size.width - 8 - 31, _levelImageView.frame.origin.y, 31, 15);
        _levelImageView.image = [UIImage imageNamed:@"rank_A+.png"];
    }
    else
    {
        _levelImageView.image = nil;
    }
    
    [_avatarImageView setImageWithURL:[NSURL URLWithString:[LPUtility getQiniuImageURLStringWithBaseString:poi.logo.imageURL imageSize:CGSizeMake(100, 100)]]];
    [_starView setStars:poi.stars];
    [_reviewButton setTitle:[NSString stringWithFormat:@"%i", (int)poi.reviewNum] forState:UIControlStateNormal];
    _locationLabel.text = poi.address;
    
    for(UIView *view in _scrollView.subviews)
    {
        [view removeFromSuperview];
    }
    
    _scrollView.contentSize = CGSizeMake([poi.topImageArray count] * 64, _scrollView.frame.size.height);
    for(NSInteger i = 0; i < [poi.topImageArray count]; i++)
    {
        UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(8 + i * 64, 10, 48, 48)] autorelease];
        imageView.layer.borderWidth = 0.5;
        imageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [imageView setImageWithURL:[NSURL URLWithString:[LPUtility getQiniuImageURLStringWithBaseString:[[poi.topImageArray objectAtIndex:i] imageURL] imageSize:CGSizeMake(60, 60)]]];
        [_scrollView addSubview:imageView];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
