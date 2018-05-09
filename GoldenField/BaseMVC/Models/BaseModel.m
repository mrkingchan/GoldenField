//
//  BaseModel.m
//  GoldenField
//
//  Created by Macx on 2018/5/9.
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
@end
