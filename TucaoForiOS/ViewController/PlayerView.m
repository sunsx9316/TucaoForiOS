//
//  PlayerView.m
//  TucaoForiOS
//
//  Created by JimHuang on 16/9/2.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "PlayerView.h"
#import "VideoNetManager.h"
#import "DanmakuNetManager.h"
#import "MBProgressHUD+Tools.h"

@interface PlayerView ()
//@property (strong, nonatomic) UIView *holdView;
@property (strong, nonatomic) JHDanmakuEngine *danmakuEngine;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@end

@implementation PlayerView
{
    NSUInteger _currentEpisode;
    NSUInteger _currentSource;
    BOOL _isDragProgress;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blackColor];
//        self.player.view.frame = self.bounds;
        self.danmakuEngine.canvas.frame = self.bounds;
        self.playerUIView.frame = self.bounds;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerStatusChange:) name:IJKMPMoviePlayerPlaybackStateDidChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerLoadStateChangeaNotification:) name:IJKMPMoviePlayerLoadStateDidChangeNotification object:nil];
    }
    return self;
}

- (void)setVideoModel:(VideoModel *)videoModel {
    _videoModel = videoModel;
    self.playerUIView.titleLabel.text = _videoModel.title;
    [self URLWithCurrentIndexCompletion:^(VideoURLModel *model, NSURL *url) {
        if (!model) return;
        
        if (!url) {
            //获取播放地址
            [VideoNetManager videoPlayURLWithType:model.type vid:model.vid completionHandler:^(NSArray *URLs, TucaoErrorModel *error) {
                model.playURLs = URLs;
                //获取弹幕
                [DanmakuNetManager danmakuDicWithHid:videoModel.hid part:[NSString stringWithFormat:@"%ld", _currentEpisode] completionHandler:^(NSDictionary *danmakuDic, TucaoErrorModel *error) {
                    
                    if (_currentSource < URLs.count) {
                         _player = [self configFFMoviePlayerWithUrl:URLs[_currentSource]];
                        [self insertSubview:_player.view atIndex:0];
                        [self.player prepareToPlay];
                    }
                    else {
                        [MBProgressHUD showOnlyText:@"视频不存在" parentView:self];
                    }
                    
                    [self.danmakuEngine sendAllDanmakusDic:danmakuDic];
                }];
            }];
        }
        else {
            _player = [self configFFMoviePlayerWithUrl:url];
            [self insertSubview:_player.view atIndex:0];
            [self.player prepareToPlay];
        }
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.player.view.frame = self.bounds;
    self.danmakuEngine.canvas.frame = self.bounds;
    self.playerUIView.frame = self.bounds;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.playerUIView.isShowing) {
        [self.playerUIView dismiss];
    }
    else {
        [self.playerUIView show];
    }
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.player shutdown];
}

#pragma mark - IJKPlayer
- (void)playerStatusChange:(NSNotification *)aNotification {
    if (self.player.playbackState == IJKMPMoviePlaybackStatePlaying) {
        self.playerUIView.playButton.selected = YES;
        [self.danmakuEngine start];
    }
    else if (self.player.playbackState == IJKMPMoviePlaybackStatePaused) {
        self.playerUIView.playButton.selected = NO;
        [self.danmakuEngine pause];
    }
}

- (void)playerLoadStateChangeaNotification:(NSNotification *)aNotification {
    if (self.player.loadState == IJKMPMovieLoadStateStalled) {
        
    }
    NSLog(@"\n======== %ld =========\n", self.player.loadState);
}

//#pragma mark - VLCMediaPlayerDelegate
//- (void)mediaPlayerStateChanged:(NSNotification *)aNotification {
//    VLCMediaPlayerState state = self.player.state;
//    NSLog(@"播放器状态: %@", VLCMediaPlayerStateToString(state));
//    if (state == VLCMediaPlayerStatePaused) {
//        [self.danmakuEngine pause];
//    }
//    else if (state == VLCMediaPlayerStatePlaying || state == VLCMediaPlayerStateBuffering) {
//        [self.danmakuEngine start];
//        [self.danmakuEngine setCurrentTime:self.player.currentTime];
//        [MBProgressHUD hideIndeterminateHUD];
//    }
//}
//
//- (void)mediaPlayerTimeChanged:(NSNotification *)aNotification {
//    if (!_isDragProgress) {
//        float nowTime = _player.currentTime;
//        float videoTime = _player.totalTime;
//        NSString *nowDateTime = [self.dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceReferenceDate:nowTime]];
//        NSString *videoDateTime = [self.dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceReferenceDate:videoTime]];
//        if (!(videoDateTime && nowDateTime)) return;
//        self.playerUIView.currentTimeLabel.text = nowDateTime;
//        self.playerUIView.videolengthLabel.text = videoDateTime;
//        self.playerUIView.playerProgressSlider.value = nowTime / videoTime;
//    }
//}

