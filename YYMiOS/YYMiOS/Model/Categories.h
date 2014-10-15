//
//  Category.h
//  YYMiOS
//
//  Created by lide on 14-10-15.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "LPObject.h"

@interface Categories : LPObject
{
    NSInteger       _categoryId;
    NSString        *_categoryName;
    NSInteger       _categoryOrder;
    NSArray         *_subCategoryArray;
}

@property (assign, nonatomic) NSInteger categoryId;
@property (retain, nonatomic) NSString *categoryName;
@property (assign, nonatomic) NSInteger categoryOrder;
@property (retain, nonatomic) NSArray *subCategoryArray;

- (id)initWithAttribute:(NSDictionary *)attribute;

+ (void)getCategoryListWithCategoryId:(NSInteger)categoryId
                              success:(LPObjectSuccessBlock)successBlock
                              failure:(LPObjectFailureBlock)failureBlock;

@end
