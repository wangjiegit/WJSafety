//
//  WJMethodSwizzling.h
//  
//
//  Created by wangjie on 15/11/25.
//
//

#import <Foundation/Foundation.h>

void swizzleMethod(Class cls, SEL originalSelector, SEL swizzledSelector);
