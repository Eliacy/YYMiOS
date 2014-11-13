//
//  Home.m
//  YYMiOS
//
//  Created by lide on 14-9-28.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "Article.h"

@implementation Article

@synthesize caption = _caption;
@synthesize commentCount = _commentCount;
@synthesize contentArray = _contentArray;
@synthesize createTime = _createTime;
@synthesize articleId = _articleId;
@synthesize keywordArray = _keywordArray;
@synthesize title = _title;
@synthesize updateTime = _updateTime;

- (id)initWithAttribute:(NSDictionary *)attribute
{
    self = [super init];
    if(self != nil)
    {
        if(attribute != nil)
        {
            if([attribute objectForKey:@"caption"] && ![[attribute objectForKey:@"caption"] isEqual:[NSNull null]])
            {
                NSDictionary *dictionary = [attribute objectForKey:@"caption"];
                if(dictionary && [dictionary isKindOfClass:[NSDictionary class]])
                {
                    LPImage *image = [[[LPImage alloc] initWithAttribute:dictionary] autorelease];
                    self.caption = image;
                }
            }
            if([attribute objectForKey:@"comment_num"] && ![[attribute objectForKey:@"comment_num"] isEqual:[NSNull null]])
            {
                self.commentCount = [[attribute objectForKey:@"comment_num"] integerValue];
            }
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
                self.createTime = [attribute objectForKey:@"create_time"];
            }
            if([attribute objectForKey:@"id"] && ![[attribute objectForKey:@"id"] isEqual:[NSNull null]])
            {
                self.articleId = [[attribute objectForKey:@"id"] integerValue];
            }
            if([attribute objectForKey:@"keywords"] && ![[attribute objectForKey:@"keywords"] isEqual:[NSNull null]])
            {
                NSArray *array = [attribute objectForKey:@"keywords"];
                if(array && [array isKindOfClass:[NSArray class]] && [array count] > 0)
                {
                    self.keywordArray = array;
                }
            }
            if([attribute objectForKey:@"title"] && ![[attribute objectForKey:@"title"] isEqual:[NSNull null]])
            {
                self.title = [attribute objectForKey:@"title"];
            }
            if([attribute objectForKey:@"update_time"] && ![[attribute objectForKey:@"update_time"] isEqual:[NSNull null]])
            {
                self.updateTime = [attribute objectForKey:@"update_time"];
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
                Article *article = [[Article alloc] initWithAttribute:attribute];
                [mutableArray addObject:article];
                [article release];
            }
        }
        else if([dictionary isKindOfClass:[NSDictionary class]])
        {
            Article *article = [[Article alloc] initWithAttribute:dictionary];
            [mutableArray addObject:article];
            [article release];
        }
    }
    else if([dictionary isKindOfClass:[NSArray class]])
    {
        for(NSDictionary *attribute in (NSArray *)dictionary)
        {
            Article *article = [[Article alloc] initWithAttribute:attribute];
            [mutableArray addObject:article];
            [article release];
        }
    }
    
    return mutableArray;
}

+ (void)getArticleListWithArticleId:(NSInteger)articleId
                              brief:(NSInteger)brief
                             offset:(NSInteger)offset
                              limit:(NSInteger)limit
                             cityId:(NSInteger)cityId
                            success:(LPObjectSuccessBlock)successBlock
                            failure:(LPObjectFailureBlock)failureBlcok
{
    [[LPAPIClient sharedAPIClient] getArticleListWithArticleId:articleId
                                                         brief:brief
                                                        offset:offset
                                                         limit:limit
                                                        cityId:cityId
                                                       success:^(id respondObject) {
                                                           if(successBlock)
                                                           {
                                                               successBlock([Article parseFromeDictionary:respondObject]);
                                                           }
                                                       } failure:^(NSError *error) {
                                                           if(failureBlcok)
                                                           {
                                                               failureBlcok(error);
                                                           }
                                                       }];
}

@end
