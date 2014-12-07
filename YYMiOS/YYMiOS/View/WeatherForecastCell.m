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
        
        _weekdayLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, self.contentView.frame.size.width - 15 * 2, 25)];
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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
