//
//  PlayerUIView.m
//  TucaoForiOS
//
//  Created by JimHuang on 16/9/2.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "PlayerUIView.h"
@interface PlayerUIView ()
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

@end

@implementation PlayerUIView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        UIView *topHoldView = [[UIView alloc] init];
        topHoldView.backgroundColor = RGBACOLOR(0, 0, 0, 0.7);
        [self addSubview:topHoldView];
        [topHoldView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0);
            make.height.mas_equalTo(40);
        }];
        
        [topHoldView addSubview:self.backButton];
        [topHoldView addSubview:self.titleLabel];
        [topHoldView addSubview:self.danmakuConfigButton];
        
        [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.mas_offset(10);
        }];
        
        self.titleLabel.text = @"aaaa";
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_offset(0);
            make.left.equalTo(self.backButton.mas_right).mas_offset(10);
            make.width.equalTo(self.mas_width).multipliedBy(0.5);
        }];
        
        [self.danmakuConfigButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_offset(-10);
            make.centerY.mas_equalTo(0);
        }];

        UIView *bottomView = [[UIView alloc] init];
        [bottomView addSubview:self.danmakuHideButton];
        [bottomView addSubview:self.playSourseButton];
        [bottomView addSubview:self.episodeButton];
        [bottomView addSubview:self.fullScreenButton];
        [bottomView addSubview:self.currentTimeLabel];
        [bottomView addSubview:self.playerProgressSlider];
        [bottomView addSubview:self.videolengthLabel];
        bottomView.backgroundColor = RGBACOLOR(0, 0, 0, 0.7);
        [self addSubview:bottomView];
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
        }];

        [self.currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_offset(-10);
            make.left.mas_offset(10);
        }];
        
        [self.playerProgressSlider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.currentTimeLabel);
            make.left.equalTo(self.currentTimeLabel.mas_right).mas_offset(10);
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
        
        [self addSubview:self.playSourseButton];
        [self.playSourseButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(bottomView.mas_top).mas_offset(-5);
            make.right.mas_offset(-10);
        }];
        
    }
    return self;
}


#pragma mark - 私有方法
- (void)touchDanmaluHideButton:(UIButton *)button {
    
}

#pragma mark - 懒加载
- (UIButton *)backButton {
	if(_backButton == nil) {
		_backButton = [[UIButton alloc] init];
        [_backButton setImage:[UIImage imageNamed:@"hd_idct_back"] forState:UIControlStateNormal];
	}
	return _backButton;
}

- (UIButton *)playButton {
	if(_playButton == nil) {
		_playButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        [_playButton setImage:[UIImage imageNamed:@"player_play"] forState:UIControlStateSelected];
        [_playButton setImage:[UIImage imageNamed:@"player_pause"] forState:UIControlStateNormal];
	}
	return _playButton;
}

- (UIButton *)danmakuConfigButton {
	if(_danmakuConfigButton == nil) {
		_danmakuConfigButton = [[UIButton alloc] init];
        [_danmakuConfigButton setTitle:@"弹" forState:UIControlStateNormal];
        [_danmakuConfigButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _danmakuConfigButton.titleLabel.font = [UIFont systemFontOfSize:13];
	}
	return _danmakuConfigButton;
}

- (UIButton *)danmakuHideButton {
	if(_danmakuHideButton == nil) {
		_danmakuHideButton = [[UIButton alloc] init];
        [_danmakuHideButton setImage:[UIImage imageNamed:@"icmpv_toggle_danmaku_showed_light"] forState:UIControlStateNormal];
        [_danmakuHideButton setImage:[[UIImage imageNamed:@"icmpv_toggle_danmaku_showed_light"] imageByTintColor:[UIColor lightGrayColor]] forState:UIControlStateSelected];
        [_danmakuHideButton addTarget:self action:@selector(touchDanmaluHideButton:) forControlEvents:UIControlEventTouchUpInside];
	}
	return _danmakuHideButton;
}

- (UIButton *)playSourseButton {
	if(_playSourseButton == nil) {
		_playSourseButton = [[UIButton alloc] init];
        _playSourseButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_playSourseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_playSourseButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
	}
	return _playSourseButton;
}

- (UIButton *)episodeButton {
	if(_episodeButton == nil) {
		_episodeButton = [[UIButton alloc] init];
        [_episodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_episodeButton setTitle:@"选集" forState:UIControlStateNormal];
        _episodeButton.titleLabel.font = [UIFont systemFontOfSize:13];
	}
	return _episodeButton;
}

- (UIButton *)fullScreenButton {
	if(_fullScreenButton == nil) {
		_fullScreenButton = [[UIButton alloc] init];
        [_fullScreenButton setImage:[UIImage imageNamed:@"chase_roomplayer_fullscreen_icon"] forState:UIControlStateNormal];
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
	}
	return _currentTimeLabel;
}

- (UILabel *)videolengthLabel {
	if(_videolengthLabel == nil) {
		_videolengthLabel = [[UILabel alloc] init];
        _videolengthLabel.font = [UIFont systemFontOfSize:13];
        _videolengthLabel.textColor = [UIColor whiteColor];
	}
	return _videolengthLabel;
}

- (UISlider *)playerProgressSlider {
	if(_playerProgressSlider == nil) {
		_playerProgressSlider = [[UISlider alloc] init];
        _playerProgressSlider.continuous = NO;
        _playerProgressSlider.minimumTrackTintColor = MAIN_COLOR;
	}
	return _playerProgressSlider;
}

@end
