//
//  Share.h
//  YYMiOS
//
//  Created by Lide on 14/12/15.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "LPObject.h"
#import "Article.h"
#import "LPImage.h"
#import "Deal.h"
#import "POI.h"

@interface Share : LPObject
{
    NSString    *_actionTime;
    Article     *_article;
    NSString    *_description;
    NSInteger   _shareId;
    LPImage     *_shareImage;
    Deal        *_deal;
    POI         *_poi;
    NSString    *_target;
    NSString    *_title;
    NSString    *_token;
    NSInteger   _userId;
}

@property (retain, nonatomic) NSString *actionTime;
@property (retain, nonatomic) Article *article;

@end
