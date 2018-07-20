//
//  RemoteModuleAPI.m
//  ML_RemotePlayer
//
//  Created by 王丹 on 2018/7/20.
//  Copyright © 2018年 王丹. All rights reserved.
//

#import "RemoteModuleAPI.h"
#import "MLRemotePlayer.h"
@implementation RemoteModuleAPI
+ (void)playerMedia:(NSArray *)param{
    [[MLRemotePlayer shareInstance] playWithURL:param[0] isCache:param[1]];
}
+ (void)pause{
    [[MLRemotePlayer shareInstance] pause];
}
@end
