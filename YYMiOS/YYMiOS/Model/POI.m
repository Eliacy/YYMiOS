//
//  Nearby.m
//  YYMiOS
//
//  Created by lide on 14-9-28.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "POI.h"

@implementation POI

@synthesize address = _address;
@synthesize poiId = _poiId;
@synthesize keywordArray = _keywordArray;
@synthesize latitude = _latitude;
@synthesize longitude = _longitude;
@synthesize level = _level;
@synthesize logo = _logo;
@synthesize name = _name;
@synthesize popular = _popular;
@synthesize reviewNum = _reviewNum;
@synthesize stars = _stars;
@synthesize topImageArray;

- (id)initWithAttribute:(NSDictionary *)attribute
{
    self = [super init];
    if(self != nil)
    {
        if([attribute objectForKey:@"address"] && ![[attribute objectForKey:@"address"] isEqual:[NSNull null]])
        {
            self.address = [attribute objectForKey:@"address"];
        }
        if([attribute objectForKey:@"id"] && ![[attribute objectForKey:@"id"] isEqual:[NSNull null]])
        {
            self.poiId = [[attribute objectForKey:@"id"] integerValue];
        }
        if([attribute objectForKey:@"keywords"] && ![[attribute objectForKey:@"keywords"] isEqual:[NSNull null]])
        {
            self.keywordArray = [attribute objectForKey:@"keywords"];
        }
        if([attribute objectForKey:@"latitude"] && ![[attribute objectForKey:@"latitude"] isEqual:[NSNull null]])
        {
            self.latitude = [[attribute objectForKey:@"latitude"] floatValue];
        }
        if([attribute objectForKey:@"longitude"] && ![[attribute objectForKey:@"longitude"] isEqual:[NSNull null]])
        {
            self.longitude = [[attribute objectForKey:@"longitude"] floatValue];
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
        if([attribute objectForKey:@"name"] && ![[attribute objectForKey:@"name"] isEqual:[NSNull null]])
        {
            self.name = [attribute objectForKey:@"name"];
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
            self.stars = [[attribute objectForKey:@"stars"] integerValue];
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
                POI *poi = [[POI alloc] initWithAttribute:attribute];
                [mutableArray addObject:poi];
                [poi release];
            }
        }
        else if([dictionary isKindOfClass:[NSDictionary class]])
        {
            POI *poi = [[POI alloc] initWithAttribute:dictionary];
            [mutableArray addObject:poi];
            [poi release];
        }
    }
    else if([dictionary isKindOfClass:[NSArray class]])
    {
        for(NSDictionary *attribute in (NSArray *)dictionary)
        {
            POI *poi = [[POI alloc] initWithAttribute:attribute];
            [mutableArray addObject:poi];
            [poi release];
        }
    }
    
    return mutableArray;
}

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
                     failure:(LPObjectFailureBlock)failureBlock
{
    [[LPAPIClient sharedAPIClient] getPOIListWithPOIId:0
                                                 brief:1
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
                                                       successBlock([POI parseFromeDictionary:respondObject]);
                                                   }
                                               } failure:^(NSError *error) {
                                                   if(failureBlock)
                                                   {
                                                       failureBlock(error);
                                                   }
                                               }];
}

+ (void)collectPOIWithUserId:(NSInteger)userId
                       POIId:(NSInteger)POIId
                     success:(LPObjectSuccessBlock)successBlock
                     failure:(LPObjectFailureBlock)failureBlock
{
    [[LPAPIClient sharedAPIClient] collectPOIWithUserId:userId
                                                  POIId:POIId
                                                success:^(id respondObject) {
                                                    if(successBlock)
                                                    {
                                                        successBlock([POI parseFromeDictionary:respondObject]);
                                                    }
                                                } failure:^(NSError *error) {
                                                    if(failureBlock)
                                                    {
                                                        failureBlock(error);
                                                    }
                                                }];
}

+ (void)cancelCollectPOIWithUserId:(NSInteger)userId
                             POIId:(NSInteger)POIId
                           success:(LPObjectSuccessBlock)successBlock
                           failure:(LPObjectFailureBlock)failureBlock
{
    [[LPAPIClient sharedAPIClient] cancelCollectPOIWithUserId:userId
                                                        POIId:POIId
                                                      success:^(id respondObject) {
                                                          if(successBlock)
                                                          {
                                                              successBlock([POI parseFromeDictionary:respondObject]);
                                                          }
                                                      } failure:^(NSError *error) {
                                                          if(failureBlock)
                                                          {
                                                              failureBlock(error);
                                                          }
                                                      }];
}

+ (void)getPOIFavouriteListWithOffset:(NSInteger)offset
                                limit:(NSInteger)limit
                               userId:(NSInteger)userId
                              success:(LPObjectSuccessBlock)successBlock
                              failure:(LPObjectFailureBlock)failureBlock
{
    [[LPAPIClient sharedAPIClient] getPOIFavouriteListWithOffset:offset
                                                           limit:limit
                                                          userId:userId
                                                         success:^(id respondObject) {
                                                             if(successBlock)
                                                             {
                                                                 successBlock([POI parseFromeDictionary:respondObject]);
                                                             }
                                                         } failure:^(NSError *error) {
                                                             if(failureBlock)
                                                             {
                                                                 failureBlock(error);
                                                             }
                                                         }];
}

@end
