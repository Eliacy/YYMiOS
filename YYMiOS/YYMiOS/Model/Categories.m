//
//  Category.m
//  YYMiOS
//
//  Created by lide on 14-10-15.
//  Copyright (c) 2014年 Lide. All rights reserved.
//

#import "Categories.h"

@implementation Categories

@synthesize categoryId = _categoryId;
@synthesize categoryName = _categoryName;
@synthesize categoryOrder = _categoryOrder;
@synthesize subCategoryArray = _subCategoryArray;

- (id)initWithAttribute:(NSDictionary *)attribute
{
    self = [super init];
    if(self != nil)
    {
        if(attribute != nil)
        {
            if([attribute objectForKey:@"id"] && ![[attribute objectForKey:@"id"] isEqual:[NSNull null]])
            {
                self.categoryId = [[attribute objectForKey:@"id"] integerValue];
            }
            if([attribute objectForKey:@"name"] && ![[attribute objectForKey:@"name"] isEqual:[NSNull null]])
            {
                self.categoryName = [attribute objectForKey:@"name"];
            }
            if([attribute objectForKey:@"order"] && ![[attribute objectForKey:@"order"] isEqual:[NSNull null]])
            {
                self.categoryOrder = [[attribute objectForKey:@"order"] integerValue];
            }
            if([attribute objectForKey:@"sub_categories"] && ![[attribute objectForKey:@"sub_categories"] isEqual:[NSNull null]])
            {
                NSArray *array = [attribute objectForKey:@"sub_categories"];
                NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:0];
                if(array && [array isKindOfClass:[NSArray class]] && [array count] > 0)
                {
                    for(NSDictionary *dictionary in array)
                    {
                        Categories *category = [[Categories alloc] initWithAttribute:dictionary];
                        [mutableArray addObject:category];
                        [category release];
                    }
                }
                self.subCategoryArray = mutableArray;
            }
        }
    }
    
    return self;
}

+ (NSArray *)parseFromeDictionary:(NSDictionary *)dictionary
{
    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:0];
    
    if(dictionary && [dictionary isKindOfClass:[NSDictionary class]])
    {
        if([dictionary objectForKey:@"data"])
        {
            dictionary = [dictionary objectForKey:@"data"];
        }
        
        if([dictionary isKindOfClass:[NSArray class]])
        {
            for(NSDictionary *attribute in (NSArray *)dictionary)
            {
                Categories *category = [[Categories alloc] initWithAttribute:attribute];
                [mutableArray addObject:category];
                [category release];
            }
        }
        else if([dictionary isKindOfClass:[NSDictionary class]])
        {
            Categories *category = [[Categories alloc] initWithAttribute:dictionary];
            [mutableArray addObject:category];
            [category release];
        }
    }
    else if([dictionary isKindOfClass:[NSArray class]])
    {
        for(NSDictionary *attribute in (NSArray *)dictionary)
        {
            Categories *category = [[Categories alloc] initWithAttribute:attribute];
            [mutableArray addObject:category];
            [category release];
        }
    }
    
    return mutableArray;
}

+ (void)getCategoryListWithCategoryId:(NSInteger)categoryId
                              success:(LPObjectSuccessBlock)successBlock
                              failure:(LPObjectFailureBlock)failureBlock
{
    [[LPAPIClient sharedAPIClient] getCategoryListWithCategoryId:categoryId
                                                         success:^(id respondObject) {
                                                             if(successBlock)
                                                             {
                                                                 successBlock([Categories parseFromeDictionary:respondObject]);
                                                             }
                                                         } failure:^(NSError *error) {
                                                             if(failureBlock)
                                                             {
                                                                 failureBlock(error);
                                                             }
                                                         }];
}

@end
