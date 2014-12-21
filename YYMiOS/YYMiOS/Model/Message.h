//
//  Message.h
//  YYMiOS
//
//  Created by Lide on 14/12/21.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "LPObject.h"

@interface Message : LPObject
{
    User            *_user;
    EMConversation  *_conversation;
}

@property (retain, nonatomic) User *user;
@property (retain, nonatomic) EMConversation *conversation;

@end
