//
//  WeatherCurrentCell.h
//  YYMiOS
//
//  Created by Lide on 14/12/8.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Weather.h"

@interface WeatherCurrentCell : UITableViewCell
{
    Weather     *_weather;
    
    UILabel     *_cityLabel;
    UILabel     *_weatherLabel;
    
    UIImageView *_iconImageView;
}

@property (retain, nonatomic) Weather *weather;

@end
