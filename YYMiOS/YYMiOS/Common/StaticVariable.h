//
//  StaticVariable.h
//  YYMiOS
//
//  Created by 关旭 on 15-2-12.
//  Copyright (c) 2015年 Lide. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StaticVariable : NSObject

/**
 *  单例，数据唯一
 */
+ (StaticVariable *) shared;

@end
