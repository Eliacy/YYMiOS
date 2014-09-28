//
//  PhotoSelectView.h
//  YYMiOS
//
//  Created by lide on 14-9-28.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PhotoSelectViewDelegate;

@interface PhotoSelectView : UIView
{
    id<PhotoSelectViewDelegate> _delegate;
    
    UIView      *_backView;
    UIView      *_showView;
    
    UIButton    *_cameraButton;
    UIButton    *_libraryButton;
    UIButton    *_cancelButton;
}

@property (assign, nonatomic) id<PhotoSelectViewDelegate> delegate;

- (void)show;
- (void)hide;

@end

@protocol PhotoSelectViewDelegate <NSObject>

- (void)photoSelectViewDidClickCameraButton:(PhotoSelectView *)photoSelectView;
- (void)photoSelectViewDidClickLibraryButton:(PhotoSelectView *)photoSelectView;

@end
