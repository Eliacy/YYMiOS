//
//  NearbyMapViewController.m
//  YYMiOS
//
//  Created by Lide on 14-11-10.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "NearbyMapViewController.h"
#import "POI.h"
#import "POIAnnotation.h"
#import "ShopViewController.h"
#import "MKMapView+ZoomLevel.h"

@interface NearbyMapViewController ()

@end

@implementation NearbyMapViewController

@synthesize nearbyArray = _nearbyArray;

- (void)loadView
{
    [super loadView];
    
    _titleLabel.text = @"地图";
    
    _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, _adjustView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - _adjustView.frame.size.height)];
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    
    for(POI *poi in _nearbyArray)
    {
        [_mapView setCenterCoordinate:CLLocationCoordinate2DMake(poi.latitude, poi.longitude) zoomLevel:14 animated:YES];
        
        POIAnnotation *annotation = [[[POIAnnotation alloc] init] autorelease];
        annotation.coordinate = CLLocationCoordinate2DMake(poi.latitude, poi.longitude);
        annotation.title = poi.address;
        annotation.subtitle = @"";
        [_mapView addAnnotation:annotation];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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

#pragma mark - MKMapViewDelegate

//- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
//{
//    for (id<MKAnnotation> currentAnnotation in mapView.annotations) {
//        if (currentAnnotation != mapView.userLocation) {
//            [mapView selectAnnotation:currentAnnotation animated:YES];
//            break;
//        }
//    }
//}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"ShopViewControllerIdentifier"];
    
    view.pinColor = MKPinAnnotationColorRed;
    view.animatesDrop = YES;
    view.canShowCallout = YES;
    view.draggable = YES;
    
    return view;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    POIAnnotation *annotation = (POIAnnotation *)view.annotation;
    POI *poi = [_nearbyArray objectAtIndex:[_mapView.annotations indexOfObject:annotation]];
    
    ShopViewController *shopVC = [[[ShopViewController alloc] init] autorelease];
    shopVC.poiId = poi.poiId;
    [self.navigationController pushViewController:shopVC animated:YES];
}

@end
