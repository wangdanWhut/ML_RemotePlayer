//
//  NSURL+MLAudio.h
//  MLRemotePlayerLib
//
//  Created by Daniel on 2018/7/19.
//  Copyright © 2018年 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (MLAudio)

- (NSURL *)streamingURL;

- (NSURL *)httpURL;

@end
