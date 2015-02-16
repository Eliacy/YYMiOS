//
//  NearbyCell.h
//  YYMiOS
//
//  Created by lide on 14-9-24.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "POI.h"
#import "StarView.h"

@interface NearbyCell : UITableViewCell
{
    POI             *_poi;
    
    UIView          *_backView;
    
    UIImageView     *_avatarImageView;
    UILabel         *_titleLabel;
    UIImageView     *_levelImageView;
    UILabel         *_levelLabel;
    StarView        *_starView;
    UIButton        *_reviewButton;
    UILabel         *_distanceLabel;
    UIImageView     *_locationImageView;
    UILabel         *_locationLabel;
    UIImageView     *_keywordImageView;
    UILabel         *_keywordLabel;
    
    UIScrollView    *_scrollView;
}

@property (retain, nonatomic) POI *poi;
@property (retain, nonatomic) UIImageView *keywordImageView;


/**
 *  根据两点的经纬度算距离
 *
 *  @param Location1Lat    经度1
 *  @param Location1Lon    纬度1
 *  @param Location2Lat    经度2
 *  @param Location2Lon    纬度2
 */
- (void)setDistanceLabelWithLocation1Lat:(double)location1Lat Location1Lon:(double)location1Lon Location2Lat:(double)location2Lat Location2Lon:(double)location2Lon;

@end
