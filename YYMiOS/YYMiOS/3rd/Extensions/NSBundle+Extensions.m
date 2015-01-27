//
//  NSBundle+Extensions.m
//  DiabetesManager
//
//  Created by majianglin on 13-5-30.
//  Copyright (c) 2013年 totemtec.com. All rights reserved.
//

#import "NSBundle+Extensions.h"

@implementation NSBundle (Extentions)

+ (NSString *)bundleIdentifier
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
}

+ (NSString *)bundleName
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
}

+ (NSString *)bundleDisplayName
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
}

+ (NSString *)bundleVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+ (id)objectFromFile:(NSString *)fileName
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    if (data == nil)
    {
        return nil;
    }
    
    id object = nil;
    
    if ([fileName hasSuffix:@".json"])
    {
        NSError *error;
        object = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        if (error)
        {
            NSLog(@"read json file error: %@", error.localizedDescription);
        }
    }
    else if([fileName hasSuffix:@".plist"])
    {
        NSError *error;
        object = [NSPropertyListSerialization propertyListWithData:data
                                                           options:NSPropertyListImmutable
                                                            format:NULL
                                                             error:&error];
        if (error)
        {
            NSLog(@"read plist file error: %@", error.localizedDescription);
        }
	}
    
    return object;
}

@end
