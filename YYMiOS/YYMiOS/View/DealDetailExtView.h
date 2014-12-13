//
//  DealDetailExtView.h
//  YYMiOS
//
//  Created by Lide on 14/12/13.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deal.h"

@interface DealDetailExtView : UIView
{
    Deal        *_deal;
    
    UILabel     *_keywordLabel;
    UILabel     *_priceLabel;
    UIImageView *_likeIcon;
    UILabel     *_likeLabel;
    UIImageView *_commentIcon;
    UILabel     *_commentLabel;
    
    UIView      *_grayView;
}

@property (retain, nonatomic) Deal *deal;

@end
