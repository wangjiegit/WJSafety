//
//  WJSafety.m
//  LZLC
//
//  Created by 王杰 on 2018/7/18.
//  Copyright © 2018年 com.ystz.ysd. All rights reserved.
//

#import "WJSafety.h"
#import "WJMethodSwizzling.h"

@implementation NSArray (WJSafety)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        swizzleMethod(NSClassFromString(@"__NSArrayI"), @selector(objectAtIndex:), @selector(wj_objectAtIndex:));
        swizzleMethod(NSClassFromString(@"__NSArrayI"), @selector(objectAtIndexedSubscript:), @selector(wj_objectAtIndexedSubscript:));
    });
}

- (id)wj_objectAtIndex:(NSUInteger)index {
    if (index < self.count) return [self wj_objectAtIndex:index];
#ifdef DEBUG
    NSLog(@"不可变数组越界  类:%@  方法:%s 下标:%lu", NSStringFromClass(self.class), __func__, index);
#endif
    return nil;
}

- (id)wj_objectAtIndexedSubscript:(NSUInteger)idx {
    if (idx < self.count) return [self wj_objectAtIndexedSubscript:idx];
#ifdef DEBUG
    NSLog(@"不可变数组越界  类:%@  方法:%s 下标:%lu", NSStringFromClass(self.class), __func__, idx);
#endif
    return nil;
}

@end

@implementation NSMutableArray (WJSafety)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        swizzleMethod(NSClassFromString(@"__NSArrayM"), @selector(objectAtIndex:), @selector(wj_objectAtIndex:));
        swizzleMethod(NSClassFromString(@"__NSArrayM"), @selector(objectAtIndexedSubscript:), @selector(wj_objectAtIndexedSubscript:));
    });
}

- (id)wj_objectAtIndex:(NSUInteger)index {
    if (index < self.count) return [self wj_objectAtIndex:index];
#ifdef DEBUG
    NSLog(@"可变数组越界  类:%@  方法:%s 下标:%lu", NSStringFromClass(self.class), __func__, index);
#endif
    return nil;
}

- (id)wj_objectAtIndexedSubscript:(NSUInteger)idx {
    if (idx < self.count) return [self wj_objectAtIndexedSubscript:idx];
#ifdef DEBUG
    NSLog(@"可变数组越界  类:%@  方法:%s 下标:%lu", NSStringFromClass(self.class), __func__, (unsigned long)idx);
#endif
    return nil;
}

@end

