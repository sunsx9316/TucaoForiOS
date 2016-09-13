//
//  PlayerView.m
//  TucaoForiOS
//
//  Created by JimHuang on 16/9/2.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "PlayerView.h"
#import "PlayerUIView.h"
@interface PlayerView ()
@property (strong, nonatomic) PlayerUIView *playerUIView;
@end

@implementation PlayerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blackColor];
        [self addSubview:self.playerUIView];
        
        
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    self.playerUIView.frame = self.bounds;
}

#pragma mark - 私有方法
- (void)touchBackButton:(UIButton *)button {
    if (self.touchFullScreenCallBack) {
        self.touchFullScreenCallBack();
    }
}

- (void)touchPlayButton:(UIButton *)button {
    
}

- (void)touchDanmakuHideButton:(UIButton *)button {
    
}

- (void)touchDanmakuConfigButton:(UIButton *)button {
    
}

- (void)touchPlaySourseButton:(UIButton *)button {
    
}

- (void)touchEpisodeButton:(UIButton *)button {
    
}

- (void)touchFullScreenButton:(UIButton *)button {
    if (self.touchFullScreenCallBack) {
        self.touchFullScreenCallBack();
    }
}

- (void)touchPlayerProgressSlider:(UISlider *)slider {
    
}

#pragma mark - 懒加载
- (PlayerUIView *)playerUIView {
	if(_playerUIView == nil) {
		_playerUIView = [[PlayerUIView alloc] initWithFrame:self.bounds];
        [_playerUIView.backButton addTarget:self action:@selector(touchBackButton:) forControlEvents:UIControlEventTouchUpInside];
        [_playerUIView.playButton addTarget:self action:@selector(touchPlayButton:) forControlEvents:UIControlEventTouchUpInside];
        [_playerUIView.danmakuHideButton addTarget:self action:@selector(touchDanmakuHideButton:) forControlEvents:UIControlEventTouchUpInside];
        [_playerUIView.danmakuConfigButton addTarget:self action:@selector(touchDanmakuConfigButton:) forControlEvents:UIControlEventTouchUpInside];
        [_playerUIView.playSourseButton addTarget:self action:@selector(touchPlaySourseButton:) forControlEvents:UIControlEventTouchUpInside];
        [_playerUIView.episodeButton addTarget:self action:@selector(touchEpisodeButton:) forControlEvents:UIControlEventTouchUpInside];
        [_playerUIView.fullScreenButton addTarget:self action:@selector(touchFullScreenButton:) forControlEvents:UIControlEventTouchUpInside];
        [_playerUIView.playerProgressSlider addTarget:self action:@selector(touchPlayerProgressSlider:) forControlEvents:UIControlEventValueChanged];
	}
	return _playerUIView;
}

@end
