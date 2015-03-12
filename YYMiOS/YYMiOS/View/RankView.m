//
//  RankView.m
//  YYMiOS
//
//  Created by Lide on 15/3/11.
//  Copyright (c) 2015年 Lide. All rights reserved.
//

#import "RankView.h"

@implementation RankView

@synthesize starCount = _starCount;
@synthesize delegate = _delegate;

#pragma mark - private

- (void)clickStar1:(id)sender
{
    if(_starCount > 1)
    {
        _starCount = 1;
        _star1.selected = YES;
        _star2.selected = NO;
        _star3.selected = NO;
        _star4.selected = NO;
        _star5.selected = NO;

    }
    else
    {
        _star1.selected = !_star1.isSelected;
        if(_star1.isSelected)
        {
            _starCount = 1;
        }
        else
        {
            _starCount = 0;
            _star2.selected = NO;
            _star3.selected = NO;
            _star4.selected = NO;
            _star5.selected = NO;
        }
    }
    
    if(_star1.isSelected)
    {
        [_star1 setBackgroundImage:[UIImage imageNamed:@"star_show.png"] forState:UIControlStateNormal];
    }
    else
    {
        [_star1 setBackgroundImage:[UIImage imageNamed:@"star_hide.png"] forState:UIControlStateNormal];
    }
    if(_star2.isSelected)
    {
        [_star2 setBackgroundImage:[UIImage imageNamed:@"star_show.png"] forState:UIControlStateNormal];
    }
    else
    {
        [_star2 setBackgroundImage:[UIImage imageNamed:@"star_hide.png"] forState:UIControlStateNormal];
    }
    if(_star3.isSelected)
    {
        [_star3 setBackgroundImage:[UIImage imageNamed:@"star_show.png"] forState:UIControlStateNormal];
    }
    else
    {
        [_star3 setBackgroundImage:[UIImage imageNamed:@"star_hide.png"] forState:UIControlStateNormal];
    }
    if(_star4.isSelected)
    {
        [_star4 setBackgroundImage:[UIImage imageNamed:@"star_show.png"] forState:UIControlStateNormal];
    }
    else
    {
        [_star4 setBackgroundImage:[UIImage imageNamed:@"star_hide.png"] forState:UIControlStateNormal];
    }
    if(_star5.isSelected)
    {
        [_star5 setBackgroundImage:[UIImage imageNamed:@"star_show.png"] forState:UIControlStateNormal];
    }
    else
    {
        [_star5 setBackgroundImage:[UIImage imageNamed:@"star_hide.png"] forState:UIControlStateNormal];
    }
    
    if(_delegate && [_delegate respondsToSelector:@selector(rankViewDidClickStarButton:)])
    {
        [_delegate rankViewDidClickStarButton:self];
    }
}

