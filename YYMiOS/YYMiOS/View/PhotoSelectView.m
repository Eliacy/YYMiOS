//
//  PhotoSelectView.m
//  YYMiOS
//
//  Created by lide on 14-9-28.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "PhotoSelectView.h"

@implementation PhotoSelectView

@synthesize delegate = _delegate;

#pragma mark - private

- (void)clickCameraButton:(id)sender
{
    if(_delegate && [_delegate respondsToSelector:@selector(photoSelectViewDidClickCameraButton:)])
    {
        [_delegate photoSelectViewDidClickCameraButton:self];
    }
    
    [self hide];
}

- (void)clickLibraryButton:(id)sender
{
    if(_delegate && [_delegate respondsToSelector:@selector(photoSelectViewDidClickLibraryButton:)])
    {
        [_delegate photoSelectViewDidClickLibraryButton:self];
    }
    
    [self hide];
}

- (void)clickCancelButton:(id)sender
{
    [self hide];
}

#pragma mark - super

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self != nil)
    {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
        _backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        [self addSubview:_backView];
        
        UITapGestureRecognizer *oneFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackView:)];
        [_backView addGestureRecognizer:oneFingerTap];
        [oneFingerTap release];
        
        _showView = [[UIView alloc] initWithFrame:CGRectMake(0, _backView.frame.size.height - 200, _backView.frame.size.width, 200)];
        _showView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_showView];
        _showView.transform = CGAffineTransformMake(1, 0, 0, 1, 0, _showView.frame.size.height);
        
        _cameraButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        _cameraButton.frame = CGRectMake(20, 15, _showView.frame.size.width - 20 * 2, 45);
        _cameraButton.backgroundColor = [UIColor clearColor];
        [_cameraButton setTitle:@"拍照上传" forState:UIControlStateNormal];
        [_cameraButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _cameraButton.layer.borderWidth = 1.0;
        _cameraButton.layer.borderColor = [[UIColor grayColor] CGColor];
        [_cameraButton addTarget:self action:@selector(clickCameraButton:) forControlEvents:UIControlEventTouchUpInside];
        [_showView addSubview:_cameraButton];
        
        _libraryButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        _libraryButton.frame = CGRectMake(_cameraButton.frame.origin.x, _cameraButton.frame.origin.y + _cameraButton.frame.size.height + 10, _cameraButton.frame.size.width, _cameraButton.frame.size.height);
        _libraryButton.backgroundColor = [UIColor clearColor];
        [_libraryButton setTitle:@"上传手机中的照片" forState:UIControlStateNormal];
        [_libraryButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _libraryButton.layer.borderWidth = 1.0;
        _libraryButton.layer.borderColor = [[UIColor grayColor] CGColor];
        [_libraryButton addTarget:self action:@selector(clickLibraryButton:) forControlEvents:UIControlEventTouchUpInside];
        [_showView addSubview:_libraryButton];
        
        _cancelButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        _cancelButton.frame = CGRectMake(_cameraButton.frame.origin.x, _showView.frame.size.height - _cameraButton.frame.size.height - 15, _cameraButton.frame.size.width, _cameraButton.frame.size.height);
        _cancelButton.backgroundColor = [UIColor grayColor];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(clickCancelButton:) forControlEvents:UIControlEventTouchUpInside];
        [_showView addSubview:_cancelButton];
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - public

- (void)show
{
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
    [UIView animateWithDuration:0.35
                     animations:^{
                         
                         _showView.transform = CGAffineTransformIdentity;
                         
                     }];
}

- (void)hide
{
    [UIView animateWithDuration:0.35
                     animations:^{
                         
                         _backView.alpha = 0.0;
                         _showView.transform = CGAffineTransformMake(1, 0, 0, 1, 0, _showView.frame.size.height);
                         
                     } completion:^(BOOL finished) {
                         
                         [self removeFromSuperview];
                         
                     }];
}

#pragma mark - UIGestureRecognizer

- (void)tapBackView:(UITapGestureRecognizer *)gestureRecognizer
{
    if(gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        [self hide];
    }
}

@end
