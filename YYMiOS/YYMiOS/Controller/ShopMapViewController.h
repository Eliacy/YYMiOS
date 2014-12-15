//
//  ShopMapViewController.h
//  YYMiOS
//
//  Created by Lide on 14/12/14.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "BaseViewController.h"
#import "POIDetail.h"
#import <MapKit/MapKit.h>
#import "POIAnnotationView.h"
#import "POIAnnotation.h"

@interface ShopMapViewController : BaseViewController <POIAnnotionViewDelegate>
{
    POIDetail       *_poiDetail;
    
    UIButton        *_navigationButton;
    MKMapView       *_mapView;
    UIButton        *_locateButton;
    
    POIAnnotationView   *_poiAnnotationView;
    POIAnnotation   *_selfAnnotation;
}

@property (retain, nonatomic) POIDetail *poiDetail;

@end
