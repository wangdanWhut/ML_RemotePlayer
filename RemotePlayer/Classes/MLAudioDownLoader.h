//
//  MLAudioDownLoader.h
//  MLRemotePlayerLib
//
//  Created by Daniel on 2018/7/19.
//  Copyright © 2018年 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MLAudioDownLoaderDelegate <NSObject>

- (void)downLoaderLoading;

@end


@interface MLAudioDownLoader : NSObject

@property (nonatomic, assign) long long loadedSize;
@property (nonatomic, assign) long long offset;
@property (nonatomic, copy) NSString *contentType;
@property (nonatomic, assign) long long totalSize;

@property (nonatomic, weak) id<MLAudioDownLoaderDelegate> delegate;

- (void)downLoadWithURL: (NSURL *)url offset: (long long)offset;


@end
