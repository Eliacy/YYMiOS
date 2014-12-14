//
//  WeatherForecastCell.m
//  YYMiOS
//
//  Created by Lide on 14/12/8.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "WeatherForecastCell.h"

@implementation WeatherForecastCell

@synthesize forecast = _forecast;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        _weekdayLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, self.contentView.frame.size.width - 15 - 10 - 10 - 35, 25)];
        _weekdayLabel.backgroundColor = [UIColor clearColor];
        _weekdayLabel.textColor = [UIColor whiteColor];
        _weekdayLabel.font = [UIFont systemFontOfSize:18.0f];
        [self.contentView addSubview:_weekdayLabel];
        
        _weatherLabel = [[UILabel alloc] initWithFrame:_weekdayLabel.frame];
        _weatherLabel.backgroundColor = [UIColor clearColor];
        _weatherLabel.textColor = [UIColor whiteColor];
        _weatherLabel.font = [UIFont systemFontOfSize:18.0f];
        _weatherLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_weatherLabel];
        
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_weekdayLabel.frame.origin.x + _weekdayLabel.frame.size.width + 10, 5, 35, 35)];
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

- (void)setForecast:(Forecast *)forecast
{
    if(_forecast != nil)
    {
        LP_SAFE_RELEASE(_forecast);
    }
    _forecast = [forecast retain];
    
    _weekdayLabel.text = forecast.weekday;
    _weatherLabel.text = [NSString stringWithFormat:@"%@ %i˚ ~ %i˚", _forecast.condiction, _forecast.low, _forecast.high];
    
    switch (forecast.typeId) {
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
            _iconImageView.image = [UIImage imageNamed:@"snow.png"];
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
            _iconImageView.image = [UIImage imageNamed:@"rain.png"];
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
            _iconImageView.image = [UIImage imageNamed:@"cloudy.png"];
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
            _iconImageView.image = [UIImage imageNamed:@"sunshine.png"];
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