- (void)clickStar2:(id)sender
{
    if(_starCount > 2)
    {
        _starCount = 2;
        _star1.selected = YES;
        _star2.selected = YES;
        _star3.selected = NO;
        _star4.selected = NO;
        _star5.selected = NO;
    }
    else
    {
        _star2.selected = !_star2.isSelected;
        if(_star2.isSelected)
        {
            _starCount = 2;
            _star1.selected = YES;
        }
        else
        {
            _starCount = 1;
            _star3.selected = NO;
            _star4.selected = NO;
            _star5.selected = NO;
        }
    }
    
    if(_star1.isSelected)
    {
        [_star1 setBackgroundImage:[UIImage imageNamed:@"star_show.png"] forState:UIControlStateNormal];
    }
    else
    {
        [_star1 setBackgroundImage:[UIImage imageNamed:@"star_hide.png"] forState:UIControlStateNormal];
    }
    if(_star2.isSelected)
    {
        [_star2 setBackgroundImage:[UIImage imageNamed:@"star_show.png"] forState:UIControlStateNormal];
    }
    else
    {
        [_star2 setBackgroundImage:[UIImage imageNamed:@"star_hide.png"] forState:UIControlStateNormal];
    }
    if(_star3.isSelected)
    {
        [_star3 setBackgroundImage:[UIImage imageNamed:@"star_show.png"] forState:UIControlStateNormal];
    }
    else
    {
        [_star3 setBackgroundImage:[UIImage imageNamed:@"star_hide.png"] forState:UIControlStateNormal];
    }
    if(_star4.isSelected)
    {
        [_star4 setBackgroundImage:[UIImage imageNamed:@"star_show.png"] forState:UIControlStateNormal];
    }
    else
    {
        [_star4 setBackgroundImage:[UIImage imageNamed:@"star_hide.png"] forState:UIControlStateNormal];
    }
    if(_star5.isSelected)
    {
        [_star5 setBackgroundImage:[UIImage imageNamed:@"star_show.png"] forState:UIControlStateNormal];
    }
    else
    {
        [_star5 setBackgroundImage:[UIImage imageNamed:@"star_hide.png"] forState:UIControlStateNormal];
    }
    
    if(_delegate && [_delegate respondsToSelector:@selector(rankViewDidClickStarButton:)])
    {
        [_delegate rankViewDidClickStarButton:self];
    }
}

- (void)clickStar3:(id)sender
{
    if(_starCount > 3)
    {
        _starCount = 3;
        _star1.selected = YES;
        _star2.selected = YES;
        _star3.selected = YES;
        _star4.selected = NO;
        _star5.selected = NO;
    }
    else
    {
        _star3.selected = !_star3.isSelected;
        if(_star3.isSelected)
        {
            _starCount = 3;
            _star2.selected = YES;
            _star1.selected = YES;
        }
        else
        {
            _starCount = 2;
            _star4.selected = NO;
            _star5.selected = NO;
        }
    }
    
    if(_star1.isSelected)
    {
        [_star1 setBackgroundImage:[UIImage imageNamed:@"star_show.png"] forState:UIControlStateNormal];
    }
    else
    {
        [_star1 setBackgroundImage:[UIImage imageNamed:@"star_hide.png"] forState:UIControlStateNormal];
    }
    if(_star2.isSelected)
    {
        [_star2 setBackgroundImage:[UIImage imageNamed:@"star_show.png"] forState:UIControlStateNormal];
    }
    else
    {
        [_star2 setBackgroundImage:[UIImage imageNamed:@"star_hide.png"] forState:UIControlStateNormal];
    }
    if(_star3.isSelected)
    {
        [_star3 setBackgroundImage:[UIImage imageNamed:@"star_show.png"] forState:UIControlStateNormal];
    }
    else
    {
        [_star3 setBackgroundImage:[UIImage imageNamed:@"star_hide.png"] forState:UIControlStateNormal];
    }
    if(_star4.isSelected)
    {
        [_star4 setBackgroundImage:[UIImage imageNamed:@"star_show.png"] forState:UIControlStateNormal];
    }
    else
    {
        [_star4 setBackgroundImage:[UIImage imageNamed:@"star_hide.png"] forState:UIControlStateNormal];
    }
    if(_star5.isSelected)
    {
        [_star5 setBackgroundImage:[UIImage imageNamed:@"star_show.png"] forState:UIControlStateNormal];
    }
    else
    {
        [_star5 setBackgroundImage:[UIImage imageNamed:@"star_hide.png"] forState:UIControlStateNormal];
    }
    
    if(_delegate && [_delegate respondsToSelector:@selector(rankViewDidClickStarButton:)])
    {
        [_delegate rankViewDidClickStarButton:self];
    }
}

