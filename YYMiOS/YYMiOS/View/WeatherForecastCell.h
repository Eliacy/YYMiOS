//
//  WeatherForecastCell.h
//  YYMiOS
//
//  Created by Lide on 14/12/8.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Forecast.h"

@interface WeatherForecastCell : UITableViewCell
{
    Forecast    *_forecast;
    
    UILabel     *_weekdayLabel;
    UILabel     *_weatherLabel;
}

@property (retain, nonatomic) Forecast *forecast;

@end
