//
//  TabViewController.m
//  YYMiOS
//
//  Created by lide on 14-9-22.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "TabViewController.h"

static const CGFloat kDefaultPlaySoundInterval = 3.0;

@interface TabViewController () <IChatManagerDelegate>

@property (retain, nonatomic) NSDate *lastPlaySoundDate;

@end

@implementation TabViewController

@synthesize homeVC = _homeVC;
@synthesize mineVC = _mineVC;

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
    
    [_currentVC viewWillDisappear:YES];
    
    if(_homeVC == nil)
    {
        _homeVC = [[HomeViewController alloc] init];
        _homeVC.tabVC = self;
    }
    [self.view addSubview:_homeVC.view];
    
    _currentVC = _homeVC;
    [_currentVC viewWillAppear:YES];
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
    
    [_currentVC viewWillDisappear:YES];
    
    if(_dynamicVC == nil)
    {
        _dynamicVC = [[DynamicViewController alloc] init];
        _dynamicVC.tabVC = self;
    }
    [self.view addSubview:_dynamicVC.view];
    
    _currentVC = _dynamicVC;
    [_currentVC viewWillAppear:YES];
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
    
    [_currentVC viewWillDisappear:YES];
    
    if(_weatherVC == nil)
    {
        _weatherVC = [[WeatherViewController alloc] init];
        _weatherVC.tabVC = self;
    }
    [self.view addSubview:_weatherVC.view];
    
    _currentVC = _weatherVC;
    [_currentVC viewWillAppear:YES];
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
    
    [_currentVC viewWillDisappear:YES];
    
    if(_nearbyVC == nil)
    {
        _nearbyVC = [[NearbyViewController alloc] init];
        _nearbyVC.tabVC = self;
    }
    [self.view addSubview:_nearbyVC.view];
    
    _currentVC = _nearbyVC;
    [_currentVC viewWillAppear:YES];
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
    
    [_currentVC viewWillDisappear:YES];
    
    if(_mineVC == nil)
    {
        _mineVC = [[MineViewController alloc] init];
        _mineVC.tabVC = self;
    }
    [self.view addSubview:_mineVC.view];
    
    _currentVC = _mineVC;
    [_currentVC viewWillAppear:YES];
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
    
    UIView *line = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, _footerView.frame.size.width, 0.5)] autorelease];
    line.backgroundColor = [UIColor colorWithRed:221.0 / 255.0 green:221.0 / 255.0 blue:221.0 / 255.0 alpha:1.0];
    [_footerView addSubview:line];
    
    if(_homeVC == nil)
    {
        _homeVC = [[HomeViewController alloc] init];
        _homeVC.tabVC = self;
    }
    [self.view addSubview:_homeVC.view];
    
    _currentVC = _homeVC;
    [_currentVC viewWillAppear:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self registerNotifications];
}

-(void)registerNotifications
{
    [self unregisterNotifications];
    
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

-(void)unregisterNotifications
{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(_currentVC != nil)
    {
        [_currentVC viewWillAppear:animated];
    }
    
    [self setupUnreadMessageCount];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if(_currentVC != nil)
    {
        [_currentVC viewWillDisappear:animated];
    }
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

#pragma mark - IChatManagerDelegate

- (void)didUnreadMessagesCountChanged
{
    [self setupUnreadMessageCount];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"RefreshEaseMobMessage"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setupUnreadMessageCount
{
    if([[[EaseMob sharedInstance] chatManager] isLoggedIn])
    {
        NSArray *conversations = [[EaseMob sharedInstance].chatManager conversations];
        NSArray* sorte = [conversations sortedArrayUsingComparator:
                          ^(EMConversation *obj1, EMConversation* obj2){
                              EMMessage *message1 = [obj1 latestMessage];
                              EMMessage *message2 = [obj2 latestMessage];
                              if(message1.timestamp > message2.timestamp) {
                                  return(NSComparisonResult)NSOrderedAscending;
                              }else {
                                  return(NSComparisonResult)NSOrderedDescending;
                              }
                          }];
        
        NSInteger unreadCount = 0;
        
        for(NSInteger i = 0; i < [sorte count]; i++)
        {
            EMConversation *conversation = [sorte objectAtIndex:i];
            unreadCount += [conversation unreadMessagesCount];
        }
        
        if(self.homeVC != nil)
        {
            [self.homeVC refreshMessageCount:unreadCount];
        }
        if(self.mineVC != nil)
        {
            [self.mineVC refreshMessageCount:unreadCount];
        }
    }
}

// 收到消息回调
-(void)didReceiveMessage:(EMMessage *)message
{
#if !TARGET_IPHONE_SIMULATOR
    
    BOOL isAppActivity = [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive;
    
    if(!isAppActivity)
    {
        [self showNotificationWithMessage:message];
    }
    else
    {
        [self playSoundAndVibration];
    }
#endif
}

- (void)playSoundAndVibration{
    NSTimeInterval timeInterval = [[NSDate date]
                                   timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < kDefaultPlaySoundInterval) {
        //如果距离上次响铃和震动时间太短, 则跳过响铃
        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
        return;
    }
    
    //保存最后一次响铃时间
    self.lastPlaySoundDate = [NSDate date];
    
    // 收到消息时，播放音频
    [[EaseMob sharedInstance].deviceManager asyncPlayNewMessageSound];
    // 收到消息时，震动
    [[EaseMob sharedInstance].deviceManager asyncPlayVibration];
}

- (void)showNotificationWithMessage:(EMMessage *)message
{
    //发送本地推送
    UILocalNotification *notification = [[[UILocalNotification alloc] init] autorelease];
    notification.fireDate = [NSDate date]; //触发通知的时间
    notification.alertBody = @"您有一条新消息";
    notification.alertAction = @"打开";
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.soundName = UILocalNotificationDefaultSoundName;
    notification.userInfo = [NSDictionary dictionaryWithObject:message.from forKey:@"chatter"];
    //发送通知
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

@end