- (void)clickStar4:(id)sender
{
    if(_starCount > 4)
    {
        _starCount = 4;
        _star1.selected = YES;
        _star2.selected = YES;
        _star3.selected = YES;
        _star4.selected = YES;
        _star5.selected = NO;
    }
    else
    {
        _star4.selected = !_star4.isSelected;
        if(_star4.isSelected)
        {
            _starCount = 4;
            _star3.selected = YES;
            _star2.selected = YES;
            _star1.selected = YES;
        }
        else
        {
            _starCount = 3;
            _star5.selected = NO;
        }
    }
    
    if(_star1.isSelected)
    {
        [_star1 setBackgroundImage:[UIImage imageNamed:@"star_show.png"] forState:UIControlStateNormal];
    }
    else
    {
        [_star1 setBackgroundImage:[UIImage imageNamed:@"star_hide.png"] forState:UIControlStateNormal];
    }
    if(_star2.isSelected)
    {
        [_star2 setBackgroundImage:[UIImage imageNamed:@"star_show.png"] forState:UIControlStateNormal];
    }
    else
    {
        [_star2 setBackgroundImage:[UIImage imageNamed:@"star_hide.png"] forState:UIControlStateNormal];
    }
    if(_star3.isSelected)
    {
        [_star3 setBackgroundImage:[UIImage imageNamed:@"star_show.png"] forState:UIControlStateNormal];
    }
    else
    {
        [_star3 setBackgroundImage:[UIImage imageNamed:@"star_hide.png"] forState:UIControlStateNormal];
    }
    if(_star4.isSelected)
    {
        [_star4 setBackgroundImage:[UIImage imageNamed:@"star_show.png"] forState:UIControlStateNormal];
    }
    else
    {
        [_star4 setBackgroundImage:[UIImage imageNamed:@"star_hide.png"] forState:UIControlStateNormal];
    }
    if(_star5.isSelected)
    {
        [_star5 setBackgroundImage:[UIImage imageNamed:@"star_show.png"] forState:UIControlStateNormal];
    }
    else
    {
        [_star5 setBackgroundImage:[UIImage imageNamed:@"star_hide.png"] forState:UIControlStateNormal];
    }
    
    if(_delegate && [_delegate respondsToSelector:@selector(rankViewDidClickStarButton:)])
    {
        [_delegate rankViewDidClickStarButton:self];
    }
}

- (void)clickStar5:(id)sender
{
    _star5.selected = !_star5.isSelected;
    if(_star5.isSelected)
    {
        _starCount = 5;
        _star4.selected = YES;
        _star3.selected = YES;
        _star2.selected = YES;
        _star1.selected = YES;
    }
    else
    {
        _starCount = 4;
    }
    
    if(_star1.isSelected)
    {
        [_star1 setBackgroundImage:[UIImage imageNamed:@"star_show.png"] forState:UIControlStateNormal];
    }
    else
    {
        [_star1 setBackgroundImage:[UIImage imageNamed:@"star_hide.png"] forState:UIControlStateNormal];
    }
    if(_star2.isSelected)
    {
        [_star2 setBackgroundImage:[UIImage imageNamed:@"star_show.png"] forState:UIControlStateNormal];
    }
    else
    {
        [_star2 setBackgroundImage:[UIImage imageNamed:@"star_hide.png"] forState:UIControlStateNormal];
    }
    if(_star3.isSelected)
    {
        [_star3 setBackgroundImage:[UIImage imageNamed:@"star_show.png"] forState:UIControlStateNormal];
    }
    else
    {
        [_star3 setBackgroundImage:[UIImage imageNamed:@"star_hide.png"] forState:UIControlStateNormal];
    }
    if(_star4.isSelected)
    {
        [_star4 setBackgroundImage:[UIImage imageNamed:@"star_show.png"] forState:UIControlStateNormal];
    }
    else
    {
        [_star4 setBackgroundImage:[UIImage imageNamed:@"star_hide.png"] forState:UIControlStateNormal];
    }
    if(_star5.isSelected)
    {
        [_star5 setBackgroundImage:[UIImage imageNamed:@"star_show.png"] forState:UIControlStateNormal];
    }
    else
    {
        [_star5 setBackgroundImage:[UIImage imageNamed:@"star_hide.png"] forState:UIControlStateNormal];
    }
    
    if(_delegate && [_delegate respondsToSelector:@selector(rankViewDidClickStarButton:)])
    {
        [_delegate rankViewDidClickStarButton:self];
    }
}

