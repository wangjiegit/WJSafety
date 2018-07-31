//
//  WJMethodSwizzling.m
//  
//
//  Created by wangjie on 15/11/25.
//
//

#import "WJMethodSwizzling.h"
#import <objc/runtime.h>

//静态就交换静态，实例方法就交换实例方法
void swizzleMethod(Class cls, SEL originalSelector, SEL swizzledSelector) {
    // the method might not exist in the class, but in its superclass
    Method originalMethod = class_getInstanceMethod(cls, originalSelector);
    Method swizzledMethod = nil;
    if (!originalMethod) {//处理为类的方法
        originalMethod = class_getClassMethod(cls, originalSelector);
        swizzledMethod = class_getClassMethod(cls, swizzledSelector);
        if (!originalMethod || !swizzledMethod) return;
    } else {//处理为事例的方法
        swizzledMethod = class_getInstanceMethod(cls, swizzledSelector);
        if (!swizzledMethod) return;
    }
    
    // class_addMethod will fail if original method already exists
    BOOL didAddMethod = class_addMethod(cls, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    // the method doesn’t exist and we just added one
    if (didAddMethod) {
        class_replaceMethod(cls, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}
