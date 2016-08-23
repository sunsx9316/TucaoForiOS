//
//  HomePageSectionCollectionViewCell.m
//  TucaoForiOS
//
//  Created by JimHuang on 16/8/23.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "HomePageSectionCollectionViewCell.h"
@interface HomePageSectionCollectionViewCell ()
@property (strong, nonatomic) UIImageView *coverImgView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UIImageView *playCountIconImgView;
@property (strong, nonatomic) UILabel *playCountLabel;
@property (strong, nonatomic) UIImageView *danmakuCountIconImgView;
@property (strong, nonatomic) UILabel *danmakuCountLabel;
@end

@implementation HomePageSectionCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.coverImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0);
            make.height.mas_equalTo(self.mas_height).multipliedBy(0.6);
        }];
        
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.top.equalTo(self.coverImgView.mas_bottom);
        }];
        
        [self.playCountIconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.coverImgView).mas_offset(5);
            make.bottom.equalTo(self.coverImgView).mas_offset(-5);
        }];
        
        [self.playCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.playCountIconImgView);
            make.left.equalTo(self.playCountIconImgView.mas_right).mas_offset(5);
        }];
        
        [self.danmakuCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.playCountIconImgView);
            make.right.mas_offset(-5);
        }];
        
        [self.danmakuCountIconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.playCountIconImgView);
            make.right.equalTo(self.danmakuCountLabel.mas_left).mas_offset(-5);
        }];
    }
    return self;
}


- (void)setModel:(VideoModel *)model {
    _model = model;
    [self.coverImgView yy_setImageWithURL:_model.thumb options:YYWEBIMAGE_DEFAULT_OPTION];
    self.nameLabel.text = _model.title;
    self.playCountLabel.text = _model.play;
    self.danmakuCountLabel.text = _model.mukio;
}

#pragma mark - 懒加载
- (UIImageView *)coverImgView {
	if(_coverImgView == nil) {
		_coverImgView = [[UIImageView alloc] init];
        _coverImgView.clipsToBounds = YES;
        _coverImgView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_coverImgView];
	}
	return _coverImgView;
}

- (UILabel *)nameLabel {
	if(_nameLabel == nil) {
		_nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:15];
        _nameLabel.numberOfLines = 2;
        _nameLabel.lineBreakMode = NSLineBreakByClipping;
        _nameLabel.textColor = [UIColor whiteColor];
        [self addSubview:_nameLabel];
	}
	return _nameLabel;
}

- (UIImageView *)playCountIconImgView {
	if(_playCountIconImgView == nil) {
		_playCountIconImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_playnumb_icon"]];
        [self addSubview:_playCountIconImgView];
	}
	return _playCountIconImgView;
}

- (UILabel *)playCountLabel {
	if(_playCountLabel == nil) {
		_playCountLabel = [[UILabel alloc] init];
        _playCountLabel.font = [UIFont systemFontOfSize:13];
        _playCountLabel.textColor = [UIColor whiteColor];
        [self addSubview:_playCountLabel];
	}
	return _playCountLabel;
}

- (UIImageView *)danmakuCountIconImgView {
	if(_danmakuCountIconImgView == nil) {
		_danmakuCountIconImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_danmaku_icon"]];
        [self addSubview:_danmakuCountIconImgView];
	}
	return _danmakuCountIconImgView;
}

- (UILabel *)danmakuCountLabel {
	if(_danmakuCountLabel == nil) {
		_danmakuCountLabel = [[UILabel alloc] init];
        _danmakuCountLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:_danmakuCountLabel];
	}
	return _danmakuCountLabel;
}

@end
