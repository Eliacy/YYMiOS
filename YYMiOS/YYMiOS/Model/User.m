//
//  User.m
//  YYMiOS
//
//  Created by lide on 14-10-10.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "User.h"

@implementation User

@synthesize userIcon = _userIcon;
@synthesize userId = _userId;
@synthesize userName = _userName;
@synthesize anonymous = _anonymous;
@synthesize badges = _badges;
@synthesize createTime = _createTime;
@synthesize exp = _exp;
@synthesize fanCount = _fanCount;
@synthesize favouriteCount = _favouriiteCount;
@synthesize followCount = _followCount;
@synthesize followed = _followed;
@synthesize gender = _gender;
@synthesize level = _level;
@synthesize likeCount = _likeCount;
@synthesize mobile = _mobile;
@synthesize reviewCount = _reviewCount;
@synthesize shareCount = _shareCount;
@synthesize updateTime = _updateTime;
@synthesize loginName = _loginName;
@synthesize emUsername = _emUsername;
@synthesize emPassword = _emPassword;

static User *sharedUser = nil;
+ (id)sharedUser
{
    @synchronized(sharedUser){
        if(sharedUser == nil)
        {
            NSArray *array = [LPUtility unarchiveDataFromCache:@"LoginUser"];
            if(array && [array isKindOfClass:[NSArray class]] && [array count] > 0)
            {
                sharedUser = [[array objectAtIndex:0] retain];
            }
            else
            {
                sharedUser = [[User alloc] init];
            }
        }
    }

    return sharedUser;
}

+ (void)setSharedUser:(User *)user
{
    sharedUser = user;
}

