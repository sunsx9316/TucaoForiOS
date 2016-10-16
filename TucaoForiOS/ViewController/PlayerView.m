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
#import "PlayerSlideView.h"

#define ANIMATE_TIME 0.4
#define EPISODE_TABLE_VIEW_WIDTH WIDTH * 0.5

@interface PlayerView ()<PlayerSlideViewDelegate, UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UIView *playerUIView;

/**
 *  返回按钮
 */
@property (strong, nonatomic) UIButton *backButton;
/**
 *  播放按钮
 */
@property (strong, nonatomic) UIButton *playButton;
/**
 *  弹幕设置按钮
 */
@property (strong, nonatomic) UIButton *danmakuConfigButton;
/**
 *  弹幕显示/隐藏按钮
 */
@property (strong, nonatomic) UIButton *danmakuHideButton;
/**
 *  播放源选择按钮
 */
@property (strong, nonatomic) UIButton *playSourseButton;
/**
 *  分集选择按钮
 */
@property (strong, nonatomic) UIButton *episodeButton;
/**
 *  全屏按钮
 */
@property (strong, nonatomic) UIButton *fullScreenButton;
/**
 *  进度
 */
@property (strong, nonatomic) PlayerSlideView *playerProgressSlider;
/**
 *  视频标题
 */
@property (strong, nonatomic) UILabel *titleLabel;
/**
 *  当前时间
 */
@property (strong, nonatomic) UILabel *currentTimeLabel;
/**
 *  视频长度
 */
@property (strong, nonatomic) UILabel *videolengthLabel;

@property (strong, nonatomic) UIView *bottomView;

@property (strong, nonatomic) UIView *topView;
/**
 *  分集tableView
 */
@property (strong, nonatomic) UITableView *episodeTableView;


@property (strong, nonatomic) JHDanmakuEngine *danmakuEngine;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSTimer *timer;
@end

@implementation PlayerView
{
    NSUInteger _currentEpisode;
    NSUInteger _currentSource;
    NSTimer *_autoHideTimer;
    BOOL _isDragProgress;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blackColor];
        self.danmakuEngine.canvas.frame = self.bounds;
        self.playerUIView.frame = self.bounds;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerStatusChange:) name:IJKMPMoviePlayerPlaybackStateDidChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerLoadStateChangeaNotification:) name:IJKMPMoviePlayerLoadStateDidChangeNotification object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerProgressChange:) name:IJKMPMoviePlayerPlaybackBufferDidChangeNotification object:nil];
    }
    return self;
}

- (void)setVideoModel:(VideoModel *)videoModel {
    _videoModel = videoModel;
    self.titleLabel.text = _videoModel.title;
    [self.episodeTableView reloadData];
    [self reloadVideo];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.player.view.frame = self.bounds;
    self.danmakuEngine.canvas.frame = self.bounds;
    self.playerUIView.frame = self.bounds;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self show];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *aView = [super hitTest:point withEvent:event];
    if (aView != self) {
        _autoHideTimer.fireDate = [NSDate dateWithTimeIntervalSinceNow:3];
    }
    return aView;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.player shutdown];
    [_timer invalidate];
}

- (void)show {
    [_autoHideTimer invalidate];
    self.playerUIView.layer.timeOffset = 0;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.duration = ANIMATE_TIME;
    animation.fromValue = @(self.playerUIView.layer.opacity);
    animation.toValue = @(1);
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.beginTime = CACurrentMediaTime();
    animation.delegate = self;
    [self.playerUIView.layer addAnimation:animation forKey:@"opacity_animation"];
    @weakify(self)
    _autoHideTimer = [NSTimer scheduledTimerWithTimeInterval:3 block:^(NSTimer * _Nonnull timer) {
        @strongify(self)
        if (!self) return;
        
        [self dismiss];
    } repeats:NO];
}

- (void)dismiss {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.duration = ANIMATE_TIME;
    animation.fromValue = @(self.playerUIView.layer.opacity);
    animation.toValue = @(0);
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.beginTime = CACurrentMediaTime();
    animation.delegate = self;
    [self.playerUIView.layer addAnimation:animation forKey:@"opacity_animation"];
}

