//
//  NearbyMapViewController.h
//  YYMiOS
//
//  Created by Lide on 14-11-10.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "BaseViewController.h"
#import <MapKit/MapKit.h>
#import "POIAnnotationView.h"

@interface NearbyMapViewController : BaseViewController <MKMapViewDelegate, POIAnnotionViewDelegate>
{
    NSInteger       _index;
    
    MKMapView       *_mapView;
    NSArray         *_nearbyArray;
    
    UIButton        *_prevButton;
    UIButton        *_nextButton;
    
    POIAnnotationView   *_poiAnnotationView;
}

@property (retain, nonatomic) NSArray *nearbyArray;

@end
