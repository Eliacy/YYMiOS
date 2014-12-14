//
//  POIAnnotation.h
//  YYMiOS
//
//  Created by Lide on 14-11-10.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "LPObject.h"
#import <MapKit/MapKit.h>
#import "POI.h"

@interface POIAnnotation : LPObject <MKAnnotation>

@property (readwrite, nonatomic) CLLocationCoordinate2D coordinate;

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *subtitle;

@property (retain, nonatomic) id poi;
@property (assign, nonatomic) BOOL isDetail;

@end
