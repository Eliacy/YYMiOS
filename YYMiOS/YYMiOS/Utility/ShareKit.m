//
//  ShareKit.m
//  YYMiOS
//
//  Created by lide on 14-10-2.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "ShareKit.h"
#import "Share.h"
#import "WeiboSDK.h"
#import "WXApi.h"

@implementation ShareKit

@synthesize delegate = _delegate;

@synthesize articleId = _articleId;
@synthesize reviewId = _reviewId;
@synthesize siteId = _siteId;

#pragma mark - private

- (void)clickWeiboButton:(id)sender
{
    if(![WeiboSDK isWeiboAppInstalled])
    {
        [[[[UIApplication sharedApplication] delegate] window] hideToast];
        [[[[UIApplication sharedApplication] delegate] window] makeToast:@"您还没有安装新浪微博" duration:1.5 position:@"center"];
        
        return;
    }
    
    [Share shareSomethingWithUserId:[[User sharedUser] userId]
                             siteId:_siteId
                           reviewId:_reviewId
                          articleId:_articleId
                             target:@"新浪微博"
                            success:^(NSArray *array) {
                                
                                if([array count] > 0)
                                {
                                    Share *share = [array objectAtIndex:0];
                                    
                                    WBMessageObject *message = [WBMessageObject message];
                                    message.text = [NSString stringWithFormat:@"%@\n%@\n%@", share.title, share.shareDescription, share.shareURL];
                                    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message];
                                    request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
                                                         @"Other_Info_1": [NSNumber numberWithInt:123],
                                                         @"Other_Info_2": @[@"obj1", @"obj2"],
                                                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
                                    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
                                    
                                    [WeiboSDK sendRequest:request];
                                    
                                    [self hide];
                                }
                                
                            } failure:^(NSError *error) {
                                
                            }];
}

- (void)clickWeixinButton:(id)sender
{
    if(![WXApi isWXAppInstalled])
    {
        [[[[UIApplication sharedApplication] delegate] window] hideToast];
        [[[[UIApplication sharedApplication] delegate] window] makeToast:@"您还没有安装微信" duration:1.5 position:@"center"];
        
        return;
    }
    
    [Share shareSomethingWithUserId:[[User sharedUser] userId]
                             siteId:_siteId
                           reviewId:_reviewId
                          articleId:_articleId
                             target:@"微信"
                            success:^(NSArray *array) {
                                
                                if([array count] > 0)
                                {
                                    Share *share = [array objectAtIndex:0];
                                    
                                    WXMediaMessage *message = [WXMediaMessage message];
                                    message.title = share.title;
                                    message.description = share.shareDescription;
                                    [message setThumbImage:[UIImage imageNamed:@"Icon-60@2x.png"]];
                                    
                                    WXWebpageObject *ext = [WXWebpageObject object];
                                    ext.webpageUrl = share.shareURL;
                                    
                                    message.mediaObject = ext;
                                    
                                    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
                                    req.bText = NO;
                                    req.message = message;
                                    req.scene = WXSceneSession;
                                    [WXApi sendReq:req];
                                    [req release];
                                    
                                    [self hide];
                                }
                                
                            } failure:^(NSError *error) {
                                
                            }];
}

- (void)clickFriendButton:(id)sender
{
    if(![WXApi isWXAppInstalled])
    {
        [[[[UIApplication sharedApplication] delegate] window] hideToast];
        [[[[UIApplication sharedApplication] delegate] window] makeToast:@"您还没有安装微信" duration:1.5 position:@"center"];
        
        return;
    }
    
    [Share shareSomethingWithUserId:[[User sharedUser] userId]
                             siteId:_siteId
                           reviewId:_reviewId
                          articleId:_articleId
                             target:@"朋友圈"
                            success:^(NSArray *array) {
                                
                                if([array count] > 0)
                                {
                                    Share *share = [array objectAtIndex:0];
                                    
                                    WXMediaMessage *message = [WXMediaMessage message];
                                    message.title = share.title;
                                    message.description = share.shareDescription;
                                    [message setThumbImage:[UIImage imageNamed:@"Icon-60@2x.png"]];
                                    
                                    WXWebpageObject *ext = [WXWebpageObject object];
                                    ext.webpageUrl = share.shareURL;
                                    
                                    message.mediaObject = ext;
                                    
                                    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
                                    req.bText = NO;
                                    req.message = message;
                                    req.scene = WXSceneTimeline;
                                    [WXApi sendReq:req];
                                    [req release];
                                    
                                    [self hide];
                                }
                                
                            } failure:^(NSError *error) {
                                
                            }];
}

