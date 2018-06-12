//
//  SwizzleManager.m
//  GoldenField
//
//  Created by Chan on 2018/5/29.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "SwizzleManager.h"
#import <objc/runtime.h>

@implementation SwizzleManager

+(void)swizzelInstanceMethodWithClass:(Class)orginClass
                       originSelector:(SEL)originSelector
                      swappedSelector:(SEL)swappedSelector {
    
    Method originMethod = class_getInstanceMethod(orginClass, originSelector);
    Method newMethod = class_getInstanceMethod(orginClass, swappedSelector);
    
    BOOL didAddMethod = class_addMethod(orginClass, swappedSelector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod));
    if (didAddMethod) {
        //添加成功 replace
        class_replaceMethod(orginClass, swappedSelector, method_getImplementation(originMethod), method_getTypeEncoding(originMethod));
    } else {
        //后者替换前者
        method_exchangeImplementations(originMethod, newMethod);
    }
}

+(void)swizzleClassMethodWithClass:(Class)originClass
                    originSelector:(SEL)originSelector
                   swappedSelector:(SEL)swappedSelector {
    Method originMethod = class_getClassMethod(originClass, originSelector);
    Method newMethod = class_getClassMethod(originClass, swappedSelector);
    
    BOOL didAddMethod = class_addMethod(originClass, swappedSelector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod));
    if (didAddMethod) {
        // 添加成 replace
        class_replaceMethod(originClass, swappedSelector, method_getImplementation(originMethod), method_getTypeEncoding(originMethod));
    } else {
        method_exchangeImplementations(originMethod, newMethod);
    }
}
@end
