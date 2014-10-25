//
//  User.h
//  YYMiOS
//
//  Created by lide on 14-10-10.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "LPObject.h"
#import "LPImage.h"

@interface User : LPObject
{
    LPImage     *_userIcon;
    NSInteger   _userId;
    NSString    *_userName;
}

@property (retain, nonatomic) LPImage *userIcon;
@property (assign, nonatomic) NSInteger userId;
@property (retain, nonatomic) NSString *userName;

- (id)initWithAttribute:(NSDictionary *)attribute;

@end