#pragma mark - public

static id sharedKit = nil;
+ (id)sharedKit
{
    @synchronized(sharedKit){
        if(sharedKit == nil)
        {
            sharedKit = [[self alloc] init];
        }
    }
    
    return sharedKit;
}

- (id)init
{
    self = [super init];
    if(self != nil)
    {
        _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
        _backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        
        _blockView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _backgroundView.frame.size.width, _backgroundView.frame.size.height)];
        _blockView.backgroundColor = [UIColor clearColor];
        [_backgroundView addSubview:_blockView];
        
        UITapGestureRecognizer *tapBlockView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBlockView:)];
        [_blockView addGestureRecognizer:tapBlockView];
        [tapBlockView release];
        
        _shareView = [[UIView alloc] initWithFrame:CGRectMake(0, _backgroundView.frame.size.height - 175, 320, 175)];
        _shareView.backgroundColor = [UIColor whiteColor];
        [_backgroundView addSubview:_shareView];
        
        _weiboButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        _weiboButton.frame = CGRectMake(15, 15, 60, 60);
        _weiboButton.backgroundColor = [UIColor clearColor];
        [_weiboButton setBackgroundImage:[UIImage imageNamed:@"btn_share_weibo.png"] forState:UIControlStateNormal];
        [_weiboButton addTarget:self action:@selector(clickWeiboButton:) forControlEvents:UIControlEventTouchUpInside];
        [_shareView addSubview:_weiboButton];
        
        _weixinButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        _weixinButton.frame = CGRectMake(_weiboButton.frame.origin.x + _weiboButton.frame.size.width + 15, _weiboButton.frame.origin.y, 60, 60);
        _weixinButton.backgroundColor = [UIColor clearColor];
        [_weixinButton setBackgroundImage:[UIImage imageNamed:@"btn_share_weixin.png"] forState:UIControlStateNormal];
        [_weixinButton addTarget:self action:@selector(clickWeixinButton:) forControlEvents:UIControlEventTouchUpInside];
        [_shareView addSubview:_weixinButton];
        
        _friendButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        _friendButton.frame = CGRectMake(_weixinButton.frame.origin.x + _weixinButton.frame.size.width + 15, _weixinButton.frame.origin.y, 60, 60);
        _friendButton.backgroundColor = [UIColor clearColor];
        [_friendButton setBackgroundImage:[UIImage imageNamed:@"btn_share_friend.png"] forState:UIControlStateNormal];
        [_friendButton addTarget:self action:@selector(clickFriendButton:) forControlEvents:UIControlEventTouchUpInside];
        [_shareView addSubview:_friendButton];
    }
    
    return self;
}

- (void)show
{
    [[[[UIApplication sharedApplication] delegate] window] addSubview:_backgroundView];
    _shareView.transform = CGAffineTransformMake(1, 0, 0, 1, 0, _shareView.frame.size.height);
    [UIView animateWithDuration:0.35
                     animations:^{
                         _shareView.transform = CGAffineTransformIdentity;
                     }];
}

- (void)hide
{
    [UIView animateWithDuration:0.35
                     animations:^{
                         _shareView.transform = CGAffineTransformMake(1, 0, 0, 1, 0, _shareView.frame.size.height);
                     } completion:^(BOOL finished) {
                         [_backgroundView removeFromSuperview];
                     }];
}

#pragma mark - UIGestureRecognizer

- (void)tapBlockView:(UITapGestureRecognizer *)gestureRecognizer
{
    if(gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        [self hide];
    }
}

@end
