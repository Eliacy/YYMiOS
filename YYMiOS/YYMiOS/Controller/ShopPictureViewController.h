//
//  ShopPictureViewController.h
//  YYMiOS
//
//  Created by Lide on 14/11/19.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "BaseViewController.h"
#import "PictureImageView.h"

@interface ShopPictureViewController : BaseViewController
{
    NSInteger       _index;
    NSMutableArray  *_pictureArray;

    UIScrollView        *_scrollView;
    
    PictureImageView    *_leftBrowserView;
    PictureImageView    *_middleBrowserView;
    PictureImageView    *_rightBrowserView;
}

@property (assign, nonatomic) NSInteger index;
@property (retain, nonatomic) NSMutableArray *pictureArray;

@end
