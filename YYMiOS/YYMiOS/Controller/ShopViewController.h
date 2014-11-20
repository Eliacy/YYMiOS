//
//  ShopViewController.h
//  YYMiOS
//
//  Created by lide on 14-10-2.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "BaseViewController.h"
#import <MapKit/MapKit.h>
#import "POIDetail.h"
#import "StarView.h"
#import "ShopDetailView.h"

@interface ShopViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate>
{
    NSInteger       _poiId;
    POIDetail       *_poiDetail;
    
    UIView          *_footerView;
    UIView          *_textBackView;
    UITextField     *_textField;
    UIButton        *_sendButton;
    
    UITableView     *_tableView;
    NSMutableArray  *_dealArray;
    
    UIView          *_tableHeaderView;
    UIImageView     *_logoImageView;
    UILabel         *_nameLabel;
    UIImageView     *_levelImageView;
    StarView        *_starView;
    UIButton        *_reviewButton;
    ShopDetailView  *_shopDetailView;
    
    UIView          *_descriptionBackView;
    UILabel         *_descriptionHeaderLabel;
    UILabel         *_descriptionLabel;
    
    MKMapView       *_mapView;
    UIView          *_floatView;
    UILabel         *_mapLabel;
    
    UIView          *_keywordView;
    UIView          *_topImageView;
}

@property (assign, nonatomic) NSInteger poiId;
@property (retain, nonatomic) POIDetail *poiDetail;

@end
