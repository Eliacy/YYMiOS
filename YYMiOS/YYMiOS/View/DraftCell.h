//
//  DraftCell.h
//  YYMiOS
//
//  Created by lide on 14-9-28.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deal.h"

@interface DraftCell : UITableViewCell
{
    Deal            *_deal;
    
    UIImageView     *_avatarImageView;
    UILabel         *_titleLabel;
    UILabel         *_timeLabel;
    UILabel         *_contentLabel;
}

@property (retain, nonatomic) Deal *deal;

@end
