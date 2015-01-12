//
//  AppDelegate.m
//  YYMiOS
//
//  Created by lide on 14-9-18.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "TabViewController.h"
#import "WeiboSDK.h"
#import "Categories.h"
#import "WXApi.h"

#define WEIXINKEY   @"wx9ecdcdfe681ca533"   //微信appid
#define WEIBOKEY    @"2377894405"           //微博appid

@interface AppDelegate () <IChatManagerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSTimeInterval startTimeStamp = [[NSDate date] timeIntervalSince1970];
    
    [WXApi registerApp:WEIXINKEY];
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:WEIBOKEY];
    
    //生成应用版本号
    NSDictionary *dict = [[NSBundle mainBundle] infoDictionary];
    NSString *versionString = [dict objectForKey:@"CFBundleShortVersionString"];
    [[NSUserDefaults standardUserDefaults] setObject:versionString forKey:@"AppVersion"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //Push
    [self registerRemoteNotification];
    
    NSString *apnsCertName = nil;
#if DEBUG
    apnsCertName = @"youyoumm_dev";
#else
    apnsCertName = @"youyoumm_pro";
#endif
    [[EaseMob sharedInstance] registerSDKWithAppKey:@"youyoumm#youyoumm" apnsCertName:apnsCertName];
    
#if DEBUG
    [[EaseMob sharedInstance] enableUncaughtExceptionHandler];
#endif
    [[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
    __block double systemTimeStamp = [[NSDate date] timeIntervalSince1970];
    
    [[LPAPIClient sharedAPIClient] getServerTimeStampSuccess:^(id respondObject) {
        
        if([respondObject objectForKey:@"data"])
        {
            respondObject = [respondObject objectForKey:@"data"];
        }
        
        if([respondObject objectForKey:@"timestamp"] && ![[respondObject objectForKey:@"timestamp"] isEqual:[NSNull null]])
        {
            double serverTimeStamp = [[respondObject objectForKey:@"timestamp"] doubleValue];
            double offsetTimpStamp = serverTimeStamp - systemTimeStamp;
            NSLog(@"%lf", offsetTimpStamp);
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithDouble:offsetTimpStamp] forKey:@"OffsetTimeStamp"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
    } failure:^(NSError *error) {
        
    }];
    
    // 让启动画面停留足够长的时间，方便用户看清楚：
    double timeToSleep = 1.8 - ([[NSDate date] timeIntervalSince1970] - startTimeStamp);
    [NSThread sleepForTimeInterval:timeToSleep];
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"login_flag"] && [[[NSUserDefaults standardUserDefaults] objectForKey:@"login_flag"] boolValue])
    {
        [self lanuchTabViewContrller];
    }
    else
    {
        [self lanuchLoginViewController];
    }
    
    [[LocationManager sharedManager] askForLocationPrivacy];
    
    return YES;
}

- (void)registerRemoteNotification{
    
#if !TARGET_IPHONE_SIMULATOR
    UIApplication *application = [UIApplication sharedApplication];
    
    //iOS8 注册APNS
#ifdef __IPHONE_8_0
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    else
    {
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeSound |
        UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }
#else
    {
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeSound |
        UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }
#endif
    
    
#endif
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [[EaseMob sharedInstance] applicationWillResignActive:application];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[EaseMob sharedInstance] applicationDidEnterBackground:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[EaseMob sharedInstance] applicationWillEnterForeground:application];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[EaseMob sharedInstance] applicationDidBecomeActive:application];
    
    //绑定环信ID，登录环信
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"login_flag"] boolValue])
    {
        if([[[EaseMob sharedInstance] chatManager] isLoggedIn])
        {
            
        }
        else
        {
            NSLog(@"%@, %@", [[User sharedUser] emUsername], [[User sharedUser] emPassword]);
            
            [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:[[User sharedUser] emUsername]
                                                                password:[[User sharedUser] emPassword]
                                                              completion:^(NSDictionary *loginInfo, EMError *error) {
                                                                  
                                                              } onQueue:nil];
        }
    }
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"SystemTimeStamp"] == nil)
    {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]] forKey:@"SystemTimeStamp"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
        double timeStamp = [[[NSUserDefaults standardUserDefaults] objectForKey:@"SystemTimeStamp"] doubleValue];
        if([[NSDate date] timeIntervalSince1970] - timeStamp > 86400)
        {
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]] forKey:@"SystemTimeStamp"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    
    [[LPAPIClient sharedAPIClient] getLowestVersionSuccess:^(id respondObject) {
        
        if([respondObject objectForKey:@"data"])
        {
            respondObject = [respondObject objectForKey:@"data"];
            if([respondObject objectForKey:@"minimal_available_version"] && ![[respondObject objectForKey:@"minimal_available_version"] isEqual:[NSNull null]])
            {
                NSInteger lowestVersion = [[respondObject objectForKey:@"minimal_available_version"] integerValue];
                NSDictionary *dict = [[NSBundle mainBundle] infoDictionary];
                if([[dict objectForKey:@"CFBundleShortVersionString"] floatValue] < lowestVersion)
                {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"请下载最新版本" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertView show];
                }
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[EaseMob sharedInstance] applicationWillTerminate:application];
}

#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}
#endif

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [[EaseMob sharedInstance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [[EaseMob sharedInstance] application:application didReceiveRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    [[EaseMob sharedInstance] application:application didReceiveLocalNotification:notification];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    [[EaseMob sharedInstance] application:application didFailToRegisterForRemoteNotificationsWithError:error];
}

#pragma mark - public

- (void)lanuchLoginViewController
{
    LoginViewController *loginVC = [[[LoginViewController alloc] init] autorelease];
    UINavigationController *navigationController = [[[UINavigationController alloc] initWithRootViewController:loginVC] autorelease];
    navigationController.navigationBarHidden = YES;
    self.window.rootViewController = navigationController;
}

- (void)lanuchTabViewContrller
{
    TabViewController *tabVC = [[[TabViewController alloc] init] autorelease];
    UINavigationController *navigationController = [[[UINavigationController alloc] initWithRootViewController:tabVC] autorelease];
    navigationController.navigationBarHidden = YES;
    self.window.rootViewController = navigationController;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.baidu.com"]];
}

@end
