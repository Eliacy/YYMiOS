//
//  WeatherViewController.m
//  YYMiOS
//
//  Created by lide on 14-9-22.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "WeatherViewController.h"
#import "WeatherCurrentCell.h"
#import "WeatherForecastCell.h"

@interface WeatherViewController ()

@end

@implementation WeatherViewController

@synthesize tabVC = _tabVC;
@synthesize weather = _weather;

- (id)init
{
    self = [super init];
    if(self != nil)
    {
        
    }
    
    return self;
}

- (void)loadView
{
    [super loadView];
    
    self.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height - 49);
    _titleLabel.text = @"天气";
    _backButton.hidden = YES;
    
    _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, _adjustView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - _adjustView.frame.size.height)];
    _backgroundImageView.backgroundColor = [UIColor clearColor];
    _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    _backgroundImageView.layer.masksToBounds = YES;
    [self.view addSubview:_backgroundImageView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _adjustView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - _adjustView.frame.size.height) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorColor = [UIColor clearColor];
    // 这里用 UITableViewStyleGrouped 代替 Plain 来解决第二个 Section 的 Footer 中的横线挤在界面最下方无法消失问题。但这样也造成了表格样式有变化，下面两行尽量还原表现样式。
    _tableView.sectionHeaderHeight = 0.0;
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _tableView.bounds.size.width, 0.01f)];
    [self.view addSubview:_tableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(_isAppear)
    {
        return;
    }
    _isAppear = YES;
    
    [Weather getCityForecastWithCityId:[[[NSUserDefaults standardUserDefaults] objectForKey:@"city_id"] integerValue]
                               success:^(NSArray *array) {
                                   
                                   if([array count] > 0)
                                   {
                                       [self setWeather:[array objectAtIndex:0]];
                                   }
                                   
                               } failure:^(NSError *error) {
                                   
                               }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if(!_isAppear)
    {
        return;
    }
    _isAppear = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)setWeather:(Weather *)weather
{
    if(_weather != nil)
    {
        LP_SAFE_RELEASE(_weather);
    }
    _weather = [weather retain];
    
    if(weather.currentForecast.isNight)
    {
        _backgroundImageView.image = [UIImage imageNamed:@"weather_night.png"];
    }
    else
    {
        _backgroundImageView.image = [UIImage imageNamed:@"weather_day.png"];
    }
    
    [_tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            if(_weather && _weather.currentForecast != nil)
            {
                return 1;
            }
        }
            break;
        case 1:
        {
            if(_weather && _weather.forecastArray != nil && [_weather.forecastArray count] > 0)
            {
                return [_weather.forecastArray count];
            }
        }
            break;
        case 2:
        {
        
        }
            break;
        default:
            break;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    
    switch (indexPath.section) {
        case 0:
        {
            height += 75;
        }
            break;
        case 1:
        {
            height += 45;
        }
            break;
        case 2:
        {
            
        }
            break;
        default:
            break;
    }

    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CGFloat height = 0;
    
    switch (section) {
        case 0:
        {
            height += 1;
        }
            break;
        case 1:
        {
            height += 1;
        }
            break;
        case 2:
        {
            
        }
            break;
        default:
            break;
    }
    
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 1)] autorelease];
            UIView *line = [[[UIView alloc] initWithFrame:CGRectMake(15, 0, view.frame.size.width - 15, 1)] autorelease];
            line.backgroundColor = [UIColor whiteColor];
            [view addSubview:line];
            return view;
        }
            break;
        case 1:
        {
            UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 1)] autorelease];
            UIView *line = [[[UIView alloc] initWithFrame:CGRectMake(15, 0, view.frame.size.width - 15, 1)] autorelease];
            line.backgroundColor = [UIColor whiteColor];
            [view addSubview:line];
            return view;
        }
            break;
        case 2:
        {
            
        }
            break;
        default:
            break;
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            WeatherCurrentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WeatherViewControllerCurrentIdentifier"];
            if(cell == nil)
            {
                cell = [[[WeatherCurrentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WeatherViewControllerCurrentIdentifier"] autorelease];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            cell.weather = _weather;
            
            return cell;
        }
            break;
        case 1:
        {
            WeatherForecastCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WeatherViewControllerForecastIdentifier"];
            if(cell == nil)
            {
                cell = [[[WeatherForecastCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WeatherViewControllerForecastIdentifier"] autorelease];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            cell.forecast = [_weather.forecastArray objectAtIndex:indexPath.row];
            
            return cell;
        }
            break;
        case 2:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WeatherViewControllerIdentifier"];
            if(cell == nil)
            {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WeatherViewControllerIdentifier"] autorelease];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            return cell;
        }
            break;
        default:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WeatherViewControllerIdentifier"];
            if(cell == nil)
            {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WeatherViewControllerIdentifier"] autorelease];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            return cell;
        }
            break;
    }
}

#pragma mark - UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

@end
