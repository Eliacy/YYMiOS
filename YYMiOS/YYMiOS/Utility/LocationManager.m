//
//  LocationManager.m
//  YYMiOS
//
//  Created by Lide on 14/12/15.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "LocationManager.h"

@implementation LocationManager

@synthesize delegate = _delegate;
@synthesize location = _location;

#pragma mark - public
static id sharedManager = nil;
+ (id)sharedManager
{
    @synchronized(sharedManager){
        if(sharedManager == nil)
        {
            sharedManager = [[self alloc] init];
        }
    }
    
    return sharedManager;
}

- (id)init
{
    self = [super init];
    if(self != nil)
    {
        _manager = [[CLLocationManager alloc] init];
        _manager.delegate = self;
    }
    
    return self;
}

- (void)askForLocationPrivacy
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [_manager requestWhenInUseAuthorization];
    }
}

- (void)startUpdatingLocation
{
    [_manager startUpdatingLocation];
}

- (void)stopUpdatingLocation
{
    [_manager stopUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if(locations && [locations count] > 0)
    {
        self.location = [locations objectAtIndex:0];
        
        if(_delegate && [_delegate respondsToSelector:@selector(locationManager:didUpdateLocations:)])
        {
            [_delegate locationManager:manager didUpdateLocations:locations];
        }
    }
}

@end
