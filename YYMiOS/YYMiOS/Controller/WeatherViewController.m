//
//  WeatherViewController.m
//  YYMiOS
//
//  Created by lide on 14-9-22.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "WeatherViewController.h"

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
    
//    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _adjustView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - _adjustView.frame.size.height) style:UITableViewStylePlain];
//    _tableView.backgroundColor = [UIColor clearColor];
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
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    NSLog(@"%@", dateString);
    
    if([dateString rangeOfString:@"AM"].location != NSNotFound)
    {
        _backgroundImageView.image = [UIImage imageNamed:@"weather_day"];
    }
    else
    {
        _backgroundImageView.image = [UIImage imageNamed:@"weather_night"];
    }
}

@end
