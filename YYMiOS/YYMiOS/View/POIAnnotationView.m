//
//  POIAnnotationView.m
//  YYMiOS
//
//  Created by Lide on 14/11/16.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "POIAnnotationView.h"

#define Arror_height 15

@implementation POIAnnotationView

@synthesize delegate = _delegate;

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if(self != nil)
    {
        self.backgroundColor = [UIColor clearColor];
        self.canShowCallout = NO;
        self.frame = CGRectMake(0, 0, 300, 140);
        
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 140)];
        _backView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_backView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(oneFingerTap:)];
        [_backView addGestureRecognizer:tap];
        [tap release];
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

#pragma mark - UIGestureRecognizer

- (void)oneFingerTap:(UITapGestureRecognizer *)gestureRecognizer
{
    if(gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        if(_delegate && [_delegate respondsToSelector:@selector(poiAnnotionViewDidTapBackView:)])
        {
            [_delegate poiAnnotionViewDidTapBackView:self];
        }
    }
}

@end
