//
//  DynamicCell.h
//  YYMiOS
//
//  Created by lide on 14-9-22.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deal.h"

@protocol DynamicCellDelegate;

@interface DynamicCell : UITableViewCell
{
    Deal            *_deal;
    id<DynamicCellDelegate> _delegate;
    
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
@property (assign, nonatomic) id<DynamicCellDelegate> delegate;

@end

@protocol DynamicCellDelegate <NSObject>

- (void)dynamicCellDidTapAvatarImageView:(DynamicCell *)dynamicCell;
- (void)dynamicCellDidClickFollowButton:(DynamicCell *)dynamicCell;
- (void)dynamicCellDidClickShareButton:(DynamicCell *)dynamicCell;

@end
