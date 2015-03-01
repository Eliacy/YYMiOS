//
//  PicturePreviewViewController.h
//  Secretary
//
//  Created by Lide on 14/12/17.
//
//

#import "BaseViewController.h"
#import "PictureImageView.h"

@protocol PicturePreviewViewControllerDelegate;

@interface PicturePreviewViewController : BaseViewController
{
    id<PicturePreviewViewControllerDelegate>    _delegate;
    
    NSMutableArray      *_pictureArray;
    NSInteger           _index;
    
    UIButton            *_closeButton;
    UIButton            *_deleteButton;
    
    UIScrollView        *_scrollView;
    
    PictureImageView    *_leftBrowserView;
    PictureImageView    *_middleBrowserView;
    PictureImageView    *_rightBrowserView;
}

@property (assign, nonatomic) id<PicturePreviewViewControllerDelegate> delegate;

@property (assign, nonatomic) NSInteger index;
@property (retain, nonatomic) NSMutableArray *pictureArray;

@end

@protocol PicturePreviewViewControllerDelegate <NSObject>

- (void)picturePreviewViewControllerDidDeleteImage:(PicturePreviewViewController *)picturePreviewVC;

@end
