//
//  Comment.m
//  YYMiOS
//
//  Created by Lide on 14-11-11.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "Comment.h"

@implementation Comment

@synthesize articleId = _articleId;
@synthesize atList = _atList;
@synthesize content = _content;
@synthesize commentId = _commentId;
@synthesize publishTime = _publishTime;
@synthesize reviewId = _reviewId;
@synthesize updateTime = _updateTime;
@synthesize user = _user;

- (id)initWithAttribute:(NSDictionary *)attribute
{
    self = [super init];
    if(self != nil)
    {
        if(attribute != nil)
        {
            if([attribute objectForKey:@"article_id"] && ![[attribute objectForKey:@"article_id"] isEqual:[NSNull null]])
            {
                self.articleId = [[attribute objectForKey:@"article_id"] integerValue];
            }
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
            if([attribute objectForKey:@"content"] && ![[attribute objectForKey:@"content"] isEqual:[NSNull null]])
            {
                self.content = [attribute objectForKey:@"content"];
            }
            if([attribute objectForKey:@"id"] && ![[attribute objectForKey:@"id"] isEqual:[NSNull null]])
            {
                self.commentId = [[attribute objectForKey:@"id"] integerValue];
            }
            if([attribute objectForKey:@"publish_time"] && ![[attribute objectForKey:@"publish_time"] isEqual:[NSNull null]])
            {
                self.publishTime = [attribute objectForKey:@"publish_time"];
            }
            if([attribute objectForKey:@"review_id"] && ![[attribute objectForKey:@"review_id"] isEqual:[NSNull null]])
            {
                self.reviewId = [[attribute objectForKey:@"review_id"] integerValue];
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
                Comment *commet = [[Comment alloc] initWithAttribute:attribute];
                [mutableArray addObject:commet];
                [commet release];
            }
        }
        else if([dictionary isKindOfClass:[NSDictionary class]])
        {
            Comment *commet = [[Comment alloc] initWithAttribute:dictionary];
            [mutableArray addObject:commet];
            [commet release];
        }
    }
    else if([dictionary isKindOfClass:[NSArray class]])
    {
        for(NSDictionary *attribute in (NSArray *)dictionary)
        {
            Comment *commet = [[Comment alloc] initWithAttribute:attribute];
            [mutableArray addObject:commet];
            [commet release];
        }
    }
    
    return mutableArray;
}

+ (void)getCommentListWithCommentId:(NSInteger)commentId
                             offset:(NSInteger)offset
                              limit:(NSInteger)limit
                          articleId:(NSInteger)articleId
                           reviewId:(NSInteger)reviewId
                            success:(LPObjectSuccessBlock)successBlock
                            failure:(LPObjectFailureBlock)failureBlock
{
    [[LPAPIClient sharedAPIClient] getCommentListWithCommentId:commentId
                                                        offset:offset
                                                         limit:limit
                                                     articleId:articleId
                                                      reviewId:reviewId
                                                       success:^(id respondObject) {
                                                           if(successBlock)
                                                           {
                                                               successBlock([Comment parseFromeDictionary:respondObject]);
                                                           }
                                                       } failure:^(NSError *error) {
                                                           if(failureBlock)
                                                           {
                                                               failureBlock(error);
                                                           }
                                                       }];
}

+ (void)createCommentWithDealId:(NSInteger)dealId
                      articleId:(NSInteger)articleId
                         userId:(NSInteger)userId
                         atList:(NSString *)atList
                        content:(NSString *)content
                        success:(LPObjectSuccessBlock)successBlock
                        failure:(LPObjectFailureBlock)failureBlcok
{
    [[LPAPIClient sharedAPIClient] createCommentWithDealId:dealId
                                                 articleId:articleId
                                                    userId:userId
                                                    atList:atList
                                                   content:content
                                                   success:^(id respondObject) {
                                                       if(successBlock)
                                                       {
                                                           successBlock([Comment parseFromeDictionary:respondObject]);
                                                       }
                                                   } failure:^(NSError *error) {
                                                       if(failureBlcok)
                                                       {
                                                           failureBlcok(error);
                                                       }
                                                   }];
}

@end
