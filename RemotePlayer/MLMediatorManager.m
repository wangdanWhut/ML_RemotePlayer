//
//  MLMediatorManager.m
//
//  Created by Daniel on 18/7/19.
//  Copyright © 2018年 Daniel. All rights reserved.
//

#import "MLMediatorManager.h"

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

#import <objc/runtime.h>

@interface MLMediatorManager ()


@end

@implementation MLMediatorManager


// 本地组件调用入口
+ (id)performTarget:(NSString *)targetName action:(NSString *)actionName params:(id)params isRequiredReturnValue: (BOOL)isRequiredReturnValue {

    // MLMainModelTarget://log

    // 1. 获取目标
    Class targetCls = NSClassFromString(targetName);
    if (targetCls == nil) {
        NSLog(@"目标不存在");
        return nil;
    }

    // 2. 获取行为
    SEL sel = NSSelectorFromString(actionName);
    if (sel == nil) {
        NSLog(@"行为不存在");
        return nil;
    }

    //NSObject *obj = [[targetCls alloc] init];
    if (![targetCls respondsToSelector:sel]) {
        NSLog(@"目标不存在该方法");
        return nil;
    }


    if (isRequiredReturnValue) {
        SuppressPerformSelectorLeakWarning(return [targetCls performSelector:sel withObject:params]);
    }else {
        SuppressPerformSelectorLeakWarning([targetCls performSelector:sel withObject:params]);
    }

    return @1;
}


@end
