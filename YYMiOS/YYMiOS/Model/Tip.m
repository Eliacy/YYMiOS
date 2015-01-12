//
//  Tip.m
//  YYMiOS
//
//  Created by Lide on 14-11-4.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "Tip.h"

@implementation Tip

@synthesize contentArray = _contentArray;
@synthesize createTime = _createTime;
@synthesize defaultFlag = _defaultFlag;
@synthesize tipId = _tipId;
@synthesize title = _title;
@synthesize updateTime = _updateTime;

- (id)initWithAttribute:(NSDictionary *)attribute
{
    self = [super init];
    if(self != nil)
    {
        if(attribute != nil)
        {
            if([attribute objectForKey:@"content"] && ![[attribute objectForKey:@"content"] isEqual:[NSNull null]])
            {
                NSArray *array = [attribute objectForKey:@"content"];
                if(array && [array isKindOfClass:[NSArray class]] && [array count] > 0)
                {
                    self.contentArray = array;
                }
            }
            if([attribute objectForKey:@"create_time"] && ![[attribute objectForKey:@"create_time"] isEqual:[NSNull null]])
            {
                self.createTime = [LPUtility dateFromInternetDateTimeString:[attribute objectForKey:@"create_time"]];
            }
            if([attribute objectForKey:@"default"] && ![[attribute objectForKey:@"default"] isEqual:[NSNull null]])
            {
                self.defaultFlag = [[attribute objectForKey:@"default"] boolValue];
            }
            if([attribute objectForKey:@"id"] && ![[attribute objectForKey:@"id"] isEqual:[NSNull null]])
            {
                self.tipId = [[attribute objectForKey:@"id"] integerValue];
            }
            if([attribute objectForKey:@"title"] && ![[attribute objectForKey:@"title"] isEqual:[NSNull null]])
            {
                self.title = [attribute objectForKey:@"title"];
            }
            if([attribute objectForKey:@"update_time"] && ![[attribute objectForKey:@"update_time"] isEqual:[NSNull null]])
            {
                self.updateTime = [LPUtility dateFromInternetDateTimeString:[attribute objectForKey:@"update_time"]];
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
                Tip *tip = [[Tip alloc] initWithAttribute:attribute];
                [mutableArray addObject:tip];
                [tip release];
            }
        }
        else if([dictionary isKindOfClass:[NSDictionary class]])
        {
            Tip *tip = [[Tip alloc] initWithAttribute:dictionary];
            [mutableArray addObject:tip];
            [tip release];
        }
    }
    else if([dictionary isKindOfClass:[NSArray class]])
    {
        for(NSDictionary *attribute in (NSArray *)dictionary)
        {
            Tip *tip = [[Tip alloc] initWithAttribute:attribute];
            [mutableArray addObject:tip];
            [tip release];
        }
    }
    
    return mutableArray;
}

+ (void)getTipsListWithTipsId:(NSInteger)tipsId
                        brief:(NSInteger)brief
                       cityId:(NSInteger)cityId
                      success:(LPObjectSuccessBlock)successBlock
                      failure:(LPObjectFailureBlock)failureBlock
{
    [[LPAPIClient sharedAPIClient] getTipsListWithTipsId:tipsId
                                                   brief:brief
                                                  cityId:cityId
                                                 success:^(id respondObject) {
                                                     if(successBlock)
                                                     {
                                                         successBlock([Tip parseFromeDictionary:respondObject]);
                                                     }
                                                 } failure:^(NSError *error) {
                                                     if(failureBlock)
                                                     {
                                                         failureBlock(error);
                                                     }
                                                 }];
}

@end
