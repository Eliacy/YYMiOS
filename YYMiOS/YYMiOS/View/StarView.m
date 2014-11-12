//
//  StarView.m
//  YYMiOS
//
//  Created by Lide on 14/11/13.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "StarView.h"

@implementation StarView

@synthesize stars = _stars;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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

- (void)setStars:(CGFloat)stars
{
    _stars = stars;
    
    for(UIView *view in self.subviews)
    {
        [view removeFromSuperview];
    }
    
    int i = 0;
    while (i < stars)
    {
        UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(i * 15, 0, 10, 10)] autorelease];
        imageView.backgroundColor = [UIColor clearColor];
        imageView.image = [UIImage imageNamed:@"star_show.png"];
        [self addSubview:imageView];
        
        i++;
    }
    
    if(i + 0.5 <= stars)
    {
        UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(i * 15, 0, 10, 10)] autorelease];
        imageView.backgroundColor = [UIColor clearColor];
        imageView.image = [UIImage imageNamed:@"star_half.png"];
        [self addSubview:imageView];
        
        i++;
    }
    
    while (i < 5)
    {
        UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(i * 15, 0, 10, 10)] autorelease];
        imageView.backgroundColor = [UIColor clearColor];
        imageView.image = [UIImage imageNamed:@"star_hide.png"];
        [self addSubview:imageView];
        
        i++;
    }
}

@end
