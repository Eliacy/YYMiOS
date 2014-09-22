//
//  LMObject.h
//  LMCharacter
//
//  Created by lide on 14-4-22.
//  Copyright (c) 2014年 lide. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^LPObjectSuccessBlock)(NSArray *array);
typedef void (^LPObjectFailureBlock)(NSError *error);

@interface LPObject : NSObject <NSCoding>

@end
