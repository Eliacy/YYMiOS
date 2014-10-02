//
//  ShareKit.h
//  YYMiOS
//
//  Created by lide on 14-10-2.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ShareKitDelegate;

@interface ShareKit : NSObject
{
    id<ShareKitDelegate>    _delegate;
    
    UIView      *_backgroundView;
    UIView      *_blockView;
    
    UIView      *_shareView;
}

@property (assign, nonatomic) id<ShareKitDelegate> delegate;

+ (id)sharedKit;

- (void)show;
- (void)hide;

@end

@protocol ShareKitDelegate <NSObject>



@end
