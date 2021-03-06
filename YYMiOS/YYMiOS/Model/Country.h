//
//  Country.h
//  YYMiOS
//
//  Created by lide on 14-10-15.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "LPObject.h"

@interface Country : LPObject
{
    NSInteger       _countryId;
    NSInteger       _defaultCityId;
    NSString        *_countryName;
    NSInteger       _countryOrder;
    NSMutableArray  *_cityArray;
}

@property (assign, nonatomic) NSInteger countryId;
@property (assign, nonatomic) NSInteger defaultCityId;
@property (retain, nonatomic) NSString *countryName;
@property (assign, nonatomic) NSInteger countryOrder;
@property (retain, nonatomic) NSMutableArray *cityArray;

- (id)initWithAttribute:(NSDictionary *)attribute;

+ (void)getCountryListWithCountryId:(NSInteger)countryId
                          longitude:(float)longitude
                           latitude:(float)latitude
                              success:(LPObjectSuccessBlock)successBlock
                              failure:(LPObjectFailureBlock)failureBlock;

@end