#pragma mark - super

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self != nil)
    {
        _star1 = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        _star1.frame = CGRectMake(0, 0, 16, 16);
        _star1.backgroundColor = [UIColor clearColor];
        [_star1 setBackgroundImage:[UIImage imageNamed:@"star_hide.png"] forState:UIControlStateNormal];
        [_star1 setBackgroundImage:[UIImage imageNamed:@"star_show.png"] forState:UIControlStateSelected];
        [_star1 addTarget:self action:@selector(clickStar1:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_star1];
        [_star1 setSelected:NO];
        
        _star2 = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        _star2.frame = CGRectMake(_star1.frame.origin.x + _star1.frame.size.width + 16, _star1.frame.origin.y, 16, 16);
        _star2.backgroundColor = [UIColor clearColor];
        [_star2 setBackgroundImage:[UIImage imageNamed:@"star_hide.png"] forState:UIControlStateNormal];
        [_star2 setBackgroundImage:[UIImage imageNamed:@"star_show.png"] forState:UIControlStateSelected];
        [_star2 addTarget:self action:@selector(clickStar2:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_star2];
        [_star2 setSelected:NO];
        
        _star3 = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        _star3.frame = CGRectMake(_star2.frame.origin.x + _star2.frame.size.width + 16, _star2.frame.origin.y, 16, 16);
        _star3.backgroundColor = [UIColor clearColor];
        [_star3 setBackgroundImage:[UIImage imageNamed:@"star_hide.png"] forState:UIControlStateNormal];
        [_star3 setBackgroundImage:[UIImage imageNamed:@"star_show.png"] forState:UIControlStateSelected];
        [_star3 addTarget:self action:@selector(clickStar3:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_star3];
        [_star3 setSelected:NO];
        
        _star4 = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        _star4.frame = CGRectMake(_star3.frame.origin.x + _star3.frame.size.width + 16, _star3.frame.origin.y, 16, 16);
        _star4.backgroundColor = [UIColor clearColor];
        [_star4 setBackgroundImage:[UIImage imageNamed:@"star_hide.png"] forState:UIControlStateNormal];
        [_star4 setBackgroundImage:[UIImage imageNamed:@"star_show.png"] forState:UIControlStateSelected];
        [_star4 addTarget:self action:@selector(clickStar4:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_star4];
        [_star4 setSelected:NO];
        
        _star5 = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        _star5.frame = CGRectMake(_star4.frame.origin.x + _star4.frame.size.width + 16, _star4.frame.origin.y, 16, 16);
        _star5.backgroundColor = [UIColor clearColor];
        [_star5 setBackgroundImage:[UIImage imageNamed:@"star_hide.png"] forState:UIControlStateNormal];
        [_star5 setBackgroundImage:[UIImage imageNamed:@"star_show.png"] forState:UIControlStateSelected];
        [_star5 addTarget:self action:@selector(clickStar5:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_star5];
        [_star5 setSelected:NO];
    }
    
    return self;
}

- (void)setStarCount:(NSInteger)starCount
{
    _starCount = starCount;
    
    switch (starCount) {
        case 0:
        {
        
        }
            break;
        case 1:
        {
            [self clickStar1:nil];
        }
            break;
        case 2:
        {
            [self clickStar2:nil];
        }
            break;
        case 3:
        {
            [self clickStar3:nil];
        }
            break;
        case 4:
        {
            [self clickStar4:nil];
        }
            break;
        case 5:
        {
            [self clickStar5:nil];
        }
            break;
        default:
            break;
    }
}

@end
