//
//  NearbyMapViewController.h
//  YYMiOS
//
//  Created by Lide on 14-11-10.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "BaseViewController.h"
#import <MapKit/MapKit.h>

@interface NearbyMapViewController : BaseViewController <MKMapViewDelegate>
{
    MKMapView       *_mapView;
    NSArray         *_nearbyArray;
}

@property (retain, nonatomic) NSArray *nearbyArray;

@end
