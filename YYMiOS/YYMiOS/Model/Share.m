//
//  Share.m
//  YYMiOS
//
//  Created by Lide on 14/12/15.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "Share.h"

@implementation Share

@synthesize actionTime = _actionTime;
@synthesize article = _article;
@synthesize shareDescription = _shareDescription;
@synthesize shareId = _sharedId;
@synthesize shareImage = _shareImage;
@synthesize deal = _deal;
@synthesize poi = _poi;
@synthesize target = _target;
@synthesize title = _title;
@synthesize token = _token;
@synthesize userId = _userId;
@synthesize shareURL = _shareURL;

- (id)initWithAttribute:(NSDictionary *)attribute
{
    self = [super init];
    if(self != nil)
    {
        if(attribute != nil)
        {
            if([attribute objectForKey:@"action_time"] && ![[attribute objectForKey:@"action_time"] isEqual:[NSNull null]])
            {
                self.actionTime = [attribute objectForKey:@"action_time"];
            }
            if([attribute objectForKey:@"article"] && ![[attribute objectForKey:@"article"] isEqual:[NSNull null]])
            {
                NSDictionary *dictionary = [attribute objectForKey:@"article"];
                if(dictionary && [dictionary isKindOfClass:[NSDictionary class]])
                {
                    Article *article = [[[Article alloc] initWithAttribute:dictionary] autorelease];
                    self.article = article;
                }
            }
            if([attribute objectForKey:@"description"] && ![[attribute objectForKey:@"description"] isEqual:[NSNull null]])
            {
                self.shareDescription = [attribute objectForKey:@"description"];
            }
            if([attribute objectForKey:@"id"] && ![[attribute objectForKey:@"id"] isEqual:[NSNull null]])
            {
                self.shareId = [[attribute objectForKey:@"id"] integerValue];
            }
            if([attribute objectForKey:@"image"] && ![[attribute objectForKey:@"image"] isEqual:[NSNull null]])
            {
                NSDictionary *dictionary = [attribute objectForKey:@"image"];
                if(dictionary && [dictionary isKindOfClass:[NSDictionary class]])
                {
                    LPImage *image = [[[LPImage alloc] initWithAttribute:dictionary] autorelease];
                    self.shareImage = image;
                }
            }
            if([attribute objectForKey:@"review"] && ![[attribute objectForKey:@"review"] isEqual:[NSNull null]])
            {
                NSDictionary *dictionary = [attribute objectForKey:@"review"];
                if(dictionary && [dictionary isKindOfClass:[NSDictionary class]])
                {
                    Deal *deal = [[[Deal alloc] initWithAttribute:dictionary] autorelease];
                    self.deal = deal;
                }
            }
            if([attribute objectForKey:@"site"] && ![[attribute objectForKey:@"site"] isEqual:[NSNull null]])
            {
                NSDictionary *dictionary = [attribute objectForKey:@"site"];
                if(dictionary && [dictionary isKindOfClass:[NSDictionary class]])
                {
                    POI *poi = [[[POI alloc] initWithAttribute:dictionary] autorelease];
                    self.poi = poi;
                }
            }
            if([attribute objectForKey:@"target"] && ![[attribute objectForKey:@"target"] isEqual:[NSNull null]])
            {
                self.target = [attribute objectForKey:@"target"];
            }
            if([attribute objectForKey:@"title"] && ![[attribute objectForKey:@"title"] isEqual:[NSNull null]])
            {
                self.title = [attribute objectForKey:@"title"];
            }
            if([attribute objectForKey:@"token"] && ![[attribute objectForKey:@"token"] isEqual:[NSNull null]])
            {
                self.token = [attribute objectForKey:@"token"];
            }
            if([attribute objectForKey:@"user_id"] && ![[attribute objectForKey:@"user_id"] isEqual:[NSNull null]])
            {
                self.userId = [[attribute objectForKey:@"user_id"] integerValue];
            }
            if([attribute objectForKey:@"url"] && ![[attribute objectForKey:@"url"] isEqual:[NSNull null]])
            {
                self.shareURL = [attribute objectForKey:@"url"];
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
                Share *share = [[Share alloc] initWithAttribute:attribute];
                [mutableArray addObject:share];
                [share release];
            }
        }
        else if([dictionary isKindOfClass:[NSDictionary class]])
        {
            Share *share = [[Share alloc] initWithAttribute:dictionary];
            [mutableArray addObject:share];
            [share release];
        }
    }
    else if([dictionary isKindOfClass:[NSArray class]])
    {
        for(NSDictionary *attribute in (NSArray *)dictionary)
        {
            Share *share = [[Share alloc] initWithAttribute:attribute];
            [mutableArray addObject:share];
            [share release];
        }
    }
    
    return mutableArray;
}

+ (void)shareSomethingWithUserId:(NSInteger)userId
                          siteId:(NSInteger)siteId
                        reviewId:(NSInteger)reviewId
                       articleId:(NSInteger)articleId
                          target:(NSString *)target
                         success:(LPObjectSuccessBlock)successBlock
                         failure:(LPObjectFailureBlock)failureBlock
{
    [[LPAPIClient sharedAPIClient] shareSomethingWithUserId:userId
                                                     siteId:siteId
                                                   reviewId:reviewId
                                                  articleId:articleId
                                                     target:target
                                                    success:^(id respondObject) {
                                                        if(successBlock)
                                                        {
                                                            successBlock([Share parseFromeDictionary:respondObject]);
                                                        }
                                                    } failure:^(NSError *error) {
                                                        if(failureBlock)
                                                        {
                                                            failureBlock(error);
                                                        }
                                                    }];
}

+ (void)getShareListWithOffset:(NSInteger)offset
                         limit:(NSInteger)limit
                        userId:(NSInteger)userId
                       success:(LPObjectSuccessBlock)successBlock
                       failure:(LPObjectFailureBlock)failureBlock
{
    [[LPAPIClient sharedAPIClient] getShareListWithOffset:offset
                                                    limit:limit
                                                   userId:userId
                                                  success:^(id respondObject) {
                                                      if(successBlock)
                                                      {
                                                          if(successBlock)
                                                          {
                                                              successBlock([Share parseFromeDictionary:respondObject]);
                                                          }
                                                      }
                                                  } failure:^(NSError *error) {
                                                      if(failureBlock)
                                                      {
                                                          failureBlock(error);
                                                      }
                                                  }];
}

@end