#pragma mark - 私有方法
- (void)touchPlayButton:(UIButton *)button {
//    button.selected = !button.isSelected;
    self.player.isPlaying ? [self.player pause] : [self.player play];
}

- (void)touchDanmakuHideButton:(UIButton *)button {
    button.selected = !button.isSelected;
    self.danmakuEngine.canvas.hidden = button.isSelected;
}

- (void)touchDanmakuConfigButton:(UIButton *)button {
    
}

/**
 *  更换播放地址
 *
 *  @param button 播放按钮
 */
- (void)touchPlaySourseButton:(UIButton *)button {
    
}

/**
 *  更换分集
 *
 *  @param button 分集按钮
 */
- (void)touchEpisodeButton:(UIButton *)button {
    
}

- (void)touchFullScreenButton:(UIButton *)button {
    BOOL isSelected = !button.isSelected;
    self.playerUIView.backButton.selected = isSelected;
    self.playerUIView.fullScreenButton.selected = isSelected;
    self.playerUIView.playButton.hidden = !isSelected;
    self.playerUIView.topView.hidden = !isSelected;
    [self.playerUIView show];
    if (self.touchFullScreenCallBack) {
        self.touchFullScreenCallBack(isSelected);
    }
}

- (void)touchPlayerProgressSliderIn:(UISlider *)slider {
    _isDragProgress = YES;
}

- (void)touchPlayerProgressSliderOut:(UISlider *)slider {
    _isDragProgress = NO;
    self.player.currentPlaybackTime = slider.value * self.player.duration;
    [MBProgressHUD showIndeterminateHUDWithView:self.player.view text:nil];
}

- (IJKFFMoviePlayerController *)configFFMoviePlayerWithUrl:(NSURL *)url {
    IJKFFMoviePlayerController *player = [[IJKFFMoviePlayerController alloc] initWithContentURL:url withOptions:[IJKFFOptions optionsByDefault]];
    player.scalingMode = IJKMPMovieScalingModeAspectFit;
    player.shouldAutoplay = YES;
    return player;
}

#pragma mark - 私有方法
- (void)URLWithCurrentIndexCompletion:(void(^)(VideoURLModel *model, NSURL *url))completion {
    if (_currentEpisode < _videoModel.URLs.count) {
        VideoURLModel *urlModel = _videoModel.URLs[_currentEpisode];
        if (_currentSource < urlModel.playURLs.count) {
            completion(urlModel, urlModel.playURLs[_currentSource]);
        }
        else {
            completion(urlModel, nil);
        }
    }
    completion(nil, nil);
}

#pragma mark - 懒加载
- (PlayerUIView *)playerUIView {
	if(_playerUIView == nil) {
		_playerUIView = [[PlayerUIView alloc] initWithFrame:self.bounds];
        [_playerUIView.backButton addTarget:self action:@selector(touchFullScreenButton:) forControlEvents:UIControlEventTouchUpInside];
        [_playerUIView.playButton addTarget:self action:@selector(touchPlayButton:) forControlEvents:UIControlEventTouchUpInside];
        [_playerUIView.danmakuHideButton addTarget:self action:@selector(touchDanmakuHideButton:) forControlEvents:UIControlEventTouchUpInside];
        [_playerUIView.danmakuConfigButton addTarget:self action:@selector(touchDanmakuConfigButton:) forControlEvents:UIControlEventTouchUpInside];
        [_playerUIView.playSourseButton addTarget:self action:@selector(touchPlaySourseButton:) forControlEvents:UIControlEventTouchUpInside];
        [_playerUIView.episodeButton addTarget:self action:@selector(touchEpisodeButton:) forControlEvents:UIControlEventTouchUpInside];
        [_playerUIView.fullScreenButton addTarget:self action:@selector(touchFullScreenButton:) forControlEvents:UIControlEventTouchUpInside];
        [_playerUIView.playerProgressSlider addTarget:self action:@selector(touchPlayerProgressSliderIn:) forControlEvents:UIControlEventTouchDown];
        [_playerUIView.playerProgressSlider addTarget:self action:@selector(touchPlayerProgressSliderOut:) forControlEvents:UIControlEventTouchUpInside];
        [self insertSubview:_playerUIView atIndex:2];
	}
	return _playerUIView;
}

- (JHDanmakuEngine *)danmakuEngine {
	if(_danmakuEngine == nil) {
		_danmakuEngine = [[JHDanmakuEngine alloc] init];
        _danmakuEngine.turnonBackFunction = YES;
        [self insertSubview:_danmakuEngine.canvas atIndex:1];
	}
	return _danmakuEngine;
}

//- (UIView *)holdView {
//	if(_holdView == nil) {
//		_holdView = [[UIView alloc] init];
//        [self addSubview:_holdView];
//	}
//	return _holdView;
//}

- (NSDateFormatter *)dateFormatter {
    if(_dateFormatter == nil) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"mm:ss";
    }
    return _dateFormatter;
}

@end
