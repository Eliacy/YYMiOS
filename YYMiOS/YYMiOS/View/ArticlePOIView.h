//
//  ArticlePOIView.h
//  YYMiOS
//
//  Created by Lide on 14/11/17.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "POI.h"
#import "StarView.h"

@protocol ArticlePOIViewDelegate;

@interface ArticlePOIView : UIView
{
    POI             *_poi;
    id<ArticlePOIViewDelegate>  _delegate;
    
    UIView          *_backView;
    UIImageView     *_avatarImageView;
    UILabel         *_titleLabel;
    UIImageView     *_levelImageView;
    StarView        *_starView;
    UIButton        *_reviewButton;
    UILabel         *_distanceLabel;
    UIImageView     *_locationImageView;
    UILabel         *_locationLabel;
    UIImageView     *_keywordImageView;
    UILabel         *_keywordLabel;
}

@property (retain, nonatomic) POI *poi;
@property (assign, nonatomic) id<ArticlePOIViewDelegate> delegate;

@property (retain, nonatomic) UIImageView *keywordImageView;

@end

@protocol ArticlePOIViewDelegate <NSObject>

- (void)articlePOIViewDidTap:(ArticlePOIView *)articlePOIView;

@end
