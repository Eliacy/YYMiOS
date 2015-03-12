//
//  RankView.h
//  YYMiOS
//
//  Created by Lide on 15/3/11.
//  Copyright (c) 2015年 Lide. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RankViewDelegate;

@interface RankView : UIView
{
    UIButton        *_star1;
    UIButton        *_star2;
    UIButton        *_star3;
    UIButton        *_star4;
    UIButton        *_star5;
    
    NSInteger       _starCount;
    id<RankViewDelegate>    _delegate;
}

@property (assign, nonatomic) NSInteger starCount;
@property (assign, nonatomic) id<RankViewDelegate> delegate;

@end

@protocol RankViewDelegate <NSObject>

- (void)rankViewDidClickStarButton:(RankView *)rankView;

@end
