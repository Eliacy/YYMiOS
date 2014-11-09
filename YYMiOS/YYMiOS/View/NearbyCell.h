//
//  NearbyCell.h
//  YYMiOS
//
//  Created by lide on 14-9-24.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "POI.h"

@interface NearbyCell : UITableViewCell
{
    POI             *_poi;
    
    UIView          *_backView;
    
    UIImageView     *_avatarImageView;
    UILabel         *_titleLabel;
    
    UIScrollView    *_scrollView;
}

@property (retain, nonatomic) POI *poi;

@end
