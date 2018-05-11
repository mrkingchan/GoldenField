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
            continue;
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
            continue;
        }
        [model setValue:value forKey:propertyName];
    }
    return model;
}

#pragma mark  -- private Method

 -(id)modelToJson {
    /*NSMutableDictionary *json = [NSMutableDictionary new];
    unsigned int count = 0;
//    Ivar *vars = class_copyIvarList([self class], &count);
     objc_property_t  *properties = class_copyPropertyList([self class], &count);
    for (int i = 0; i < count; i ++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        id value = [self valueForKey:key];
        if (value == nil) {
            //做默认空字符串处理
            value = @"";
        }
        if (DEBUG) {
            NSLog(@"key = %@ -value = %@",key,value);
        }
        [json setValue:value forKey:key];
    }
    return json;*/
     
     NSMutableDictionary * (^complete)(_Nonnull Class) = ^ (Class class) {
         unsigned int count = 0;
         NSMutableDictionary *json = [NSMutableDictionary new];
         objc_property_t *properties = class_copyPropertyList(class, &count);
         for (int i = 0; i < count; i ++) {
             NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
             id value = [self valueForKey:key];
             if (value == nil) {
                 value = @"";
             }
             if (DEBUG) {
                 NSLog(@"key = %@ -value = %@",key,value);
             }
             [json setValue:value forKey:key];
         }
         return json;
     };
     return complete([self class]);
}

+(id)jsonToModel:(NSDictionary *)json {
      /*id model = [[self class] new];
    unsigned int count = 0;
    //使用var会出现下划线
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
       */
    id (^complete) (_Nonnull Class,NSDictionary *) = ^ (Class class,NSDictionary *jsonValue) {
        id model = [class new];
        unsigned int count = 0;
        objc_property_t *propertis = class_copyPropertyList(class, &count);
        for (int i = 0; i < count; i ++) {
            NSString *key = [NSString stringWithUTF8String:property_getName(propertis[i])];
            id value = [jsonValue valueForKey:key];
            if (value == nil) {
                value = @"";
            }
            if (DEBUG) {
                NSLog(@"key = %@ -value = %@",key,value);
            }
            [model setValue:value forKey:key];
        }
        return model;
    };
    return complete([self class],json);
}

#pragma mark  -- DataBase Support
#pragma mark - DB
+ (LKDBHelper *)getUsingLKDBHelper {
    static LKDBHelper* db;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *sqlitePath = [BaseModel downloadPath];
        NSString *dbpath = [sqlitePath stringByAppendingPathComponent:[NSString stringWithFormat:@"GoldenField.db"]];
        if (DEBUG) {
         NSLog(@"数据库地址:%@",dbpath);
        }
        db = [[LKDBHelper alloc]initWithDBPath:dbpath];
    });
    return db;
}

#pragma mark --DBPath
+ (NSString *)downloadPath {
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *downloadPath = [documentPath stringByAppendingPathComponent:@"GoldenField"];
    if (DEBUG) {
        NSLog(@"downloadPath:%@",downloadPath);
    }
    return downloadPath;
}

#pragma mark --create Table
+ (NSString *)getCreateTableSQL {
    LKModelInfos *infos = [self getModelInfos];
    //主键
    NSString *primaryKey = [self getPrimaryKey];
    //表参数
    NSMutableString *tablePars = [NSMutableString string];
    for (int i = 0; i < infos.count; i++) {
        if(i > 0) {
            [tablePars appendString:@","];
        }
        LKDBProperty* property =  [infos objectWithIndex:i];
        [self columnAttributeWithProperty:property];
        [tablePars appendFormat:@"%@ %@", property.sqlColumnName, property.sqlColumnType];
        
        if([property.sqlColumnType isEqualToString:LKSQL_Type_Text]) {
            if(property.length > 0) {
                [tablePars appendFormat:@"(%ld)", (long)property.length];
            }
        }
        if(property.isNotNull) {
            [tablePars appendFormat:@" %@", LKSQL_Attribute_NotNull];
        }
        if(property.isUnique) {
            [tablePars appendFormat:@" %@", LKSQL_Attribute_Unique];
        }
        if(property.checkValue) {
            [tablePars appendFormat:@" %@(%@)", LKSQL_Attribute_Check, property.checkValue];
        }
        if(property.defaultValue) {
            [tablePars appendFormat:@" %@ %@", LKSQL_Attribute_Default, property.defaultValue];
        }
        if(primaryKey && [property.sqlColumnName isEqualToString:primaryKey]) {
            [tablePars appendFormat:@" %@", LKSQL_Attribute_PrimaryKey];
        }
    }
    NSString* createTableSQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(%@)", [self getTableName], tablePars];
    return createTableSQL;
}
@end
