//
//  DynamicCell.h
//  YYMiOS
//
//  Created by lide on 14-9-22.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DynamicCell : UITableViewCell
{
    UIImageView     *_backImageView;
    
    UIImageView     *_avatarImageView;
    UILabel         *_nameLabel;
    UILabel         *_lastTimeLabel;
    UIButton        *_followButton;
    UILabel         *_contentLabel;
    
    UIImageView     *_goodsImageView;
    UIView          *_floatView;
    UILabel         *_likeLabel;
    UILabel         *_commentLabel;
    UILabel         *_numberLabel;
    
    UILabel         *_priceLabel;
    UILabel         *_locationLabel;
    UIButton        *_shareButton;
}

@end
