//
//  POIDetail.m
//  YYMiOS
//
//  Created by Lide on 14-11-9.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "POIDetail.h"

@implementation POIDetail

@synthesize address = _address;
@synthesize addressOrigin = _addressOrigin;
@synthesize booking = _booking;
@synthesize businessHours = _businessHours;
@synthesize categoryArray = _categoryArray;
@synthesize cityName = _cityName;
@synthesize description = _description;
@synthesize environment = _environment;
@synthesize gateImageArray = _gateImageArray;
@synthesize poiId = _poiId;
@synthesize imageCount = _imageCount;
@synthesize keywordArray = _keywordArray;
@synthesize latitude = _latitude;
@synthesize longitude = _longitude;
@synthesize level = _level;
@synthesize logo = _logo;
@synthesize menu = _menu;
@synthesize name = _name;
@synthesize nameOrigin = _nameOrigin;
@synthesize paymentArray = _paymentArray;
@synthesize phone = _phone;
@synthesize popular = _popular;
@synthesize reviewNum = _reviewNum;
@synthesize stars = _stars;
@synthesize ticket = _ticket;
@synthesize topImageArray = _topImageArray;
@synthesize transport = _transport;

- (id)initWithAttribute:(NSDictionary *)attribute
{
    self = [super init];
    if(self != nil)
    {
        if(attribute != nil)
        {
            if([attribute objectForKey:@"address"] && ![[attribute objectForKey:@"address"] isEqual:[NSNull null]])
            {
                self.address = [attribute objectForKey:@"address"];
            }
            if([attribute objectForKey:@"address_orig"] && ![[attribute objectForKey:@"address_orig"] isEqual:[NSNull null]])
            {
                self.addressOrigin = [attribute objectForKey:@"address_orig"];
            }
            if([attribute objectForKey:@"booking"] && ![[attribute objectForKey:@"booking"] isEqual:[NSNull null]])
            {
                self.booking = [attribute objectForKey:@"booking"];
            }
            if([attribute objectForKey:@"business_hours"] && ![[attribute objectForKey:@"business_hours"] isEqual:[NSNull null]])
            {
                self.businessHours = [attribute objectForKey:@"business_hours"];
            }
            if([attribute objectForKey:@"categories"] && ![[attribute objectForKey:@"categories"] isEqual:[NSNull null]])
            {
                NSArray *array = [attribute objectForKey:@"categories"];
                if(array && [array isKindOfClass:[NSArray class]] && [array count] > 0)
                {
                    self.categoryArray = array;
                }
            }
            if([attribute objectForKey:@"city_name"] && ![[attribute objectForKey:@"city_name"] isEqual:[NSNull null]])
            {
                self.cityName = [attribute objectForKey:@"city_name"];
            }
            if([attribute objectForKey:@"description"] && ![[attribute objectForKey:@"description"] isEqual:[NSNull null]])
            {
                self.description = [attribute objectForKey:@"description"];
            }
            if([attribute objectForKey:@"environment"] && ![[attribute objectForKey:@"environment"] isEqual:[NSNull null]])
            {
                self.environment = [attribute objectForKey:@"environment"];
            }
            if([attribute objectForKey:@"gate_images"] && ![[attribute objectForKey:@"gate_images"] isEqual:[NSNull null]])
            {
                NSArray *array = [attribute objectForKey:@"gate_images"];
                NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:0];
                if(array && [array isKindOfClass:[NSArray class]] && [array count] > 0)
                {
                    for(NSDictionary *dictionary in array)
                    {
                        LPImage *image = [[[LPImage alloc] initWithAttribute:dictionary] autorelease];
                        [mutableArray addObject:image];
                    }
                }
                self.gateImageArray = mutableArray;
            }
            if([attribute objectForKey:@"id"] && ![[attribute objectForKey:@"id"] isEqual:[NSNull null]])
            {
                self.poiId = [[attribute objectForKey:@"id"] integerValue];
            }
            if([attribute objectForKey:@"images_num"] && ![[attribute objectForKey:@"images_num"] isEqual:[NSNull null]])
            {
                self.imageCount = [[attribute objectForKey:@"images_num"] integerValue];
            }
            if([attribute objectForKey:@"keywords"] && ![[attribute objectForKey:@"keywords"] isEqual:[NSNull null]])
            {
                NSArray *array = [attribute objectForKey:@"keywords"];
                if(array && [array isKindOfClass:[NSArray class]] && [array count] > 0)
                {
                    self.keywordArray = array;
                }
            }
            if([attribute objectForKey:@"latitude"] && ![[attribute objectForKey:@"latitude"] isEqual:[NSNull null]])
            {
                self.latitude = [[attribute objectForKey:@"latitude"] doubleValue];
            }
            if([attribute objectForKey:@"longitude"] && ![[attribute objectForKey:@"longitude"] isEqual:[NSNull null]])
            {
                self.longitude = [[attribute objectForKey:@"longitude"] doubleValue];
            }
            if([attribute objectForKey:@"level"] && ![[attribute objectForKey:@"level"] isEqual:[NSNull null]])
            {
                self.level = [attribute objectForKey:@"level"];
            }
            if([attribute objectForKey:@"logo"] && ![[attribute objectForKey:@"logo"] isEqual:[NSNull null]])
            {
                NSDictionary *dictionary = [attribute objectForKey:@"logo"];
                if(dictionary && [dictionary isKindOfClass:[NSDictionary class]])
                {
                    LPImage *image = [[[LPImage alloc] initWithAttribute:dictionary] autorelease];
                    self.logo = image;
                }
            }
            if([attribute objectForKey:@"menu"] && ![[attribute objectForKey:@"menu"] isEqual:[NSNull null]])
            {
                self.menu = [attribute objectForKey:@"menu"];
            }
            if([attribute objectForKey:@"name"] && ![[attribute objectForKey:@"name"] isEqual:[NSNull null]])
            {
                self.name = [attribute objectForKey:@"name"];
            }
            if([attribute objectForKey:@"name_orig"] && ![[attribute objectForKey:@"name_orig"] isEqual:[NSNull null]])
            {
                self.nameOrigin = [attribute objectForKey:@"name_orig"];
            }
            if([attribute objectForKey:@"payment"] && ![[attribute objectForKey:@"payment"] isEqual:[NSNull null]])
            {
                NSArray *array = [attribute objectForKey:@"payment"];
                if(array && [array isKindOfClass:[NSArray class]] && [array count] > 0)
                {
                    self.paymentArray = array;
                }
            }
            if([attribute objectForKey:@"phone"] && ![[attribute objectForKey:@"phone"] isEqual:[NSNull null]])
            {
                self.phone = [attribute objectForKey:@"phone"];
            }
            if([attribute objectForKey:@"popular"] && ![[attribute objectForKey:@"popular"] isEqual:[NSNull null]])
            {
                self.popular = [[attribute objectForKey:@"popular"] integerValue];
            }
            if([attribute objectForKey:@"review_num"] && ![[attribute objectForKey:@"review_num"] isEqual:[NSNull null]])
            {
                self.reviewNum = [[attribute objectForKey:@"review_num"] integerValue];
            }
            if([attribute objectForKey:@"stars"] && ![[attribute objectForKey:@"stars"] isEqual:[NSNull null]])
            {
                self.stars = [[attribute objectForKey:@"stars"] floatValue];
            }
            if([attribute objectForKey:@"ticket"] && ![[attribute objectForKey:@"ticket"] isEqual:[NSNull null]])
            {
                self.ticket = [attribute objectForKey:@"ticket"];
            }
            if([attribute objectForKey:@"top_images"] && ![[attribute objectForKey:@"top_images"] isEqual:[NSNull null]])
            {
                NSArray *array = [attribute objectForKey:@"top_images"];
                NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:0];
                if(array && [array isKindOfClass:[NSArray class]] && [array count] > 0)
                {
                    for(NSDictionary *dictionary in array)
                    {
                        LPImage *image = [[[LPImage alloc] initWithAttribute:dictionary] autorelease];
                        [mutableArray addObject:image];
                    }
                }
                self.topImageArray = mutableArray;
            }
            if([attribute objectForKey:@"transport"] && ![[attribute objectForKey:@"transport"] isEqual:[NSNull null]])
            {
                self.transport = [attribute objectForKey:@"transport"];
            }
        }
    }
    
    return self;
}