- (void)animationDidStop:(CABasicAnimation *)anim finished:(BOOL)flag {
    float value = [anim.toValue floatValue];
    self.playerUIView.layer.opacity = value != 0;
}


#pragma mark - PlayerSlideViewDelegate
- (void)playerSliderTouchBeginWithPlayerSliderView:(PlayerSlideView *)playerSliderView {
    _isDragProgress = YES;
}

- (void)playerSliderTouchEnd:(CGFloat)endValue playerSliderView:(PlayerSlideView*)playerSliderView {
    _isDragProgress = NO;
    self.player.currentPlaybackTime = endValue * self.player.duration;
    [MBProgressHUD showIndeterminateHUDWithView:self.player.view text:nil];
}

#pragma mark - IJKPlayer
- (void)playerStatusChange:(NSNotification *)aNotification {
    if (self.player.playbackState == IJKMPMoviePlaybackStatePlaying) {
        self.playButton.selected = YES;
        [self.danmakuEngine start];
    }
    else if (self.player.playbackState == IJKMPMoviePlaybackStatePaused) {
        self.playButton.selected = NO;
        [self.danmakuEngine pause];
    }
}

- (void)playerLoadStateChangeaNotification:(NSNotification *)aNotification {
    [MBProgressHUD hideIndeterminateHUD];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _videoModel.URLs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.textLabel.text = _videoModel.URLs[indexPath.row].title;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _currentSource = indexPath.row;
    [self reloadVideo];
}

#pragma mark - 私有方法
- (void)touchPlayButton:(UIButton *)button {
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
    button.selected = !button.isSelected;
    
    if (button.isSelected) {
        [self.episodeTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_offset(0);
        }];
    }
    else {
        [self.episodeTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_offset(EPISODE_TABLE_VIEW_WIDTH);
        }];
    }
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:20 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self layoutIfNeeded];
    } completion:nil];
}

- (void)touchFullScreenButton:(UIButton *)button {
    BOOL isSelected = !button.isSelected;
    self.backButton.selected = isSelected;
    self.fullScreenButton.selected = isSelected;
    self.playButton.hidden = !isSelected;
    self.topView.hidden = !isSelected;
    [self show];
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
    [IJKFFMoviePlayerController setLogReport:NO];
    [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_INFO];
    IJKFFMoviePlayerController *player = [[IJKFFMoviePlayerController alloc] initWithContentURL:url withOptions:[IJKFFOptions optionsByDefault]];
    player.scalingMode = IJKMPMovieScalingModeAspectFit;
    player.shouldAutoplay = YES;
    [MBProgressHUD showIndeterminateHUDWithView:player.view text:nil];
    [self.timer fire];
    return player;
}

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

- (void)reloadVideo {
    [self.player stop];
    [self URLWithCurrentIndexCompletion:^(VideoURLModel *model, NSURL *url) {
        if (!model) return;
        
        if (!url) {
            //获取播放地址
            [VideoNetManager videoPlayURLWithType:model.type vid:model.vid completionHandler:^(NSArray *URLs, TucaoErrorModel *error) {
                model.playURLs = URLs;
                //获取弹幕
                [DanmakuNetManager danmakuDicWithHid:_videoModel.hid part:[NSString stringWithFormat:@"%ld", _currentEpisode] completionHandler:^(NSDictionary *danmakuDic, TucaoErrorModel *error) {
                    
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
            [DanmakuNetManager danmakuDicWithHid:_videoModel.hid part:[NSString stringWithFormat:@"%ld", _currentEpisode] completionHandler:^(NSDictionary *danmakuDic, TucaoErrorModel *error) {
                _player = [self configFFMoviePlayerWithUrl:url];
                [self insertSubview:_player.view atIndex:0];
                [self.player prepareToPlay];
                [self.danmakuEngine sendAllDanmakusDic:danmakuDic];
            }];
        }
    }];
}


#pragma mark - 懒加载
- (UIView *)playerUIView {
	if(_playerUIView == nil) {
		_playerUIView = [[UIView alloc] initWithFrame:self.bounds];
        
        [_playerUIView addSubview:self.topView];
        [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0);
            make.height.mas_equalTo(40);
        }];
        
        [_playerUIView addSubview:self.bottomView];
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
        }];
        
        [_playerUIView addSubview:self.playButton];
        [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_offset(-20);
            make.bottom.equalTo(_bottomView.mas_top).mas_offset(-10);
        }];
        
        [_playerUIView addSubview:self.episodeTableView];
        [self.episodeTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo(EPISODE_TABLE_VIEW_WIDTH);
            make.right.mas_offset(EPISODE_TABLE_VIEW_WIDTH);
        }];

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