- (id)initWithAttribute:(NSDictionary *)attribute
{
    self = [super init];
    if(self != nil)
    {
        if(attribute != nil)
        {
            if([attribute objectForKey:@"icon"] && ![[attribute objectForKey:@"icon"] isEqual:[NSNull null]])
            {
                NSDictionary *dictionary = [attribute objectForKey:@"icon"];
                if(dictionary && [dictionary isKindOfClass:[NSDictionary class]])
                {
                    LPImage *icon = [[[LPImage alloc] initWithAttribute:dictionary] autorelease];
                    self.userIcon = icon;
                }
            }
            if([attribute objectForKey:@"id"] && ![[attribute objectForKey:@"id"] isEqual:[NSNull null]])
            {
                self.userId = [[attribute objectForKey:@"id"] integerValue];
            }
            if([attribute objectForKey:@"name"] && ![[attribute objectForKey:@"name"] isEqual:[NSNull null]])
            {
                self.userName = [attribute objectForKey:@"name"];
            }
            if([attribute objectForKey:@"anonymous"] && ![[attribute objectForKey:@"anonymous"] isEqual:[NSNull null]])
            {
                self.anonymous = [[attribute objectForKey:@"anonymous"] boolValue];
            }
            if([attribute objectForKey:@"badges"] && ![[attribute objectForKey:@"badges"] isEqual:[NSNull null]])
            {
                self.badges = [attribute objectForKey:@"badges"];
            }
            if([attribute objectForKey:@"create_time"] && ![[attribute objectForKey:@"create_time"] isEqual:[NSNull null]])
            {
                self.createTime = [attribute objectForKey:@"create_time"];
            }
            if([attribute objectForKey:@"exp"] && ![[attribute objectForKey:@"exp"] isEqual:[NSNull null]])
            {
                self.exp = [[attribute objectForKey:@"exp"] integerValue];
            }
            if([attribute objectForKey:@"fans_num"] && ![[attribute objectForKey:@"fans_num"] isEqual:[NSNull null]])
            {
                self.fanCount = [[attribute objectForKey:@"fans_num"] integerValue];
            }
            if([attribute objectForKey:@"favorite_num"] && ![[attribute objectForKey:@"favorite_num"] isEqual:[NSNull null]])
            {
                self.favouriteCount = [[attribute objectForKey:@"favorite_num"] integerValue];
            }
            if([attribute objectForKey:@"follow_num"] && ![[attribute objectForKey:@"follow_num"] isEqual:[NSNull null]])
            {
                self.followCount = [[attribute objectForKey:@"follow_num"] integerValue];
            }
            if([attribute objectForKey:@"followed"] && ![[attribute objectForKey:@"followed"] isEqual:[NSNull null]])
            {
                self.followed = [[attribute objectForKey:@"followed"] boolValue];
            }
            if([attribute objectForKey:@"gender"] && ![[attribute objectForKey:@"gender"] isEqual:[NSNull null]])
            {
                self.gender = [attribute objectForKey:@"gender"];
            }
            if([attribute objectForKey:@"level"] && ![[attribute objectForKey:@"level"] isEqual:[NSNull null]])
            {
                self.level = [[attribute objectForKey:@"level"] integerValue];
            }
            if([attribute objectForKey:@"like_num"] && ![[attribute objectForKey:@"like_num"] isEqual:[NSNull null]])
            {
                self.likeCount = [[attribute objectForKey:@"like_num"] integerValue];
            }
            if([attribute objectForKey:@"mobile"] && ![[attribute objectForKey:@"mobile"] isEqual:[NSNull null]])
            {
                self.mobile = [attribute objectForKey:@"mobile"];
            }
            if([attribute objectForKey:@"review_num"] && ![[attribute objectForKey:@"review_num"] isEqual:[NSNull null]])
            {
                self.reviewCount = [[attribute objectForKey:@"review_num"] integerValue];
            }
            if([attribute objectForKey:@"share_num"] && ![[attribute objectForKey:@"share_num"] isEqual:[NSNull null]])
            {
                self.shareCount = [[attribute objectForKey:@"share_num"] integerValue];
            }
            if([attribute objectForKey:@"update_time"] && ![[attribute objectForKey:@"update_time"] isEqual:[NSNull null]])
            {
                self.updateTime = [attribute objectForKey:@"update_time"];
            }
            if([attribute objectForKey:@"username"] && ![[attribute objectForKey:@"username"] isEqual:[NSNull null]])
            {
                self.loginName = [attribute objectForKey:@"username"];
            }
            if([attribute objectForKey:@"em_username"] && ![[attribute objectForKey:@"em_username"] isEqual:[NSNull null]])
            {
                self.emUsername = [attribute objectForKey:@"em_username"];
            }
            if([attribute objectForKey:@"em_password"] && ![[attribute objectForKey:@"em_password"] isEqual:[NSNull null]])
            {
                self.emPassword = [attribute objectForKey:@"em_password"];
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
                User *user = [[User alloc] initWithAttribute:attribute];
                [mutableArray addObject:user];
                [user release];
            }
        }
        else if([dictionary isKindOfClass:[NSDictionary class]])
        {
            User *user = [[User alloc] initWithAttribute:dictionary];
            [mutableArray addObject:user];
            [user release];
        }
    }
    else if([dictionary isKindOfClass:[NSArray class]])
    {
        for(NSDictionary *attribute in (NSArray *)dictionary)
        {
            User *user = [[User alloc] initWithAttribute:attribute];
            [mutableArray addObject:user];
            [user release];
        }
    }
    
    return mutableArray;
}

+ (void)getUserInfoWithUserId:(NSInteger)userId
                       offset:(NSInteger)offset
                        limit:(NSInteger)limit
                     followId:(NSInteger)followId
                        fanId:(NSInteger)fanId
                      success:(LPObjectSuccessBlock)successBlock
                      failure:(LPObjectFailureBlock)failureBlock
{
    [[LPAPIClient sharedAPIClient] getUserInfoWithUserId:userId
                                                  offset:offset
                                                   limit:limit
                                                followId:followId
                                                   fanId:fanId
                                                 success:^(id respondObject) {
                                                     if(successBlock)
                                                     {
                                                         successBlock([User parseFromeDictionary:respondObject]);
                                                     }
                                                 } failure:^(NSError *error) {
                                                     if(failureBlock)
                                                     {
                                                         failureBlock(error);
                                                     }
                                                 }];
}

@end
