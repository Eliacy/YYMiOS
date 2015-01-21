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

// 颜色宏
#define GColor(x,y,z)     [UIColor colorWithRed:x/255. green:y/255. blue:z/255. alpha:1]