- (NSDateFormatter *)dateFormatter {
    if(_dateFormatter == nil) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"mm:ss";
    }
    return _dateFormatter;
}

- (NSTimer *)timer {
	if(_timer == nil) {
        @weakify(self)
		_timer = [NSTimer scheduledTimerWithTimeInterval:1 block:^(NSTimer * _Nonnull timer) {
            @strongify(self)
            if (!self) return;
            
            if (!self->_isDragProgress) {
                self.playerProgressSlider.currentProgress = self.player.currentPlaybackTime / self.player.duration;
            }
            self.playerProgressSlider.bufferProgress = self.player.bufferingProgress / 10000.0;
        } repeats:YES];
	}
	return _timer;
}

#pragma mark 播放器UI
- (UIButton *)backButton {
    if(_backButton == nil) {
        _backButton = [[UIButton alloc] init];
        [_backButton setImage:[UIImage imageNamed:@"hd_idct_back"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(touchFullScreenButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UIButton *)playButton {
    if(_playButton == nil) {
        _playButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        [_playButton setImage:[UIImage imageNamed:@"player_play"] forState:UIControlStateNormal];
        [_playButton setImage:[UIImage imageNamed:@"player_pause"] forState:UIControlStateSelected];
        _playButton.hidden = YES;
        [_playButton addTarget:self action:@selector(touchPlayButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playButton;
}

- (UIButton *)danmakuConfigButton {
    if(_danmakuConfigButton == nil) {
        _danmakuConfigButton = [[UIButton alloc] init];
        [_danmakuConfigButton setTitle:@"弹" forState:UIControlStateNormal];
        [_danmakuConfigButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [_danmakuConfigButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _danmakuConfigButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_danmakuConfigButton addTarget:self action:@selector(touchDanmakuConfigButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _danmakuConfigButton;
}

- (UIButton *)danmakuHideButton {
    if(_danmakuHideButton == nil) {
        _danmakuHideButton = [[UIButton alloc] init];
        [_danmakuHideButton setImage:[UIImage imageNamed:@"icmpv_toggle_danmaku_showed_light"] forState:UIControlStateNormal];
        [_danmakuHideButton setImage:[[UIImage imageNamed:@"icmpv_toggle_danmaku_showed_light"] imageByTintColor:[UIColor lightGrayColor]] forState:UIControlStateSelected];
        [_danmakuHideButton addTarget:self action:@selector(touchDanmakuHideButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _danmakuHideButton;
}

- (UIButton *)playSourseButton {
    if(_playSourseButton == nil) {
        _playSourseButton = [[UIButton alloc] init];
        _playSourseButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_playSourseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_playSourseButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        [_playSourseButton addTarget:self action:@selector(touchPlaySourseButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playSourseButton;
}

- (UIButton *)episodeButton {
    if(_episodeButton == nil) {
        _episodeButton = [[UIButton alloc] init];
        [_episodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_episodeButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [_episodeButton setTitle:@"选集" forState:UIControlStateNormal];
        _episodeButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_episodeButton addTarget:self action:@selector(touchEpisodeButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _episodeButton;
}

- (UIButton *)fullScreenButton {
    if(_fullScreenButton == nil) {
        _fullScreenButton = [[UIButton alloc] init];
        [_fullScreenButton setImage:[UIImage imageNamed:@"chase_roomplayer_fullscreen_icon"] forState:UIControlStateNormal];
        [_fullScreenButton addTarget:self action:@selector(touchFullScreenButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fullScreenButton;
}

- (UILabel *)titleLabel {
    if(_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

- (UILabel *)currentTimeLabel {
    if(_currentTimeLabel == nil) {
        _currentTimeLabel = [[UILabel alloc] init];
        _currentTimeLabel.font = [UIFont systemFontOfSize:13];
        _currentTimeLabel.textColor = [UIColor whiteColor];
        _currentTimeLabel.text = @"00:00";
    }
    return _currentTimeLabel;
}

- (UILabel *)videolengthLabel {
    if(_videolengthLabel == nil) {
        _videolengthLabel = [[UILabel alloc] init];
        _videolengthLabel.font = [UIFont systemFontOfSize:13];
        _videolengthLabel.textColor = [UIColor whiteColor];
        _videolengthLabel.text = @"00:00";
    }
    return _videolengthLabel;
}

- (PlayerSlideView *)playerProgressSlider {
    if(_playerProgressSlider == nil) {
        _playerProgressSlider = [[PlayerSlideView alloc] initWithFrame:CGRectZero];
        _playerProgressSlider.progressSliderColor = MAIN_COLOR;
        _playerProgressSlider.backGroundColor = RGBACOLOR(0, 0, 0, 0.6);
        _playerProgressSlider.delegate = self;
        //拖动进度条 不隐藏视图
        @weakify(self)
        [_playerProgressSlider setPlayerSliderDraggedEndCallBackBlock:^(CGFloat value) {
            @strongify(self)
            if (!self) return;
            self->_timer.fireDate = [NSDate dateWithTimeIntervalSinceNow:3];
        }];
    }
    return _playerProgressSlider;
}

- (UIView *)topView {
    if (_topView == nil) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = RGBACOLOR(0, 0, 0, 0.7);
        _topView.hidden = YES;
        
        [_topView addSubview:self.backButton];
        [_topView addSubview:self.titleLabel];
        [_topView addSubview:self.danmakuConfigButton];
        
        [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.mas_offset(10);
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_offset(0);
            make.left.equalTo(self.backButton.mas_right).mas_offset(10);
            make.width.equalTo(_topView.mas_width).multipliedBy(0.5);
        }];
        
        [self.danmakuConfigButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_offset(-10);
            make.centerY.mas_equalTo(0);
        }];
    }
    return _topView;
}

- (UIView *)bottomView {
    if (_bottomView == nil) {
        _bottomView = [[UIView alloc] init];
        [_bottomView addSubview:self.danmakuHideButton];
        [_bottomView addSubview:self.playSourseButton];
        [_bottomView addSubview:self.episodeButton];
        [_bottomView addSubview:self.fullScreenButton];
        [_bottomView addSubview:self.currentTimeLabel];
        [_bottomView addSubview:self.playerProgressSlider];
        [_bottomView addSubview:self.videolengthLabel];
        _bottomView.backgroundColor = RGBACOLOR(0, 0, 0, 0.5);
        
        [self.currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_offset(-15);
            make.left.mas_offset(10);
        }];
        
        [self.playerProgressSlider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.currentTimeLabel);
            make.left.equalTo(self.currentTimeLabel.mas_right).mas_offset(10);
            make.height.mas_equalTo(8);
        }];
        
        [self.videolengthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.playerProgressSlider.mas_right).mas_offset(10);
            make.right.mas_offset(-10);
            make.centerY.equalTo(self.currentTimeLabel);
        }];
        
        [self.danmakuHideButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_offset(10);
            make.bottom.equalTo(self.currentTimeLabel.mas_top).mas_offset(-10);
        }];
        
        [self.playSourseButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.danmakuHideButton);
        }];
        
        [self.episodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.playSourseButton.mas_right).mas_offset(10);
            make.centerY.equalTo(self.fullScreenButton);
        }];
        
        [self.fullScreenButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.episodeButton.mas_right).mas_offset(10);
            make.right.mas_offset(-10);
            make.top.mas_offset(10);
        }];
    }
    return _bottomView;
}

- (UITableView *)episodeTableView {
    if(_episodeTableView == nil) {
        _episodeTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _episodeTableView.delegate = self;
        _episodeTableView.dataSource = self;
        _episodeTableView.rowHeight = UITableViewAutomaticDimension;
        _episodeTableView.estimatedRowHeight = 44;
        _episodeTableView.backgroundColor = [UIColor clearColor];
        _episodeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        _episodeTableView.backgroundView = effectView;
    }
    return _episodeTableView;
}


@end
