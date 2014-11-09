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

@interface ShopViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate>
{
    NSInteger       _poiId;
    POIDetail       *_poiDetail;
    
    UIView          *_footerView;
    UITextField     *_textField;
    UIButton        *_sendButton;
    
    UITableView     *_tableView;
    NSMutableArray  *_dealArray;
    
    UIView          *_tableHeaderView;
    UIImageView     *_logoImageView;
    UILabel         *_nameLabel;
    UILabel         *_categoryLabel;
    UILabel         *_environmentLabel;
    UILabel         *_paymentLabel;
    UILabel         *_menuLabel;
    UILabel         *_ticketLabel;
    UILabel         *_bookingLabel;
    UILabel         *_businessHoursLabel;
    UILabel         *_phoneLabel;
    MKMapView       *_mapView;
    UIView          *_floatView;
    UILabel         *_mapLabel;
}

@property (assign, nonatomic) NSInteger poiId;
@property (retain, nonatomic) POIDetail *poiDetail;

@end
