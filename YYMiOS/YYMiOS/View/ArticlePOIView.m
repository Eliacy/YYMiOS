//
//  ArticlePOIView.m
//  YYMiOS
//
//  Created by Lide on 14/11/17.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "ArticlePOIView.h"

@implementation ArticlePOIView

@synthesize poiId = _poiId;
@synthesize poi = _poi;
@synthesize delegate = _delegate;

@synthesize keywordImageView = _keywordImageView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 88)];
        _backView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_backView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(oneFingerTap:)];
        [_backView addGestureRecognizer:tap];
        [tap release];
        
        _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 68, 68)];
        _avatarImageView.backgroundColor = [UIColor clearColor];
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.layer.cornerRadius = 7;
        [_backView addSubview:_avatarImageView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_avatarImageView.frame.origin.x + _avatarImageView.frame.size.width + 10, _avatarImageView.frame.origin.y, 230, 15)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor darkGrayColor];
        _titleLabel.font = [UIFont systemFontOfSize:14.0f];
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
        _reviewButton.userInteractionEnabled = NO;
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
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setPoiId:(NSInteger)poiId
{
    _poiId = poiId;
    
    [POI getPOIListWithPOIId:poiId
                       brief:1
                      offset:0
                       limit:0
                     keyword:@""
                        area:0
                        city:0
                       range:-1
                    category:0
                       order:0
                   longitude:0
                    latitude:0
                     success:^(NSArray *array) {
                         
                         if([array count] > 0)
                         {
                             self.poi = [array objectAtIndex:0];
                             
                             if(_poi.keywordArray && [_poi.keywordArray isKindOfClass:[NSArray class]] && [_poi.keywordArray count] > 0)
                             {
                                 self.keywordImageView.image = [[UIImage imageNamed:[NSString stringWithFormat:@"%i.png", (int)arc4random() % 6 + 1]] stretchableImageWithLeftCapWidth:5 topCapHeight:0];
                             }
                             else
                             {
                                 self.keywordImageView.image = nil;
                             }
                         }
                         
                     } failure:^(NSError *error) {
                         
                     }];
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
        _levelImageView.frame = CGRectMake(self.frame.size.width - 8 - 15, _levelImageView.frame.origin.y, 15, 15);
        _levelImageView.image = [UIImage imageNamed:@"rank_S.png"];
    }
    else if(poi.level && [poi.level isEqualToString:@"SS"])
    {
        _levelImageView.frame = CGRectMake(self.frame.size.width - 8 - 31, _levelImageView.frame.origin.y, 31, 15);
        _levelImageView.image = [UIImage imageNamed:@"rank_SS.png"];
    }
    else if(poi.level && [poi.level isEqualToString:@"A+"])
    {
        _levelImageView.frame = CGRectMake(self.frame.size.width - 8 - 31, _levelImageView.frame.origin.y, 31, 15);
        _levelImageView.image = [UIImage imageNamed:@"rank_A+.png"];
    }
    else
    {
        _levelImageView.image = nil;
    }
    
    
    _titleLabel.frame = CGRectMake(_titleLabel.frame.origin.x, _titleLabel.frame.origin.y, _backView.frame.size.width - _avatarImageView.frame.origin.x - _avatarImageView.frame.size.width - 15 - _levelImageView.frame.size.width, _titleLabel.frame.size.height);
    
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
}

#pragma mark - UIGestureRecognizer

- (void)oneFingerTap:(UITapGestureRecognizer *)gestureRecognizer
{
    if(gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        if(_delegate && [_delegate respondsToSelector:@selector(articlePOIViewDidTap:)])
        {
            [_delegate articlePOIViewDidTap:self];
        }
    }
}

@end
