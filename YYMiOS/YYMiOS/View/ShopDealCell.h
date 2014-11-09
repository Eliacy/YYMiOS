//
//  CommentCell.h
//  YYMiOS
//
//  Created by lide on 14-10-5.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deal.h"

@interface ShopDealCell : UITableViewCell
{
    Deal            *_deal;
    
    UIImageView     *_imageView;
    UILabel         *_contentLabel;
    UILabel         *_likeLabel;
    UILabel         *_commentLabel;
    UILabel         *_nameLabel;
}

@property (retain, nonatomic) Deal *deal;

@end
