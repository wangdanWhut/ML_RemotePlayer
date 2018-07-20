//
//  RemoteModuleAPI.h
//  ML_RemotePlayer
//
//  Created by 王丹 on 2018/7/20.
//  Copyright © 2018年 王丹. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RemoteModuleAPI : NSObject
+ (void)playerMedia:(NSArray *)param;
+ (void)pause;
@end
