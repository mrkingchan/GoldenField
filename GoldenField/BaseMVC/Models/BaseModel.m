//
//  BaseModel.m
//  GoldenField
//
//  Created by Chan on 2018/5/9.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "BaseModel.h"
#import <objc/runtime.h>

@implementation BaseModel

#pragma mark  -- NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder {
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for (int i = 0 ; i < count; i ++) {
        NSString *propertyName = [NSString  stringWithUTF8String:property_getName(properties[i])];
        id value = [self valueForKey:propertyName];
        if (value == nil) {
            break;
        }
        [aCoder encodeObject:value forKey:propertyName];
    }
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    unsigned int count = 0;
    objc_property_t  *properties = class_copyPropertyList([self class], &count);
    id model = [[self class] new];
    for (int i = 0; i < count; i ++) {
        NSString *propertyName = [NSString stringWithUTF8String:property_getName(properties[i])];
        id value = [aDecoder decodeObjectForKey:propertyName];
        if (value == nil) {
            break;
        }
        [model setValue:value forKey:propertyName];
    }
    return model;
}

#pragma mark  -- private Method

 -(id)modelToJson {
    NSMutableDictionary *json = [NSMutableDictionary new];
    unsigned int count = 0;
//    Ivar *vars = class_copyIvarList([self class], &count);
     objc_property_t  *properties = class_copyPropertyList([self class], &count);

    for (int i = 0; i < count; i ++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        id value = [self valueForKey:key];
        if (value == nil) {
            //做空字符串处理
            value = @"";
        }
        if (DEBUG) {
            NSLog(@"key = %@ -value = %@",key,value);
        }
        [json setValue:value forKey:key];
    }
    return json;
}

+(id)jsonToModel:(NSDictionary *)json {
      id model = [[self class] new];
    unsigned int count = 0;
//    Ivar *vars = class_copyIvarList([self class], &count);
    objc_property_t  *properties = class_copyPropertyList([self class], &count);

    for (int i = 0; i < count; i ++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        id value = [json valueForKey:key];
        if (value == nil) {
            value = @"";
        }
        if (DEBUG) {
            NSLog(@"key = %@ -value = %@",key,value);
        }
        [model setValue:value forKey:key];
    }
    return model;
}
@end
