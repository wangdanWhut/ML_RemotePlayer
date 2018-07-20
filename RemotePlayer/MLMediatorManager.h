//
//  MLMediatorManager.h
//
//  Created by Daniel on 18/7/19.
//  Copyright © 2018年 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLMediatorManager : NSObject


// 本地组件调用入口
+ (id)performTarget:(NSString *)targetName action:(NSString *)actionName params:(id)params isRequiredReturnValue: (BOOL)isRequiredReturnValue;


@end
