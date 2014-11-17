//
//  DynamicCell.h
//  YYMiOS
//
//  Created by lide on 14-9-22.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deal.h"

@interface DynamicCell : UITableViewCell
{
    Deal            *_deal;
    
    UIImageView     *_backImageView;
    
    UIImageView     *_avatarImageView;
    UILabel         *_nameLabel;
    UILabel         *_lastTimeLabel;
    UIButton        *_followButton;
    UILabel         *_contentLabel;
    
    UIImageView     *_goodsImageView;
    UIView          *_floatView;
    UIButton        *_likeButton;
    UIButton        *_commentButton;
    UILabel         *_numberLabel;
    
    UIImageView     *_priceIcon;
    UILabel         *_priceLabel;
    UIImageView     *_locationIcon;
    UILabel         *_locationLabel;
    UIButton        *_shareButton;
}

@property (retain, nonatomic) Deal *deal;

@end
