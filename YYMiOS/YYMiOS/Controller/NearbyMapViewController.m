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

#pragma mark - private

- (void)clickPrevButton:(id)sender
{
//    if(_index > 0)
//    {
//        _index--;
//        POI *poi = [_nearbyArray objectAtIndex:_index];
//        [_mapView setCenterCoordinate:CLLocationCoordinate2DMake(poi.latitude, poi.longitude) zoomLevel:14 animated:YES];
//        
//        POIAnnotation *annotation = [[[POIAnnotation alloc] init] autorelease];
//        annotation.coordinate = CLLocationCoordinate2DMake(poi.latitude, poi.longitude);
//        annotation.title = poi.address;
//        annotation.subtitle = @"";
//        annotation.poi = poi;
//        annotation.isDetail = NO;
//        [_mapView removeAnnotations:_mapView.annotations];
//        [_mapView addAnnotation:annotation];
//        [_mapView selectAnnotation:annotation animated:YES];
//    }
}

- (void)clickNextButton:(id)sender
{
//    if(_index < [_nearbyArray count] - 1)
//    {
//        _index++;
//        POI *poi = [_nearbyArray objectAtIndex:_index];
//        [_mapView setCenterCoordinate:CLLocationCoordinate2DMake(poi.latitude, poi.longitude) zoomLevel:14 animated:YES];
//        
//        POIAnnotation *annotation = [[[POIAnnotation alloc] init] autorelease];
//        annotation.coordinate = CLLocationCoordinate2DMake(poi.latitude, poi.longitude);
//        annotation.title = poi.address;
//        annotation.subtitle = @"";
//        annotation.poi = poi;
//        annotation.isDetail = NO;
//        [_mapView removeAnnotations:_mapView.annotations];
//        [_mapView addAnnotation:annotation];
//        [_mapView selectAnnotation:annotation animated:YES];
//    }
}

#pragma mark - super

- (id)init
{
    self = [super init];
    if(self != nil)
    {
        _index = 0;
    }
    
    return self;
}

- (void)loadView
{
    [super loadView];
    
    _titleLabel.text = @"地图";
    
    _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, _adjustView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - _adjustView.frame.size.height)];
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    
    if(_nearbyArray && [_nearbyArray count] > 0)
    {
        for(POI *poi in _nearbyArray)
        {
            [_mapView setCenterCoordinate:CLLocationCoordinate2DMake(poi.latitude, poi.longitude) zoomLevel:14 animated:YES];
            
            POIAnnotation *annotation = [[[POIAnnotation alloc] init] autorelease];
            annotation.coordinate = CLLocationCoordinate2DMake(poi.latitude, poi.longitude);
            annotation.title = poi.address;
            annotation.subtitle = @"";
            annotation.poi = poi;
            annotation.isDetail = NO;
            [_mapView addAnnotation:annotation];
        }
    }
    
    _prevButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _prevButton.frame = CGRectMake(self.view.frame.size.width / 2 - 50, self.view.frame.size.height - 75 - 30, 50, 30);
    _prevButton.backgroundColor = [UIColor whiteColor];
    [_prevButton setTitle:@"prev" forState:UIControlStateNormal];
    [_prevButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    _prevButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [_prevButton addTarget:self action:@selector(clickPrevButton:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_prevButton];
    
    _nextButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _nextButton.frame = CGRectMake(self.view.frame.size.width / 2, self.view.frame.size.height - 75 - 30, 50, 30);
    _nextButton.backgroundColor = [UIColor whiteColor];
    [_nextButton setTitle:@"next" forState:UIControlStateNormal];
    [_nextButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    _nextButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [_nextButton addTarget:self action:@selector(clickNextButton:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_nextButton];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    if([_mapView.annotations count] > 0)
//    {
//        [_mapView selectAnnotation:[_mapView.annotations lastObject] animated:YES];
//    }
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
        
        if(_poiAnnotationView.poi.keywordArray && [_poiAnnotationView.poi.keywordArray isKindOfClass:[NSArray class]] && [_poiAnnotationView.poi.keywordArray count] > 0)
        {
            _poiAnnotationView.keywordImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%i.png", (int)_index % 6 + 1]];
        }
        else
        {
            _poiAnnotationView.keywordImageView.image = nil;
        }
        
        return _poiAnnotationView;
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
    POI *poi = poiAnnotionView.poi;
    
    ShopViewController *shopVC = [[[ShopViewController alloc] init] autorelease];
    shopVC.poiId = poi.poiId;
    [self.navigationController pushViewController:shopVC animated:YES];
}

@end
