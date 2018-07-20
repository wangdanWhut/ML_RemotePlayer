//
//  MLMediatorManager+RemotePlayer.h
//  ML_RemotePlayer
//
//  Created by 王丹 on 2018/7/20.
//  Copyright © 2018年 王丹. All rights reserved.
//

#import "MLMediatorManager.h"

@interface MLMediatorManager (RemotePlayer)

//播放远程音乐
+ (BOOL )playerWithUrl:(NSURL *)url;

//停止
+ (BOOL)pause;
@end
