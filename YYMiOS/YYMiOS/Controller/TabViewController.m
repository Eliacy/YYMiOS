//
//  TabViewController.m
//  YYMiOS
//
//  Created by lide on 14-9-22.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "TabViewController.h"

@interface TabViewController ()

@end

@implementation TabViewController

#pragma mark - private

- (void)clickHomeButton:(id)sender
{
    if([_homeButon isSelected])
    {
        return;
    }
    [_homeButon setSelected:YES];
    [_dynamicButton setSelected:NO];
    [_weatherButton setSelected:NO];
    [_nearbyButton setSelected:NO];
    [_mineButton setSelected:NO];
    
    if(_homeVC == nil)
    {
        _homeVC = [[HomeViewController alloc] init];
        _homeVC.tabVC = self;
    }
    [self.view addSubview:_homeVC.view];
}

- (void)clickDynamicButton:(id)sender
{
    if([_dynamicButton isSelected])
    {
        return;
    }
    [_homeButon setSelected:NO];
    [_dynamicButton setSelected:YES];
    [_weatherButton setSelected:NO];
    [_nearbyButton setSelected:NO];
    [_mineButton setSelected:NO];
    
    if(_dynamicVC == nil)
    {
        _dynamicVC = [[DynamicViewController alloc] init];
        _dynamicVC.tabVC = self;
    }
    [self.view addSubview:_dynamicVC.view];
}

- (void)clickWeatherButton:(id)sender
{
    if([_weatherButton isSelected])
    {
        return;
    }
    [_homeButon setSelected:NO];
    [_dynamicButton setSelected:NO];
    [_weatherButton setSelected:YES];
    [_nearbyButton setSelected:NO];
    [_mineButton setSelected:NO];
    
    if(_weatherVC == nil)
    {
        _weatherVC = [[WeatherViewController alloc] init];
        _weatherVC.tabVC = self;
    }
    [self.view addSubview:_weatherVC.view];
}

- (void)clickNearbyButton:(id)sender
{
    if([_nearbyButton isSelected])
    {
        return;
    }
    [_homeButon setSelected:NO];
    [_dynamicButton setSelected:NO];
    [_weatherButton setSelected:NO];
    [_nearbyButton setSelected:YES];
    [_mineButton setSelected:NO];
    
    if(_nearbyVC == nil)
    {
        _nearbyVC = [[NearbyViewController alloc] init];
        _nearbyVC.tabVC = self;
    }
    [self.view addSubview:_nearbyVC.view];
}

- (void)clickMineButton:(id)sender
{
    if([_mineButton isSelected])
    {
        return;
    }
    [_homeButon setSelected:NO];
    [_dynamicButton setSelected:NO];
    [_weatherButton setSelected:NO];
    [_nearbyButton setSelected:NO];
    [_mineButton setSelected:YES];
    
    if(_mineVC == nil)
    {
        _mineVC = [[MineViewController alloc] init];
        _mineVC.tabVC = self;
    }
    [self.view addSubview:_mineVC.view];
}

#pragma mark - super

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
    
    _adjustView.hidden = YES;
    
    _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 49, self.view.frame.size.width, 49)];
    _footerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_footerView];
    
    _homeButon = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _homeButon.backgroundColor = [UIColor clearColor];
    _homeButon.frame = CGRectMake(0, 0, self.view.frame.size.width / 5, _footerView.frame.size.height);
    [_homeButon setBackgroundImage:[UIImage imageNamed:@"tab_home_hide.png"] forState:UIControlStateNormal];
    [_homeButon setBackgroundImage:[UIImage imageNamed:@"tab_home_show.png"] forState:UIControlStateSelected];
    [_homeButon addTarget:self action:@selector(clickHomeButton:) forControlEvents:UIControlEventTouchUpInside];
    [_footerView addSubview:_homeButon];
    [_homeButon setSelected:YES];
    
    _dynamicButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _dynamicButton.backgroundColor = [UIColor clearColor];
    _dynamicButton.frame = CGRectMake(_homeButon.frame.origin.x + _homeButon.frame.size.width, 0, self.view.frame.size.width / 5, _footerView.frame.size.height);
    [_dynamicButton setBackgroundImage:[UIImage imageNamed:@"tab_news_hide.png"] forState:UIControlStateNormal];
    [_dynamicButton setBackgroundImage:[UIImage imageNamed:@"tab_news_show.png"] forState:UIControlStateSelected];
    [_dynamicButton addTarget:self action:@selector(clickDynamicButton:) forControlEvents:UIControlEventTouchUpInside];
    [_footerView addSubview:_dynamicButton];
    
    _weatherButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _weatherButton.backgroundColor = [UIColor clearColor];
    _weatherButton.frame = CGRectMake(_dynamicButton.frame.origin.x + _dynamicButton.frame.size.width, 0, self.view.frame.size.width / 5, _footerView.frame.size.height);
    [_weatherButton setBackgroundImage:[UIImage imageNamed:@"tab_weather_hide.png"] forState:UIControlStateNormal];
    [_weatherButton setBackgroundImage:[UIImage imageNamed:@"tab_weather_show.png"] forState:UIControlStateSelected];
    [_weatherButton addTarget:self action:@selector(clickWeatherButton:) forControlEvents:UIControlEventTouchUpInside];
    [_footerView addSubview:_weatherButton];
    
    _nearbyButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _nearbyButton.backgroundColor = [UIColor clearColor];
    _nearbyButton.frame = CGRectMake(_weatherButton.frame.origin.x + _weatherButton.frame.size.width, 0, self.view.frame.size.width / 5, _footerView.frame.size.height);
    [_nearbyButton setBackgroundImage:[UIImage imageNamed:@"tab_nearby_hide.png"] forState:UIControlStateNormal];
    [_nearbyButton setBackgroundImage:[UIImage imageNamed:@"tab_nearby_show.png"] forState:UIControlStateSelected];
    [_nearbyButton addTarget:self action:@selector(clickNearbyButton:) forControlEvents:UIControlEventTouchUpInside];
    [_footerView addSubview:_nearbyButton];
    
    _mineButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _mineButton.backgroundColor = [UIColor clearColor];
    _mineButton.frame = CGRectMake(_nearbyButton.frame.origin.x + _nearbyButton.frame.size.width, 0, self.view.frame.size.width / 5, _footerView.frame.size.height);
    [_mineButton setBackgroundImage:[UIImage imageNamed:@"tab_my_hide.png"] forState:UIControlStateNormal];
    [_mineButton setBackgroundImage:[UIImage imageNamed:@"tab_my_show.png"] forState:UIControlStateSelected];
    [_mineButton addTarget:self action:@selector(clickMineButton:) forControlEvents:UIControlEventTouchUpInside];
    [_footerView addSubview:_mineButton];
    
    if(_homeVC == nil)
    {
        _homeVC = [[HomeViewController alloc] init];
        _homeVC.tabVC = self;
    }
    [self.view addSubview:_homeVC.view];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

@end
