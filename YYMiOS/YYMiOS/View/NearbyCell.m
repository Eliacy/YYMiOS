//
//  NearbyCell.m
//  YYMiOS
//
//  Created by lide on 14-9-24.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "NearbyCell.h"
#import "Function.h"

@implementation NearbyCell

@synthesize poi = _poi;
@synthesize keywordImageView = _keywordImageView;

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
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_avatarImageView.frame.origin.x + _avatarImageView.frame.size.width + 10, _avatarImageView.frame.origin.y, self.contentView.frame.size.width - _avatarImageView.frame.origin.x - _avatarImageView.frame.size.width - 30, 15)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor darkGrayColor];
        _titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [_backView addSubview:_titleLabel];
        
        _levelLabel = [[UILabel alloc] initWithFrame:CGRectMake(_backView.frame.size.width - 8 - 15, 8, 15, 15)];
        _levelLabel.backgroundColor = [UIColor clearColor];
        _levelLabel.textColor = [UIColor whiteColor];
        _levelLabel.font = [UIFont systemFontOfSize:12.0f];
        _levelLabel.textAlignment = NSTextAlignmentCenter;
        
        _levelImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_levelLabel.frame.origin.x, _levelLabel.frame.origin.y + (_levelLabel.frame.size.height - 15) / 3, _levelLabel.frame.size.width, 15)];
        _levelImageView.backgroundColor = [UIColor clearColor];
        [_backView addSubview:_levelImageView];
        [_backView addSubview:_levelLabel];
        
        _starView = [[StarView alloc] initWithFrame:CGRectMake(_titleLabel.frame.origin.x, _titleLabel.frame.origin.y + _titleLabel.frame.size.height + 15, 70, 10)];
        _starView.backgroundColor = [UIColor clearColor];
        [_backView addSubview:_starView];
        
        _reviewButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        _reviewButton.frame = CGRectMake(_starView.frame.origin.x + _starView.frame.size.width + 10, _starView.frame.origin.y, 60, 12);
        [_reviewButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_reviewButton setImage:[UIImage imageNamed:@"talk_gray.png"] forState:UIControlStateNormal];
        [_reviewButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
        _reviewButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        _reviewButton.userInteractionEnabled = NO;
        [_backView addSubview:_reviewButton];
        
        _distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_reviewButton.frame.origin.x + _reviewButton.frame.size.width, _reviewButton.frame.origin.y - 1, _backView.frame.size.width - _reviewButton.frame.origin.x - _reviewButton.frame.size.width - 8, _reviewButton.frame.size.height)];
        _distanceLabel.backgroundColor = [UIColor clearColor];
        _distanceLabel.textColor = [UIColor lightGrayColor];
        _distanceLabel.font = [UIFont systemFontOfSize:12.0f];
        _distanceLabel.textAlignment = NSTextAlignmentRight;
        [_backView addSubview:_distanceLabel];
        
        _locationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_starView.frame.origin.x, _avatarImageView.frame.origin.y + _avatarImageView.frame.size.height - 12, 8, 12)];
        _locationImageView.backgroundColor = [UIColor clearColor];
        _locationImageView.image = [UIImage imageNamed:@"location.png"];
        [_backView addSubview:_locationImageView];
        
        _locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(_locationImageView.frame.origin.x + _locationImageView.frame.size.width + 5, _locationImageView.frame.origin.y, _backView.frame.size.width - _locationImageView.frame.origin.x - _locationImageView.frame.size.width - 64, _locationImageView.frame.size.height)];
        _locationLabel.backgroundColor = [UIColor clearColor];
        _locationLabel.textColor = [UIColor darkGrayColor];
        _locationLabel.font = [UIFont systemFontOfSize:13.0f];
        [_backView addSubview:_locationLabel];
        
        _keywordLabel = [[UILabel alloc] initWithFrame:CGRectMake(_locationLabel.frame.origin.x + _locationLabel.frame.size.width + 8, _locationLabel.frame.origin.y, 48, _locationLabel.frame.size.height)];
        _keywordLabel.backgroundColor = [UIColor clearColor];
        _keywordLabel.textColor = [UIColor whiteColor];
        _keywordLabel.font = [UIFont systemFontOfSize:10.0f];
        _keywordLabel.textAlignment = NSTextAlignmentCenter;
        
        _keywordImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_keywordLabel.frame.origin.x, _keywordLabel.frame.origin.y + (_keywordLabel.frame.size.height - 14) / 3, _keywordLabel.frame.size.width, 14)];
        _keywordImageView.backgroundColor = [UIColor clearColor];
        [_backView addSubview:_keywordImageView];
        [_backView addSubview:_keywordLabel];
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _avatarImageView.frame.origin.y + _avatarImageView.frame.size.height, self.contentView.frame.size.width, _backView.frame.size.height - _avatarImageView.frame.origin.y - _avatarImageView.frame.size.height)];
        _scrollView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_scrollView];
    }
    
    return self;
}


