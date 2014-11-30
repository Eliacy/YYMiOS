//
//  POIDetail.h
//  YYMiOS
//
//  Created by Lide on 14-11-9.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "LPObject.h"
#import "LPImage.h"

@interface POIDetail : LPObject
{
    NSString    *_address;
    NSString    *_addressOrigin;
    NSString    *_booking;
    NSString    *_businessHours;
    NSArray     *_categoryArray;
    NSString    *_cityName;
    NSString    *_description;
    NSString    *_environment;
    NSArray     *_gateImageArray;
    NSInteger   _poiId;
    NSInteger   _imageCount;
    NSArray     *_keywordArray;
    CGFloat     _latitude;
    CGFloat     _longitude;
    NSString    *_level;
    LPImage     *_logo;
    NSString    *_menu;
    NSString    *_name;
    NSString    *_nameOrigin;
    NSArray     *_paymentArray;
    NSString    *_phone;
    NSInteger   _popular;
    NSInteger   _reviewNum;
    CGFloat     _stars;
    NSString    *_ticket;
    NSArray     *_topImageArray;
    NSString    *_transport;
    BOOL        _favorited;
}

@property (retain, nonatomic) NSString *address;
@property (retain, nonatomic) NSString *addressOrigin;
@property (retain, nonatomic) NSString *booking;
@property (retain, nonatomic) NSString *businessHours;
@property (retain, nonatomic) NSArray *categoryArray;
@property (retain, nonatomic) NSString *cityName;
@property (retain, nonatomic) NSString *description;
@property (retain, nonatomic) NSString *environment;
@property (retain, nonatomic) NSArray *gateImageArray;
@property (assign, nonatomic) NSInteger poiId;
@property (assign, nonatomic) NSInteger imageCount;
@property (retain, nonatomic) NSArray *keywordArray;
@property (assign, nonatomic) CGFloat latitude;
@property (assign, nonatomic) CGFloat longitude;
@property (retain, nonatomic) NSString *level;
@property (retain, nonatomic) LPImage *logo;
@property (retain, nonatomic) NSString *menu;
@property (retain, nonatomic) NSString *name;
@property (retain, nonatomic) NSString *nameOrigin;
@property (retain, nonatomic) NSArray *paymentArray;
@property (retain, nonatomic) NSString *phone;
@property (assign, nonatomic) NSInteger popular;
@property (assign, nonatomic) NSInteger reviewNum;
@property (assign, nonatomic) CGFloat stars;
@property (retain, nonatomic) NSString *ticket;
@property (retain, nonatomic) NSArray *topImageArray;
@property (retain, nonatomic) NSString *transport;
@property (assign, nonatomic) BOOL favorited;

- (id)initWithAttribute:(NSDictionary *)attribute;

+ (void)getPOIListWithPOIId:(NSInteger)POIId
                      brief:(NSInteger)brief
                     offset:(NSInteger)offset
                      limit:(NSInteger)limit
                    keyword:(NSString *)keyword
                       area:(NSInteger)area
                       city:(NSInteger)city
                      range:(NSInteger)range
                   category:(NSInteger)category
                      order:(NSInteger)order
                  longitude:(CGFloat)longitude
                   latitude:(CGFloat)latitude
                    success:(LPObjectSuccessBlock)successBlock
                    failure:(LPObjectFailureBlock)failureBlock;

@end
