//
//  ViewController.m
//  ML_RemotePlayer
//
//  Created by Daniel on 2018/7/19.
//  Copyright © 2018年 Daniel. All rights reserved.
//

#import "ViewController.h"
#import "MLMediatorManager+RemotePlayer.h"
@interface ViewController ()

@end

@implementation ViewController
    
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
}
    
    
- (void)setUpUI{
    UIButton *playBtn = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 100)*0.5, 200, 100, 50)];
    [playBtn setTitle:@"播放" forState:UIControlStateNormal];
    [playBtn setTitle:@"暂停" forState:UIControlStateSelected];
    playBtn.backgroundColor = UIColor.redColor;
    [playBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    playBtn.layer.cornerRadius = 25;
    playBtn.clipsToBounds = YES;
    [self.view addSubview:playBtn];
    
}
- (void)btnClick:(UIButton *)btn{
    btn.selected = !btn.selected;
    if (btn.selected){
        
        if (![MLMediatorManager playerWithUrl:[NSURL URLWithString:@"http://audio.xmcdn.com/group47/M07/C0/51/wKgKk1tOa8qB4V-uADSMntf0894319.m4a"]]){
            NSLog(@"下载组件移除");
        }else{
            [MLMediatorManager playerWithUrl:[NSURL URLWithString:@"http://audio.xmcdn.com/group47/M07/C0/51/wKgKk1tOa8qB4V-uADSMntf0894319.m4a"]];
        }

    }else{
        if (![MLMediatorManager pause]){
            NSLog(@"下载组件移除");
        }else{
            [MLMediatorManager pause];
        }
        
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
    
    
    @end

