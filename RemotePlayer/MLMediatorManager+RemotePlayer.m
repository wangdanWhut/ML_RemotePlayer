//
//  MLMediatorManager+RemotePlayer.m
//  ML_RemotePlayer
//
//  Created by 王丹 on 2018/7/20.
//  Copyright © 2018年 王丹. All rights reserved.
//

#import "MLMediatorManager+RemotePlayer.h"

@implementation MLMediatorManager (RemotePlayer)
+ (BOOL)playerWithUrl:(NSURL *)url{
    NSArray *param = @[url, @YES];
    return [self performTarget:@"RemoteModuleAPI" action:@"playerMedia:" params:param isRequiredReturnValue:NO];
}
+ (BOOL)pause{
    return [self performTarget:@"RemoteModuleAPI" action:@"pause" params:nil isRequiredReturnValue:NO];
}

@end
