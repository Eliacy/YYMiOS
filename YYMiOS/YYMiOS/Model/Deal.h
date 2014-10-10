//
//  Dynamic.h
//  YYMiOS
//
//  Created by lide on 14-9-28.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "LPObject.h"
#import "User.h"

@interface Deal : LPObject
{
    NSInteger   _dealId;
    User        *_user;
    NSString    *_content;
    NSArray     *_imageArray;
    NSInteger   _likeCount;
    NSInteger   _commentCount;
    NSString    *_price;
    NSString    *_location;
}

@property (assign, nonatomic) NSInteger dealId;
@property (retain, nonatomic) User *user;
@property (retain, nonatomic) NSString *content;
@property (retain, nonatomic) NSArray *imageArray;
@property (assign, nonatomic) NSInteger likeCount;
@property (assign, nonatomic) NSInteger commentCount;
@property (retain, nonatomic) NSString *price;
@property (retain, nonatomic) NSString *location;

@end
