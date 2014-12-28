//
//  PictureImageView.h
//  Secretary
//
//  Created by Lide on 14/12/17.
//
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface PictureImageView : UIView <UIScrollViewDelegate>
{
    ALAsset         *_asset;
    NSString        *_imageURL;
    
    UIScrollView    *_scrollView;
    UIImageView     *_imageView;
    
    UIActivityIndicatorView *_indicatior;
}

@property (retain, nonatomic) ALAsset *asset;
@property (retain, nonatomic) NSString *imageURL;

@property (retain, nonatomic) UIImageView *imageView;

@end
