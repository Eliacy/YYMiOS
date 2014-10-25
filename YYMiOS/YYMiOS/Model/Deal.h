//
//  Dynamic.h
//  YYMiOS
//
//  Created by lide on 14-9-28.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "LPObject.h"
#import "Site.h"
#import "User.h"

@interface Deal : LPObject
{
    NSArray     *_atList;
    NSInteger   _commentCount;
    NSString    *_content;
    NSString    *_currency;
    NSInteger   _dealId;
    NSArray     *_imageArray;
    NSInteger   _imageCount;
    NSArray     *_keywordArray;
    NSInteger   _likeCount;
    NSString    *_publishTime;
    BOOL        _published;
    BOOL        _selected;
    Site        *_site;
    NSInteger   _total;
    NSString    *_updateTime;
    User        *_user;
}

@property (retain, nonatomic) NSArray *atList;
@property (assign, nonatomic) NSInteger commentCount;
@property (retain, nonatomic) NSString *content;
@property (retain, nonatomic) NSString *currency;
@property (assign, nonatomic) NSInteger dealId;
@property (retain, nonatomic) NSArray *imageArray;
@property (assign, nonatomic) NSInteger imageCount;
@property (retain, nonatomic) NSArray *keywordArray;
@property (assign, nonatomic) NSInteger likeCount;
@property (retain, nonatomic) NSString *publishTime;
@property (assign, nonatomic) BOOL published;
@property (assign, nonatomic) BOOL selected;
@property (retain, nonatomic) Site *site;
@property (assign, nonatomic) NSInteger total;
@property (retain, nonatomic) NSString *updateTime;
@property (retain, nonatomic) User *user;

- (id)initWithAttribute:(NSDictionary *)attribute;

@end
