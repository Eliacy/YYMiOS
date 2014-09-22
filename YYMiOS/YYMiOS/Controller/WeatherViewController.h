//
//  WeatherViewController.h
//  YYMiOS
//
//  Created by lide on 14-9-22.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "BaseViewController.h"

@class TabViewController;

@interface WeatherViewController : BaseViewController
{
    TabViewController   *_tabVC;
}

@property (assign, nonatomic) TabViewController *tabVC;

@end
