//
//  Dynamic.m
//  YYMiOS
//
//  Created by lide on 14-9-28.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "Deal.h"
#import "LPImage.h"

@implementation Deal

@synthesize atList = _atList;
@synthesize commentCount = _commentCount;
@synthesize content = _content;
@synthesize currency = _currency;
@synthesize dealId = _dealId;
@synthesize imageArray = _imageArray;
@synthesize imageCount = _imageCount;
@synthesize keywordArray = _keywordArray;
@synthesize likeCount = _likeCount;
@synthesize publishTime = _publishTime;
@synthesize published = _published;
@synthesize selected = _selected;
@synthesize site = _site;
@synthesize total = _total;
@synthesize updateTime = _updateTime;
@synthesize user = _user;

- (id)initWithAttribute:(NSDictionary *)attribute
{
    self = [super init];
    if(self != nil)
    {
        if(attribute != nil)
        {
            if([attribute objectForKey:@"at_list"] && ![[attribute objectForKey:@"at_list"] isEqual:[NSNull null]])
            {
                NSArray *array = [attribute objectForKey:@"at_list"];
                NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:0];
                if(array && [array isKindOfClass:[NSArray class]] && [array count] > 0)
                {
                    for(NSDictionary *dictionary in array)
                    {
                        User *user = [[[User alloc] initWithAttribute:dictionary] autorelease];
                        [mutableArray addObject:user];
                    }
                }
                self.atList = mutableArray;
            }
            if([attribute objectForKey:@"comment_num"] && ![[attribute objectForKey:@"comment_num"] isEqual:[NSNull null]])
            {
                self.commentCount = [[attribute objectForKey:@"comment_num"] integerValue];
            }
            if([attribute objectForKey:@"content"] && ![[attribute objectForKey:@"content"] isEqual:[NSNull null]])
            {
                self.content = [attribute objectForKey:@"content"];
            }
            if([attribute objectForKey:@"currency"] && ![[attribute objectForKey:@"currency"] isEqual:[NSNull null]])
            {
                self.currency = [attribute objectForKey:@"currency"];
            }
            if([attribute objectForKey:@"id"] && ![[attribute objectForKey:@"id"] isEqual:[NSNull null]])
            {
                self.dealId = [[attribute objectForKey:@"id"] integerValue];
            }
            if([attribute objectForKey:@"images"] && ![[attribute objectForKey:@"images"] isEqual:[NSNull null]])
            {
                NSArray *array = [attribute objectForKey:@"images"];
                NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:0];
                if(array && [array isKindOfClass:[NSArray class]] && [array count] > 0)
                {
                    for(NSDictionary *dictionary in array)
                    {
                        LPImage *image = [[[LPImage alloc] initWithAttribute:dictionary] autorelease];
                        [mutableArray addObject:image];
                    }
                }
                self.imageArray = mutableArray;
            }
            if([attribute objectForKey:@"images_num"] && ![[attribute objectForKey:@"images_num"] isEqual:[NSNull null]])
            {
                self.imageCount = [[attribute objectForKey:@"images_num"] integerValue];
            }
            if([attribute objectForKey:@"keywords"] && ![[attribute objectForKey:@"keywords"] isEqual:[NSNull null]])
            {
                NSArray *array = [attribute objectForKey:@"keywords"];
                NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:0];
                if(array && [array isKindOfClass:[NSArray class]] && [array count] > 0)
                {
                    for(NSString *string in array)
                    {
                        [mutableArray addObject:string];
                    }
                }
                self.keywordArray = mutableArray;
            }
            if([attribute objectForKey:@"like_num"] && ![[attribute objectForKey:@"like_num"] isEqual:[NSNull null]])
            {
                self.likeCount = [[attribute objectForKey:@"like_num"] integerValue];
            }
            if([attribute objectForKey:@"publish_time"] && ![[attribute objectForKey:@"publish_time"] isEqual:[NSNull null]])
            {
                self.publishTime = [attribute objectForKey:@"publish_time"];
            }
            if([attribute objectForKey:@"published"] && ![[attribute objectForKey:@"published"] isEqual:[NSNull null]])
            {
                self.published = [[attribute objectForKey:@"published"] boolValue];
            }
            if([attribute objectForKey:@"selected"] && ![[attribute objectForKey:@"selected"] isEqual:[NSNull null]])
            {
                self.selected = [[attribute objectForKey:@"selected"] boolValue];
            }
            if([attribute objectForKey:@"site"] && ![[attribute objectForKey:@"site"] isEqual:[NSNull null]])
            {
                NSDictionary *dictionary = [attribute objectForKey:@"site"];
                if(dictionary && [dictionary isKindOfClass:[NSDictionary class]])
                {
                    Site *site = [[[Site alloc] initWithAttribute:dictionary] autorelease];
                    self.site = site;
                }
            }
            if([attribute objectForKey:@"total"] && ![[attribute objectForKey:@"total"] isEqual:[NSNull null]])
            {
                self.total = [[attribute objectForKey:@"total"] integerValue];
            }
            if([attribute objectForKey:@"update_time"] && ![[attribute objectForKey:@"update_time"] isEqual:[NSNull null]])
            {
                self.updateTime = [attribute objectForKey:@"update_time"];
            }
            if([attribute objectForKey:@"user"] && ![[attribute objectForKey:@"user"] isEqual:[NSNull null]])
            {
                NSDictionary *dictionary = [attribute objectForKey:@"user"];
                if(dictionary && [dictionary isKindOfClass:[NSDictionary class]])
                {
                    User *user = [[[User alloc] initWithAttribute:dictionary] autorelease];
                    self.user = user;
                }
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
                Deal *deal = [[Deal alloc] initWithAttribute:attribute];
                [mutableArray addObject:deal];
                [deal release];
            }
        }
        else if([dictionary isKindOfClass:[NSDictionary class]])
        {
            Deal *deal = [[Deal alloc] initWithAttribute:dictionary];
            [mutableArray addObject:deal];
            [deal release];
        }
    }
    else if([dictionary isKindOfClass:[NSArray class]])
    {
        for(NSDictionary *attribute in (NSArray *)dictionary)
        {
            Deal *deal = [[Deal alloc] initWithAttribute:attribute];
            [mutableArray addObject:deal];
            [deal release];
        }
    }
    
    return mutableArray;
}

+ (void)getDealDetailListWithBrief:(NSInteger)brief
                          selected:(NSInteger)selected
                         published:(NSInteger)published
                            offset:(NSInteger)offset
                             limit:(NSInteger)limit
                              user:(NSInteger)user
                              site:(NSInteger)site
                              city:(NSInteger)city
                           success:(LPObjectSuccessBlock)successBlock
                           failure:(LPObjectFailureBlock)failureBlcok
{
    [[LPAPIClient sharedAPIClient] getDealDetailListWithBrief:brief
                                                     selected:selected
                                                    published:published
                                                       offset:offset
                                                        limit:limit
                                                         user:user
                                                         site:site
                                                         city:city
                                                      success:^(id respondObject) {
                                                          if(successBlock)
                                                          {
                                                              successBlock([Deal parseFromeDictionary:respondObject]);
                                                          }
                                                      } failure:^(NSError *error) {
                                                          if(failureBlcok)
                                                          {
                                                              failureBlcok(error);
                                                          }
                                                      }];
}

@end
