//
//  ShareKit.m
//  YYMiOS
//
//  Created by lide on 14-10-2.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "ShareKit.h"

@implementation ShareKit

@synthesize delegate = _delegate;

#pragma mark - public
static id sharedKit = nil;
+ (id)sharedKit
{
    @synchronized(sharedKit){
        if(sharedKit == nil)
        {
            sharedKit = [[self alloc] init];
        }
    }
    
    return sharedKit;
}

- (id)init
{
    self = [super init];
    if(self != nil)
    {
        _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
        _backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        
        _blockView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _backgroundView.frame.size.width, _backgroundView.frame.size.height)];
        _blockView.backgroundColor = [UIColor clearColor];
        [_backgroundView addSubview:_blockView];
        
        UITapGestureRecognizer *tapBlockView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBlockView:)];
        [_blockView addGestureRecognizer:tapBlockView];
        [tapBlockView release];
        
        _shareView = [[UIView alloc] initWithFrame:CGRectMake(0, _backgroundView.frame.size.height - 175, 320, 175)];
        _shareView.backgroundColor = [UIColor whiteColor];
        [_backgroundView addSubview:_shareView];
    }
    
    return self;
}

- (void)show
{
    [[[[UIApplication sharedApplication] delegate] window] addSubview:_backgroundView];
    _shareView.transform = CGAffineTransformMake(1, 0, 0, 1, 0, _shareView.frame.size.height);
    [UIView animateWithDuration:0.35
                     animations:^{
                         _shareView.transform = CGAffineTransformIdentity;
                     }];
}

- (void)hide
{
    [UIView animateWithDuration:0.35
                     animations:^{
                         _shareView.transform = CGAffineTransformMake(1, 0, 0, 1, 0, _shareView.frame.size.height);
                     } completion:^(BOOL finished) {
                         [_backgroundView removeFromSuperview];
                     }];
}

#pragma mark - UIGestureRecognizer

- (void)tapBlockView:(UITapGestureRecognizer *)gestureRecognizer
{
    if(gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        [self hide];
    }
}

@end
