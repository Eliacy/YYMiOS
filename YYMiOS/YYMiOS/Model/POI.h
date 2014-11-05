//
//  Nearby.h
//  YYMiOS
//
//  Created by lide on 14-9-28.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "LPObject.h"
#import "LPImage.h"

@interface POI : LPObject
{
    NSString    *_address;
    NSInteger   _poiId;
    NSArray     *_keywordArray;
    CGFloat     _latitude;
    CGFloat     _longitude;
    NSString    *_level;
    LPImage     *_logo;
    NSString    *_name;
    NSInteger   _popular;
    NSInteger   _reviewNum;
    CGFloat     _stars;
    NSArray     *_topImageArray;
}

@property (retain, nonatomic) NSString *address;
@property (assign, nonatomic) NSInteger poiId;
@property (retain, nonatomic) NSArray *keywordArray;
@property (assign, nonatomic) CGFloat latitude;
@property (assign, nonatomic) CGFloat longitude;
@property (retain, nonatomic) NSString *level;
@property (retain, nonatomic) LPImage *logo;
@property (retain, nonatomic) NSString *name;
@property (assign, nonatomic) NSInteger popular;
@property (assign, nonatomic) NSInteger reviewNum;
@property (assign, nonatomic) CGFloat stars;
@property (retain, nonatomic) NSArray *topImageArray;

- (id)initWithAttribute:(NSDictionary *)attribute;

+ (void)getPOIListWithOffset:(NSInteger)offset
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
