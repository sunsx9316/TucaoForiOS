//
//  VideoInfoNumberTableViewCell.m
//  TucaoForiOS
//
//  Created by JimHuang on 16/8/25.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "VideoInfoNumberTableViewCell.h"
@interface VideoInfoNumberTableViewCell ()
@property (strong, nonatomic) UIImageView *playIconImgView;
@property (strong, nonatomic) UIImageView *danmakuIconImgView;
@end

@implementation VideoInfoNumberTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.playIconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(15);
            make.centerY.mas_equalTo(0);
        }];
        
        [self.playCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.equalTo(self.playIconImgView.mas_right).mas_offset(5);
        }];
        
        [self.danmakuIconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.equalTo(self.playCountLabel.mas_right).mas_offset(10);
        }];
        
        [self.danmakuCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.equalTo(self.danmakuIconImgView.mas_right).mas_offset(5);
        }];
    }
    return self;
}

#pragma mark - 懒加载
- (UIImageView *)playIconImgView {
	if(_playIconImgView == nil) {
		_playIconImgView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"list_playnumb_icon"] imageByTintColor:[UIColor lightGrayColor]]];
        [self.contentView addSubview:_playIconImgView];
	}
	return _playIconImgView;
}

- (UILabel *)playCountLabel {
	if(_playCountLabel == nil) {
		_playCountLabel = [[UILabel alloc] init];
        _playCountLabel.font = [UIFont systemFontOfSize:13];
        _playCountLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_playCountLabel];
	}
	return _playCountLabel;
}

- (UIImageView *)danmakuIconImgView {
	if(_danmakuIconImgView == nil) {
		_danmakuIconImgView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"list_danmaku_icon"] imageByTintColor:[UIColor lightGrayColor]]];
        [self.contentView addSubview:_danmakuIconImgView];
	}
	return _danmakuIconImgView;
}

- (UILabel *)danmakuCountLabel {
	if(_danmakuCountLabel == nil) {
		_danmakuCountLabel = [[UILabel alloc] init];
        _danmakuCountLabel.font = [UIFont systemFontOfSize:13];
        _danmakuCountLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_danmakuCountLabel];
	}
	return _danmakuCountLabel;
}

@end