+ (NSArray *)parseFromeDictionary:(NSDictionary *)dictionary
{
    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:0];
    
    if(dictionary && [dictionary isKindOfClass:[NSDictionary class]])
    {
        if([dictionary objectForKey:@"data"])
        {
            dictionary = [dictionary objectForKey:@"data"];
        }
        
        if([dictionary isKindOfClass:[NSArray class]])
        {
            for(NSDictionary *attribute in (NSArray *)dictionary)
            {
                POIDetail *poiDetail = [[POIDetail alloc] initWithAttribute:attribute];
                [mutableArray addObject:poiDetail];
                [poiDetail release];
            }
        }
        else if([dictionary isKindOfClass:[NSDictionary class]])
        {
            POIDetail *poiDetail = [[POIDetail alloc] initWithAttribute:dictionary];
            [mutableArray addObject:poiDetail];
            [poiDetail release];
        }
    }
    else if([dictionary isKindOfClass:[NSArray class]])
    {
        for(NSDictionary *attribute in (NSArray *)dictionary)
        {
            POIDetail *poiDetail = [[POIDetail alloc] initWithAttribute:attribute];
            [mutableArray addObject:poiDetail];
            [poiDetail release];
        }
    }
    
    return mutableArray;
}

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
                    failure:(LPObjectFailureBlock)failureBlock
{
    [[LPAPIClient sharedAPIClient] getPOIListWithPOIId:POIId
                                                 brief:brief
                                                offset:offset
                                                 limit:limit
                                               keyword:keyword
                                                  area:area
                                                  city:city
                                                 range:range
                                              category:category
                                                 order:order
                                             longitude:longitude
                                              latitude:latitude
                                               success:^(id respondObject) {
                                                   if(successBlock)
                                                   {
                                                       successBlock([POIDetail parseFromeDictionary:respondObject]);
                                                   }
                                               } failure:^(NSError *error) {
                                                   if(failureBlock)
                                                   {
                                                       failureBlock(error);
                                                   }
                                               }];
}

@end
