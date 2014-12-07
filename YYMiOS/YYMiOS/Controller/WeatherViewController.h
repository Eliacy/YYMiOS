//
//  WeatherViewController.h
//  YYMiOS
//
//  Created by lide on 14-9-22.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "BaseViewController.h"
#import "Weather.h"

@class TabViewController;

@interface WeatherViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>
{
    TabViewController   *_tabVC;
    Weather             *_weather;
    
    UIImageView         *_backgroundImageView;
    UITableView         *_tableView;
}

@property (assign, nonatomic) TabViewController *tabVC;
@property (retain, nonatomic) Weather *weather;

@end
