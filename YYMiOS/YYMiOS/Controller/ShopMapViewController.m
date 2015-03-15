//
//  ShopMapViewController.m
//  YYMiOS
//
//  Created by Lide on 14/12/14.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "ShopMapViewController.h"
#import "MKMapView+ZoomLevel.h"
#import <MapKit/MapKit.h>

@interface ShopMapViewController () <MKMapViewDelegate, LocationManagerDelegate>

@end

@implementation ShopMapViewController

@synthesize poiDetail = _poiDetail;

#pragma mark - private
#pragma mark - 点击导航按钮
- (void)clickNavigationButton:(id)sender
{
    //获取当前位置
    MKMapItem *mylocation = [MKMapItem mapItemForCurrentLocation];
    
    //当前经维度
    float currentLatitude = mylocation.placemark.location.coordinate.latitude;
    float currentLongitude = mylocation.placemark.location.coordinate.longitude;
    CLLocationCoordinate2D coords1 = CLLocationCoordinate2DMake(currentLatitude,currentLongitude);
    
    //目的地位置
    CLLocationCoordinate2D coords2 = CLLocationCoordinate2DMake(_poiDetail.latitude,_poiDetail.longitude);
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 6.0){
        
        // ios6以下，调用google map
        NSString *urlString = [[NSString alloc] initWithFormat:@"http://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f&dirfl=d", coords1.latitude,coords1.longitude,coords2.latitude,coords2.longitude];
        NSURL *aURL = [NSURL URLWithString:urlString];
        //打开网页google地图
        [[UIApplication sharedApplication] openURL:aURL];
        
    }else{
        // 直接调用ios自己带的apple map
        //起点
        MKMapItem *currentLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coords1 addressDictionary:nil]];
        //目的地的位置
        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coords2 addressDictionary:nil]];
        toLocation.name = _poiDetail.addressOrigin;
        //设置苹果地图相关数据
        NSArray *items = [NSArray arrayWithObjects:currentLocation, toLocation, nil];
        NSDictionary *options = @{ MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsMapTypeKey: [NSNumber numberWithInteger:MKMapTypeStandard], MKLaunchOptionsShowsTrafficKey:@YES };
        //打开苹果自身地图应用，并呈现特定的item
        [MKMapItem openMapsWithItems:items launchOptions:options];
    }
    
}

- (void)clickLocateButton:(id)sender
{
    [_mapView setCenterCoordinate:_selfAnnotation.coordinate zoomLevel:13 animated:YES];
}

#pragma mark - super

- (void)loadView
{
    [super loadView];
    
    _titleLabel.text = _poiDetail.name;
    
    _navigationButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _navigationButton.frame = CGRectMake(_headerView.frame.size.width - 2 - 40, 2, 40, 40);
    _navigationButton.backgroundColor = [UIColor clearColor];
    [_navigationButton setTitle:@"导航" forState:UIControlStateNormal];
    [_navigationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _navigationButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    [_navigationButton addTarget:self action:@selector(clickNavigationButton:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:_navigationButton];
    
    _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, _adjustView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - _adjustView.frame.size.height)];
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    
    _locateButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _locateButton.frame = CGRectMake(15, self.view.frame.size.height - 15 - 40, 40, 40);
    _locateButton.backgroundColor = [UIColor clearColor];
    [_locateButton setBackgroundImage:[UIImage imageNamed:@"btn_locate.png"] forState:UIControlStateNormal];
    [_locateButton addTarget:self action:@selector(clickLocateButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_locateButton];
    
    [_mapView setCenterCoordinate:CLLocationCoordinate2DMake(_poiDetail.latitude, _poiDetail.longitude) zoomLevel:14 animated:YES];
    
    POIAnnotation *annotation = [[[POIAnnotation alloc] init] autorelease];
    annotation.coordinate = CLLocationCoordinate2DMake(_poiDetail.latitude, _poiDetail.longitude);
    annotation.title = _poiDetail.address;
    annotation.subtitle = @"";
    annotation.poi = _poiDetail;
    annotation.isDetail = NO;
    [_mapView addAnnotation:annotation];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[LocationManager sharedManager] setDelegate:self];
    [[LocationManager sharedManager] startUpdatingLocation];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[LocationManager sharedManager] setDelegate:nil];
    [[LocationManager sharedManager] stopUpdatingLocation];
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

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if([(POIAnnotation *)annotation isDetail])
    {
        if(_poiAnnotationView == nil)
        {
            _poiAnnotationView = [[POIAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"NearbyMapViewControllerDetailIdentifier"];
            _poiAnnotationView.delegate = self;
        }
        
        [_poiAnnotationView setPoi:[(POIAnnotation *)annotation poi]];
        _poiAnnotationView.transform = CGAffineTransformMake(1, 0, 0, 1, 0, -_poiAnnotationView.frame.size.height / 2 - 20);
        
        return _poiAnnotationView;
    }
    else if(annotation == _selfAnnotation)
    {
        MKPinAnnotationView *view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"ShopMapViewControllerIdentifier"];
        if(view == nil)
        {
            view = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"ShopMapViewControllerIdentifier"] autorelease];
        }
        view.pinColor = MKPinAnnotationColorGreen;
        
        return view;
    }
    else
    {
        MKAnnotationView *view = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"NearbyMapViewControllerIdentifier"];
        if(view == nil)
        {
            view = [[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"NearbyMapViewControllerIdentifier"] autorelease];
        }
        view.image = [UIImage imageNamed:@"map_location.png"];
        
        return view;
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    if (_poiAnnotationView && ![view isKindOfClass:[POIAnnotationView class]]) {
        if (_poiAnnotationView.annotation.coordinate.latitude == view.annotation.coordinate.latitude &&
            _poiAnnotationView.annotation.coordinate.longitude == view.annotation.coordinate.longitude)
        {
            [_mapView removeAnnotation:_poiAnnotationView.annotation];
            [_poiAnnotationView release];
            _poiAnnotationView = nil;
        }
    }
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if([view isKindOfClass:[MKPinAnnotationView class]])
    {
        return;
    }
    
    POI *poi = [(POIAnnotation *)view.annotation poi];
    
    [_mapView setCenterCoordinate:CLLocationCoordinate2DMake(poi.latitude, poi.longitude) zoomLevel:14 animated:YES];
    
    POIAnnotation *annotation = [[[POIAnnotation alloc] init] autorelease];
    annotation.coordinate = CLLocationCoordinate2DMake(poi.latitude, poi.longitude);
    annotation.title = poi.address;
    annotation.subtitle = @"";
    annotation.poi = poi;
    annotation.isDetail = YES;
    [_mapView addAnnotation:annotation];
}

#pragma mark - POIAnnotionViewDelegate

- (void)poiAnnotionViewDidTapBackView:(POIAnnotationView *)poiAnnotionView
{

}

#pragma mark - LocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if(_selfAnnotation == nil)
    {
        _selfAnnotation = [[POIAnnotation alloc] init];
        
        _selfAnnotation.subtitle = @"";
        _selfAnnotation.isDetail = NO;
    }
    
    CLLocation *location = [locations objectAtIndex:0];
    _selfAnnotation.coordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
    [_mapView addAnnotation:_selfAnnotation];
}

@end
