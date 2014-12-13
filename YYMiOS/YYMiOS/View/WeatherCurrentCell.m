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
        
        _cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, self.contentView.frame.size.width - 15 - 10 - 10 - 55, 45)];
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
        
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_cityLabel.frame.origin.x + _cityLabel.frame.size.width + 10, 10, 55, 55)];
        _iconImageView.backgroundColor = [UIColor clearColor];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        _iconImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_iconImageView];
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
    
    switch (weather.currentForecast.typeId) {
        case 1:
        case 3:
        case 4:
        case 8:
        case 16:
        case 17:
        case 101:
        case 103:
        case 104:
        case 108:
        case 116:
        case 117:
        {
            _iconImageView.image = [UIImage imageNamed:@"snow_large.png"];
        }
            break;
        case 2:
        case 5:
        case 15:
        case 19:
        case 102:
        case 105:
        case 115:
        case 119:
        {
            _iconImageView.image = [UIImage imageNamed:@"rain_large.png"];
        }
            break;
        case 7:
        case 9:
        case 10:
        case 11:
        case 13:
        case 107:
        case 109:
        case 110:
        case 111:
        case 113:
        {
            _iconImageView.image = [UIImage imageNamed:@"cloudy_large.png"];
        }
            break;
        case 6:
        case 12:
        case 14:
        case 18:
        case 106:
        case 112:
        case 114:
        case 118:
        {
            _iconImageView.image = [UIImage imageNamed:@"sunshine_large.png"];
        }
            break;
        default:
            break;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
