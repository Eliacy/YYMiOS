//
//  TabViewController.h
//  YYMiOS
//
//  Created by lide on 14-9-22.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "BaseViewController.h"
#import "HomeViewController.h"
#import "DynamicViewController.h"
#import "WeatherViewController.h"
#import "NearbyViewController.h"
#import "MineViewController.h"

@interface TabViewController : BaseViewController
{
    UIView      *_footerView;
    
    UIButton    *_homeButon;
    UIButton    *_dynamicButton;
    UIButton    *_weatherButton;
    UIButton    *_nearbyButton;
    UIButton    *_mineButton;
    
    HomeViewController      *_homeVC;
    DynamicViewController   *_dynamicVC;
    WeatherViewController   *_weatherVC;
    NearbyViewController    *_nearbyVC;
    MineViewController      *_mineVC;
    
    UIViewController        *_currentVC;
}

@property (assign, nonatomic) HomeViewController *homeVC;
@property (assign, nonatomic) MineViewController *mineVC;

@end
