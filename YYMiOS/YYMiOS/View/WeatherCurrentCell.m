//
//  WeatherCurrentCell.m
//  YYMiOS
//
//  Created by Lide on 14/12/8.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "WeatherCurrentCell.h"

@implementation WeatherCurrentCell

@synthesize weather = _weather;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        _cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, self.contentView.frame.size.width - 15 * 2, 45)];
        _cityLabel.backgroundColor = [UIColor clearColor];
        _cityLabel.textColor = [UIColor whiteColor];
        _cityLabel.font = [UIFont systemFontOfSize:24.0f];
        [self.contentView addSubview:_cityLabel];
        
        _weatherLabel = [[UILabel alloc] initWithFrame:_cityLabel.frame];
        _weatherLabel.backgroundColor = [UIColor clearColor];
        _weatherLabel.textColor = [UIColor whiteColor];
        _weatherLabel.font = [UIFont systemFontOfSize:24.0f];
        _weatherLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_weatherLabel];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setWeather:(Weather *)weather
{
    if(_weather != nil)
    {
        LP_SAFE_RELEASE(_weather);
    }
    _weather = [weather retain];
    
    _cityLabel.text = weather.city.cityName;
    _weatherLabel.text = [NSString stringWithFormat:@"%@ %i˚ ~ %i˚", weather.currentForecast.condiction, _weather.currentForecast.low, _weather.currentForecast.high];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
