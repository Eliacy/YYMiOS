//
//  DealDetailExtView.h
//  YYMiOS
//
//  Created by Lide on 14/12/13.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deal.h"

@protocol DealDetailExtViewDelegate;

@interface DealDetailExtView : UIView
{
    Deal        *_deal;
    id<DealDetailExtViewDelegate>   _delegate;
    
    UILabel     *_keywordLabel;
    UILabel     *_priceLabel;
    UIImageView *_likeIcon;
    UILabel     *_likeLabel;
    UIImageView *_commentIcon;
    UILabel     *_commentLabel;
    
    UIButton    *_likeButton;
    
    UIView      *_grayView;
}

@property (retain, nonatomic) Deal *deal;
@property (assign, nonatomic) id<DealDetailExtViewDelegate> delegate;

- (void)refresh;

@end

@protocol DealDetailExtViewDelegate <NSObject>

- (void)dealDetailExtViewDidClickLikeButton:(DealDetailExtView *)dealDetailExtView;

@end
