//
//  NSURL+MLAudio.m
//  MLRemotePlayerLib
//
//  Created by Daniel on 2018/7/19.
//  Copyright © 2018年 Daniel. All rights reserved.
//

#import "NSURL+MLAudio.h"

@implementation NSURL (MLAudio)

- (NSURL *)streamingURL {
    
    NSURLComponents *commpents = [NSURLComponents componentsWithString:self.absoluteString];
    [commpents setScheme:@"streaming"];
    
    return [commpents URL];
    
}

- (NSURL *)httpURL {
    NSURLComponents *commpents = [NSURLComponents componentsWithString:self.absoluteString];
    [commpents setScheme:@"http"];
    
    return [commpents URL];
}


@end
