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
    NSString    *_shareDescription;
    NSInteger   _shareId;
    LPImage     *_shareImage;
    Deal        *_deal;
    POI         *_poi;
    NSString    *_target;
    NSString    *_title;
    NSString    *_token;
    NSInteger   _userId;
    NSString    *_shareURL;
}

@property (retain, nonatomic) NSString *actionTime;
@property (retain, nonatomic) Article *article;
@property (retain, nonatomic) NSString *shareDescription;
@property (assign, nonatomic) NSInteger shareId;
@property (retain, nonatomic) LPImage *shareImage;
@property (retain, nonatomic) Deal *deal;
@property (retain, nonatomic) POI *poi;
@property (retain, nonatomic) NSString *target;
@property (retain, nonatomic) NSString *title;
@property (retain, nonatomic) NSString *token;
@property (assign, nonatomic) NSInteger userId;
@property (retain, nonatomic) NSString *shareURL;

- (id)initWithAttribute:(NSDictionary *)attribute;

+ (void)shareSomethingWithUserId:(NSInteger)userId
                          siteId:(NSInteger)siteId
                        reviewId:(NSInteger)reviewId
                       articleId:(NSInteger)articleId
                          target:(NSString *)target
                         success:(LPObjectSuccessBlock)successBlock
                         failure:(LPObjectFailureBlock)failureBlock;

+ (void)getShareListWithOffset:(NSInteger)offset
                         limit:(NSInteger)limit
                        userId:(NSInteger)userId
                       success:(LPObjectSuccessBlock)successBlock
                       failure:(LPObjectFailureBlock)failureBlock;

@end
