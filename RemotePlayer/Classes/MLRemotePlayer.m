//
//  MLRemotePlayer.m
//  MLRemotePlayerLib
//
//  Created by Daniel on 2018/7/19.
//  Copyright © 2018年 Daniel. All rights reserved.
//

#import "MLRemotePlayer.h"
#import <AVFoundation/AVFoundation.h>
#import "MLResourceLoader.h"
#import "NSURL+MLAudio.h"

@interface MLRemotePlayer ()
{
    BOOL _isUserPause;
}
@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, strong) MLResourceLoader *resourceLoader;

@end


@implementation MLRemotePlayer

static MLRemotePlayer *_shareInstance;

+ (instancetype)shareInstance {
    if (!_shareInstance) {
        _shareInstance = [[MLRemotePlayer alloc] init];
    }
    return _shareInstance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {

    if (!_shareInstance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _shareInstance = [super allocWithZone:zone];
        });

    }
    return _shareInstance;
}

- (void)playWithURL: (NSURL *)url isCache:(BOOL)isCache {

    
    if ([self.url isEqual:url]) {
        
        if (self.state == MLRemotePlayerStatePlaying) {
            return;
        }
        if (self.state == MLRemotePlayerStatePause) {
            [self resume];
            return;
        }
        if (self.state == MLRemotePlayerStateLoading) {
            return;
        }
        
    }
    
    
    self.url = url;
    // 其实, 系统已经帮我们封装了三个步骤
    // [AVPlayer playerWithURL:url]
    // 1. 资源的请求
    // 2. 资源的组织 AVPlayerItem
    // 3. 资源的播放
    
    if (self.player.currentItem) {
        [self clearObserver:self.player.currentItem];
    }

    _isUserPause = NO;
    NSURL *lastURL = url;
    if (isCache) {
        lastURL = [url streamingURL];
    }
    AVURLAsset *asset = [AVURLAsset assetWithURL:lastURL];
    self.resourceLoader = [[MLResourceLoader alloc] init];
    [asset.resourceLoader setDelegate:self.resourceLoader queue:dispatch_queue_create(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:asset];
    
    // 监听资源的组织者, 有没有组织好数据
    [item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [item addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playIntrupt) name:AVPlayerItemPlaybackStalledNotification object:nil];
    [self.player pause];
    self.player = [AVPlayer playerWithPlayerItem:item];
    
    
}

- (void)pause{ 
    [self.player pause];
    if (self.player) {
        _isUserPause = YES;
        self.state = MLRemotePlayerStatePause;
    }
}

- (void)resume{
    
    [self.player play];
    if (self.player && self.player.currentItem.playbackLikelyToKeepUp) {
        _isUserPause = NO;
        self.state = MLRemotePlayerStatePlaying;
    }
    
}

- (void)stop{ 
    [self.player pause];
    [self clearObserver:self.player.currentItem];
    self.player = nil;
    self.state = MLRemotePlayerStateStopped;
}

- (void)setRate:(float)rate {
    self.player.rate = rate;
}
- (float)rate {
    return self.player.rate;
}

- (void)setVolume:(float)volume {
    if (volume > 0) {
        [self setMute:NO];
    }
    self.player.volume = volume;
}
- (float)volume {
    return self.player.volume;
}

- (void)setMute:(BOOL)mute {
    self.player.muted = mute;
}

- (BOOL)mute {
    return self.player.isMuted;
}


- (void)seekWithTime: (NSTimeInterval)time{
    double currentTime = self.currentTime + time;
    double totalTime = self.duration;
    
    [self setProgress:currentTime / totalTime];
    
}

- (double)duration {
    double time = CMTimeGetSeconds(self.player.currentItem.duration);
    if (isnan(time)) {
        return 0;
    }
    return time;
}

- (double)currentTime {
    
    double time = CMTimeGetSeconds(self.player.currentItem.currentTime);
    
    if (isnan(time)) {
        return 0;
    }
    return time;
}

- (float)progress {
    
    if (self.duration == 0) {
        return 0;
    }
    return self.currentTime / self.duration;
    
}

- (void)setProgress:(float)progress {
    double totalTime = self.duration;
    double currentTimeSec = totalTime * progress;
    CMTime playTime = CMTimeMakeWithSeconds(currentTimeSec, NSEC_PER_SEC);
    
    [self.player seekToTime:playTime completionHandler:^(BOOL finished) {
        
        if (finished) {
            NSLog(@"确认加载这个时间节点的数据");
        }else {
            NSLog(@"取消加载这个时间节点的播放数据");
        }
    }];
    
    
}

- (void)setState:(MLRemotePlayerState)state {
    _state = state;
    if (self.stateChange) {
        self.stateChange(state);
    }
    if (self.url) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kRemotePlayerURLOrStateChangeNotification object:nil userInfo:@{
                                                                                                                                   @"playURL": self.url,                                                                  @"playState": @(state)
                                                                                                                                   }];
    }

}

- (void)setUrl:(NSURL *)url {
    _url = url;

    if (self.url) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kRemotePlayerURLOrStateChangeNotification object:nil userInfo:@{
                                                                                                                                   @"playURL": self.url,                                                                  @"playState": @(self.state)

                                                                                                                                   }];
    }

}


-(float)loadProgress {
    
    CMTimeRange range = [self.player.currentItem.loadedTimeRanges.lastObject CMTimeRangeValue];
    CMTime loadTime = CMTimeAdd(range.start, range.duration);
    double loadTimeSec = CMTimeGetSeconds(loadTime);
    
    if (self.duration == 0) {
        return 0;
    }
    
    return loadTimeSec / self.duration;
    
    
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItemStatus status = [change[NSKeyValueChangeNewKey] integerValue];
        
        switch (status) {
            case AVPlayerItemStatusReadyToPlay:
            {
//                NSLog(@"准备完毕, 开始播放");
                [self resume];
                break;
            }
            case AVPlayerItemStatusFailed:
            {
                NSLog(@"数据准备失败, 无法播放");
                self.state = MLRemotePlayerStateFailed;
                break;
            }
                
            default:
            {
                NSLog(@"未知");
                self.state = MLRemotePlayerStateUnknown;
                break;
            }
        }
        
    }
    
    if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
        BOOL playbackLikelyToKeepUp = [change[NSKeyValueChangeNewKey] boolValue];
        if (playbackLikelyToKeepUp) {
//            NSLog(@"数据加载的足够播放了");
            
            if (!_isUserPause) {
                self.state = MLRemotePlayerStatePlaying;
                [self resume];
            }
   
        }else {
//            NSLog(@"数据不够播放");
            self.state = MLRemotePlayerStateLoading;
        }
    }
    
    
    
}

- (void)playEnd {
    self.state = MLRemotePlayerStateStopped;
    if (self.playEndBlock) {
        self.playEndBlock();
    }
    
}

- (void)playIntrupt {
    NSLog(@"播放被打断");
    self.state = MLRemotePlayerStatePause;
}


- (void)clearObserver: (AVPlayerItem *)item {
    
    [item removeObserver:self forKeyPath:@"status"];
    [item removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
    
}


- (void)dealloc {
    
    [self clearObserver:self.player.currentItem];
    
}


@end
