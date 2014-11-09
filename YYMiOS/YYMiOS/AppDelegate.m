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

#import "Categories.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    __block double systemTimeStamp = [[NSDate date] timeIntervalSince1970];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithDouble:systemTimeStamp] forKey:@"SystemTimeStamp"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
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
            
//            [[LPAPIClient sharedAPIClient] createCommentWithDealId:2995
//                                                         articleId:0
//                                                            userId:338
//                                                            atList:@"321 338"
//                                                           content:@"what's up\n奇怪"
//                                                           success:^(id respondObject) {
//                                                               
//                                                           } failure:^(NSError *error) {
//                                                               
//                                                           }];
        }
        
    } failure:^(NSError *error) {
        
    }];
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"login_flag"] && [[[NSUserDefaults standardUserDefaults] objectForKey:@"login_flag"] boolValue])
    {
        [self lanuchTabViewContrller];
    }
    else
    {
        [self lanuchLoginViewController];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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

@end
