//
//  LPImage.h
//  YYMiOS
//
//  Created by Lide on 14-10-25.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "LPObject.h"

@interface LPImage : LPObject
{
    NSInteger   _imageId;
    NSString    *_imageURL;
}

@property (assign, nonatomic) NSInteger imageId;
@property (retain, nonatomic) NSString *imageURL;

- (id)initWithAttribute:(NSDictionary *)attribute;

@end
