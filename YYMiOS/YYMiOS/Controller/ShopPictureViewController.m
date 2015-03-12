//
//  ShopPictureViewController.m
//  YYMiOS
//
//  Created by Lide on 14/11/19.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "ShopPictureViewController.h"

@interface ShopPictureViewController () <UIScrollViewDelegate>

@end

@implementation ShopPictureViewController

#pragma mark - private

#pragma mark - super

- (id)init
{
    self = [super init];
    if(self != nil)
    {
        _pictureArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    
    return self;
}

- (void)loadView
{
    [super loadView];
    
    _titleLabel.text = @"晒单照片";
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    [self refreshScrollView];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setPictureArray:(NSMutableArray *)pictureArray
{
    [_pictureArray removeAllObjects];
    [_pictureArray addObjectsFromArray:pictureArray];
}

- (void)setBrowserViewImage
{
    if(_middleBrowserView == nil)
    {
        _middleBrowserView = [[PictureImageView alloc] initWithFrame:CGRectMake(0, 0, _scrollView.frame.size.width, _scrollView.frame.size.height)];
    }
    if(_leftBrowserView == nil)
    {
        _leftBrowserView = [[PictureImageView alloc] initWithFrame:CGRectMake(0, 0, _scrollView.frame.size.width, _scrollView.frame.size.height)];
    }
    if(_rightBrowserView == nil)
    {
        _rightBrowserView = [[PictureImageView alloc] initWithFrame:CGRectMake(0, 0, _scrollView.frame.size.width, _scrollView.frame.size.height)];
    }
    
    _middleBrowserView.frame = CGRectMake(_scrollView.frame.size.width * _index, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
    [_scrollView addSubview:_middleBrowserView];
    
    //判断图片类型
    if([[_pictureArray objectAtIndex:_index] isKindOfClass:[EMChatImage class]]){
        //消息图片为本地路径解析 且数组中只有一个元素
        _middleBrowserView.imageView.image = [UIImage imageWithContentsOfFile:[[_pictureArray objectAtIndex:_index] localPath]];
    }else{
        //店铺图片为url解析
        _middleBrowserView.imageURL = [LPUtility getQiniuImageURLStringWithBaseString:[[_pictureArray objectAtIndex:_index] imageURL] imageSize:CGSizeMake(self.view.frame.size.width * 2, self.view.frame.size.height * 2)];
    }
    
    _leftBrowserView.frame = CGRectMake(_scrollView.frame.size.width * (_index - 1), 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
    [_scrollView addSubview:_leftBrowserView];
    _rightBrowserView.frame = CGRectMake(_scrollView.frame.size.width * (_index + 1), 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
    [_scrollView addSubview:_rightBrowserView];
    
    if(_index == 0)
    {
        _leftBrowserView.hidden = YES;
    }
    else
    {
        _leftBrowserView.hidden = NO;
        _leftBrowserView.imageURL = [LPUtility getQiniuImageURLStringWithBaseString:[[_pictureArray objectAtIndex:_index - 1] imageURL] imageSize:CGSizeMake(self.view.frame.size.width * 2, self.view.frame.size.height * 2)];
    }
    
    if(_index == [_pictureArray count] - 1)
    {
        _rightBrowserView.hidden = YES;
    }
    else
    {
        _rightBrowserView.hidden = NO;
        _rightBrowserView.imageURL = [LPUtility getQiniuImageURLStringWithBaseString:[[_pictureArray objectAtIndex:_index + 1] imageURL] imageSize:CGSizeMake(self.view.frame.size.width * 2, self.view.frame.size.height * 2)];
    }
}

- (void)refreshScrollView
{
    _scrollView.contentSize = CGSizeMake([_pictureArray count] * _scrollView.frame.size.width, _scrollView.frame.size.height);
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width * _index, 0)];
    
    [self setBrowserViewImage];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    
    if(_index != index)
    {
        _index = index;
        
        [self setBrowserViewImage];
    }
}

@end
