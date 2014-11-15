//
//  POIAnnotationView.h
//  YYMiOS
//
//  Created by Lide on 14/11/16.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "POI.h"
#import "StarView.h"

@protocol POIAnnotionViewDelegate;

@interface POIAnnotationView : MKAnnotationView
{
    POI             *_poi;
    id<POIAnnotionViewDelegate> _delegate;
    
    UIView          *_backView;
    UIImageView     *_avatarImageView;
    UILabel         *_nameLabel;
    UIImageView     *_levelImageView;
    StarView        *_starView;
    UIButton        *_reviewButton;
    UILabel         *_distanceLabel;
    UIImageView     *_locationImageView;
    UILabel         *_locationLabel;
    UIImageView     *_keywordImageView;
    UILabel         *_keywordLabel;
    
    UIScrollView    *_scrollView;
}

@property (retain, nonatomic) POI *poi;
@property (assign, nonatomic) id<POIAnnotionViewDelegate> delegate;

@end

@protocol POIAnnotionViewDelegate <NSObject>

- (void)poiAnnotionViewDidTapBackView:(POIAnnotationView *)poiAnnotionView;

@end
