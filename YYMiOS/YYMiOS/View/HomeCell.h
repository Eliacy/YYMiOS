//
//  HomeCell.h
//  YYMiOS
//
//  Created by lide on 14-9-22.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article.h"

@interface HomeCell : UITableViewCell
{
    Article         *_article;
    
    UIImageView     *_backImageView;
    UILabel         *_titleLabel;
    UILabel         *_timeLabel;
    UIButton        *_eventButton;
}

@property (retain, nonatomic) Article *article;

@end
