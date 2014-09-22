//
//  LMObject.m
//  LMCharacter
//
//  Created by lide on 14-4-22.
//  Copyright (c) 2014年 lide. All rights reserved.
//

#import "LPObject.h"
#include "objc/runtime.h"

@implementation LPObject

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    unsigned int propertyCount = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &propertyCount);
    
    for(unsigned int i = 0; i < propertyCount; i++)
    {
        objc_property_t property = properties[i];
        const char *name = property_getName(property);
        const char *type = property_getAttributes(property);
        NSString *typeString = [NSString stringWithUTF8String:type];
        NSArray *attributes = [typeString componentsSeparatedByString:@","];
        NSString *typeAttribute = [attributes objectAtIndex:0];
        NSString *propertyType = [typeAttribute substringFromIndex:1];
        const char *rawPropertyType = [propertyType UTF8String];
        
        if(strcmp(rawPropertyType, @encode(float)) == 0)
        {
            //it's a float
            SEL selector = sel_registerName(name);
            if ([self respondsToSelector:selector]) {
                NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                            [[self class] instanceMethodSignatureForSelector:selector]];
                [invocation setSelector:selector];
                [invocation setTarget:self];
                [invocation invoke];
                float returnValue;
                [invocation getReturnValue:&returnValue];
                
                [aCoder encodeFloat:returnValue forKey:[NSString stringWithUTF8String:name]];
            }
        }
        else if (strcmp(rawPropertyType, @encode(int)) == 0 || strcmp(rawPropertyType, @encode(NSInteger)) == 0 || strcmp(rawPropertyType, @encode(NSUInteger)) == 0)
        {
            //it's an int
            SEL selector = sel_registerName(name);
            if ([self respondsToSelector:selector]) {
                NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                            [[self class] instanceMethodSignatureForSelector:selector]];
                [invocation setSelector:selector];
                [invocation setTarget:self];
                [invocation invoke];
                int returnValue;
                [invocation getReturnValue:&returnValue];
                
                [aCoder encodeInt:returnValue forKey:[NSString stringWithUTF8String:name]];
            }
        }
        else if (strcmp(rawPropertyType, @encode(BOOL)) == 0)
        {
            //it's an bool
            SEL selector = sel_registerName(name);
            if ([self respondsToSelector:selector]) {
                NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                            [[self class] instanceMethodSignatureForSelector:selector]];
                [invocation setSelector:selector];
                [invocation setTarget:self];
                [invocation invoke];
                BOOL returnValue;
                [invocation getReturnValue:&returnValue];
                
                [aCoder encodeBool:returnValue forKey:[NSString stringWithUTF8String:name]];
            }
        }
        else if (strcmp(rawPropertyType, @encode(int32_t)) == 0 || strcmp(rawPropertyType, @encode(long)) == 0)
        {
            //it's an long
            SEL selector = sel_registerName(name);
            if ([self respondsToSelector:selector]) {
                NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                            [[self class] instanceMethodSignatureForSelector:selector]];
                [invocation setSelector:selector];
                [invocation setTarget:self];
                [invocation invoke];
                int32_t returnValue;
                [invocation getReturnValue:&returnValue];
                
                [aCoder encodeInt32:returnValue forKey:[NSString stringWithUTF8String:name]];
            }
        }
        else if (strcmp(rawPropertyType, @encode(int64_t)) == 0 || strcmp(rawPropertyType, @encode(long long)) == 0)
        {
            //it's an long long
            SEL selector = sel_registerName(name);
            if ([self respondsToSelector:selector]) {
                NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                            [[self class] instanceMethodSignatureForSelector:selector]];
                [invocation setSelector:selector];
                [invocation setTarget:self];
                [invocation invoke];
                int64_t returnValue;
                [invocation getReturnValue:&returnValue];
                
                [aCoder encodeInt64:returnValue forKey:[NSString stringWithUTF8String:name]];
            }
        }
        else if (strcmp(rawPropertyType, @encode(double)) == 0)
        {
            //it's an double
            SEL selector = sel_registerName(name);
            if ([self respondsToSelector:selector]) {
                NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                            [[self class] instanceMethodSignatureForSelector:selector]];
                [invocation setSelector:selector];
                [invocation setTarget:self];
                [invocation invoke];
                double returnValue;
                [invocation getReturnValue:&returnValue];
                
                [aCoder encodeDouble:returnValue forKey:[NSString stringWithUTF8String:name]];
            }
        }
        else
        {
            //it's some sort of object
            SEL selector = sel_registerName(name);
            if ([self respondsToSelector:selector]) {
                NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                            [[self class] instanceMethodSignatureForSelector:selector]];
                [invocation setSelector:selector];
                [invocation setTarget:self];
                [invocation invoke];
                id returnValue;
                [invocation getReturnValue:&returnValue];
                
                [aCoder encodeObject:returnValue forKey:[NSString stringWithUTF8String:name]];
            }
        }
    }
    free(properties);
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self != nil)
    {
        unsigned int propertyCount = 0;
        objc_property_t *properties = class_copyPropertyList([self class], &propertyCount);
        
        for(unsigned int i = 0; i < propertyCount; i++)
        {
            objc_property_t property = properties[i];
            const char *name = property_getName(property);
            const char *type = property_getAttributes(property);
            NSString *typeString = [NSString stringWithUTF8String:type];
            NSArray *attributes = [typeString componentsSeparatedByString:@","];
            NSString *typeAttribute = [attributes objectAtIndex:0];
            NSString *propertyType = [typeAttribute substringFromIndex:1];
            const char *rawPropertyType = [propertyType UTF8String];
            
            const char *setterName = property_copyAttributeValue(property, "S");
            if(setterName == NULL)
            {
                NSString *nameString = [NSString stringWithUTF8String:name];
                NSString *leftString = [NSString stringWithFormat:@"set%@", [[nameString substringToIndex:1] uppercaseString]];
                NSString *rightString = [NSString stringWithFormat:@"%@:", [nameString substringFromIndex:1]];
                setterName = [[leftString stringByAppendingString:rightString] UTF8String];
            }
            
            if(strcmp(rawPropertyType, @encode(float)) == 0)
            {
                //it's a float
                SEL selector = sel_registerName(setterName);
                if ([self respondsToSelector:selector]) {
                    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                                [[self class] instanceMethodSignatureForSelector:selector]];
                    [invocation setSelector:selector];
                    [invocation setTarget:self];
                    
                    float value = [aDecoder decodeFloatForKey:[NSString stringWithUTF8String:name]];;
                    [invocation setArgument:&value atIndex:2];
                    [invocation invoke];
                }
            }
            else if (strcmp(rawPropertyType, @encode(int)) == 0 || strcmp(rawPropertyType, @encode(NSInteger)) == 0 || strcmp(rawPropertyType, @encode(NSUInteger)) == 0)
            {
                //it's an int
                SEL selector = sel_registerName(setterName);
                if ([self respondsToSelector:selector]) {
                    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                                [[self class] instanceMethodSignatureForSelector:selector]];
                    [invocation setSelector:selector];
                    [invocation setTarget:self];
                    
                    NSInteger value = [aDecoder decodeIntForKey:[NSString stringWithUTF8String:name]];;
                    [invocation setArgument:&value atIndex:2];
                    [invocation invoke];
                }
            }
            else if (strcmp(rawPropertyType, @encode(BOOL)) == 0)
            {
                //it's an bool
                SEL selector = sel_registerName(setterName);
                if ([self respondsToSelector:selector]) {
                    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                                [[self class] instanceMethodSignatureForSelector:selector]];
                    [invocation setSelector:selector];
                    [invocation setTarget:self];
                    
                    BOOL value = [aDecoder decodeBoolForKey:[NSString stringWithUTF8String:name]];;
                    [invocation setArgument:&value atIndex:2];
                    [invocation invoke];
                }
            }
            else if (strcmp(rawPropertyType, @encode(int32_t)) == 0 || strcmp(rawPropertyType, @encode(long)) == 0)
            {
                //it's an long
                SEL selector = sel_registerName(setterName);
                if ([self respondsToSelector:selector]) {
                    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                                [[self class] instanceMethodSignatureForSelector:selector]];
                    [invocation setSelector:selector];
                    [invocation setTarget:self];
                    
                    int32_t value = [aDecoder decodeInt32ForKey:[NSString stringWithUTF8String:name]];;
                    [invocation setArgument:&value atIndex:2];
                    [invocation invoke];
                }
            }
            else if (strcmp(rawPropertyType, @encode(int64_t)) == 0 || strcmp(rawPropertyType, @encode(long long)) == 0)
            {
                //it's an long long
                SEL selector = sel_registerName(setterName);
                if ([self respondsToSelector:selector]) {
                    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                                [[self class] instanceMethodSignatureForSelector:selector]];
                    [invocation setSelector:selector];
                    [invocation setTarget:self];
                    
                    int64_t value = [aDecoder decodeInt64ForKey:[NSString stringWithUTF8String:name]];;
                    [invocation setArgument:&value atIndex:2];
                    [invocation invoke];
                }
            }
            else if (strcmp(rawPropertyType, @encode(double)) == 0)
            {
                //it's an double
                SEL selector = sel_registerName(setterName);
                if ([self respondsToSelector:selector]) {
                    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                                [[self class] instanceMethodSignatureForSelector:selector]];
                    [invocation setSelector:selector];
                    [invocation setTarget:self];
                    
                    double value = [aDecoder decodeDoubleForKey:[NSString stringWithUTF8String:name]];;
                    [invocation setArgument:&value atIndex:2];
                    [invocation invoke];
                }
            }
            else
            {
                //it's some sort of object
                SEL selector = sel_registerName(setterName);
                if ([self respondsToSelector:selector]) {
                    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                                [[self class] instanceMethodSignatureForSelector:selector]];
                    [invocation setSelector:selector];
                    [invocation setTarget:self];
                    
                    id value = [aDecoder decodeObjectForKey:[NSString stringWithUTF8String:name]];;
                    [invocation setArgument:&value atIndex:2];
                    [invocation invoke];
                }
            }
        }
        free(properties);
    }
    return self;
}

@end