- (void)setPoi:(POI *)poi
{
    if(_poi != nil)
    {
        LP_SAFE_RELEASE(_poi);
    }
    _poi = [poi retain];
    
    _titleLabel.text = poi.name;
    
    if(poi.level)
    {
        CGSize size = [LPUtility getTextHeightWithText:poi.level font:_levelLabel.font size:CGSizeMake(200, 20)];
        _levelLabel.frame = CGRectMake(_backView.frame.size.width - 8 - size.width - 5, _levelLabel.frame.origin.y, size.width + 5, _levelLabel.frame.size.height);
        _levelImageView.frame = CGRectMake(_levelLabel.frame.origin.x, _levelLabel.frame.origin.y + (_levelLabel.frame.size.height - 15) / 3, _levelLabel.frame.size.width, 15);
        _levelImageView.image = [UIImage imageNamed:@"rank.png"];
        _levelLabel.text = poi.level;
    }
    else
    {
        _levelLabel.text = @"";
    }
    
    _titleLabel.frame = CGRectMake(_titleLabel.frame.origin.x, _titleLabel.frame.origin.y, self.contentView.frame.size.width - _avatarImageView.frame.origin.x - _avatarImageView.frame.size.width - 15 - _levelImageView.frame.size.width, _titleLabel.frame.size.height);
    
    [_avatarImageView setImageWithURL:[NSURL URLWithString:[LPUtility getQiniuImageURLStringWithBaseString:poi.logo.imageURL imageSize:CGSizeMake(150, 150)]]];
    [_starView setStars:poi.stars];
    [_reviewButton setTitle:[NSString stringWithFormat:@"%i", (int)poi.reviewNum] forState:UIControlStateNormal];
    _locationLabel.text = poi.address;
    
    if(poi.keywordArray && [poi.keywordArray isKindOfClass:[NSArray class]] && [poi.keywordArray count] > 0)
    {
        CGSize size = [LPUtility getTextHeightWithText:[poi.keywordArray objectAtIndex:0] font:_keywordLabel.font size:CGSizeMake(200, 20)];
        _keywordLabel.frame = CGRectMake(_backView.frame.size.width - 8 - size.width - 5, _keywordLabel.frame.origin.y, size.width + 5, _keywordLabel.frame.size.height);
        _keywordImageView.frame = CGRectMake(_keywordLabel.frame.origin.x, _keywordLabel.frame.origin.y + (_keywordLabel.frame.size.height - 14) / 3, _keywordLabel.frame.size.width, 14);
        _locationLabel.frame = CGRectMake(_locationImageView.frame.origin.x + _locationImageView.frame.size.width + 5, _locationImageView.frame.origin.y, _backView.frame.size.width - _locationImageView.frame.origin.x - _locationImageView.frame.size.width - 16 - size.width - 5, _locationImageView.frame.size.height);
        _keywordLabel.text = [poi.keywordArray objectAtIndex:0];
    }
    else
    {
        _keywordLabel.text = @"";
        _locationLabel.frame = CGRectMake(_locationImageView.frame.origin.x + _locationImageView.frame.size.width + 5, _locationImageView.frame.origin.y, _backView.frame.size.width - _locationImageView.frame.origin.x - _locationImageView.frame.size.width - 8, _locationImageView.frame.size.height);
    }
    
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
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.masksToBounds = YES;
        [imageView setImageWithURL:[NSURL URLWithString:[LPUtility getQiniuImageURLStringWithBaseString:[[poi.topImageArray objectAtIndex:i] imageURL] imageSize:CGSizeMake(100, 100)]]];
        [_scrollView addSubview:imageView];
    }
}

#pragma mark - 计算距离
- (void)setDistanceLabelWithLocation1Lat:(double)location1Lat Location1Lon:(double)location1Lon Location2Lat:(double)location2Lat Location2Lon:(double)location2Lon
{
    if(location1Lat==0){
        _distanceLabel.text = @"";
    }else{
        float distance = [[NSString stringWithFormat:@"%.1f",[Function getDistanceFromLocation1Lat:location1Lat Location1Lon:location1Lon Location2Lat:location2Lat Location2Lon:location2Lon]] floatValue];
        if(distance>100){
            _distanceLabel.text = @"100公里以上";
        }else{
            _distanceLabel.text = [NSString stringWithFormat:@"%f公里",distance];
        }
    }
}
@end
