//
//  Constant.h
//  YYMiOS
//
//  Created by 关旭 on 15-1-20.
//  Copyright (c) 2015年 Lide. All rights reserved.
//

//调试输出
#ifdef DEBUG
#define GLog(format, ...) NSLog(format, ## __VA_ARGS__)
#else
#define GLog(format, ...)
#endif

//颜色
#define GColor(x,y,z)     [UIColor colorWithRed:x/255. green:y/255. blue:z/255. alpha:1]

//提示语显示时间
#define TOAST_DURATION 1.5

//用户昵称长度限制
#define USER_NAME_LENGTH 10