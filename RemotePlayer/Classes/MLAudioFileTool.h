//
//  MLAudioFileTool.h
//  MLRemotePlayerLib
//
//  Created by Daniel on 2018/7/19.
//  Copyright © 2018年 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLAudioFileTool : NSObject

+ (NSString *)cachePathWithURL: (NSURL *)url;
+ (NSString *)tmpPathWithURL: (NSURL *)url;

+ (BOOL)isCacheFileExists: (NSURL *)url;
+ (BOOL)isTmpFileExists: (NSURL *)url;


+ (NSString *)contentTypeWithURL: (NSURL *)url;


+ (long long)cacheFileSizeWithURL: (NSURL *)url;
+ (long long)tmpFileSizeWithURL: (NSURL *)url;

+ (void)removeTmpFileWithURL: (NSURL *)url;


+ (void)moveTmpPathToCachePath: (NSURL *)url;

@end
