//
//  LocationManager.h
//  YYMiOS
//
//  Created by Lide on 14/12/15.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol LocationManagerDelegate;

@interface LocationManager : NSObject <CLLocationManagerDelegate>
{
    id<LocationManagerDelegate> _delegate;
    
    CLLocationManager   *_manager;
    CLLocation          *_location;
}

@property (assign, nonatomic) id<LocationManagerDelegate> delegate;
@property (retain, nonatomic) CLLocation *location;

+ (id)sharedManager;

- (void)askForLocationPrivacy;
- (void)startUpdatingLocation;
- (void)stopUpdatingLocation;

@end

@protocol LocationManagerDelegate <NSObject>

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations;

@end
