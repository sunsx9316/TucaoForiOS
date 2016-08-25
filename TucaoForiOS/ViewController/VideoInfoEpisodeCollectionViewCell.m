//
//  VideoInfoEpisodeCollectionViewCell.m
//  TucaoForiOS
//
//  Created by JimHuang on 16/8/25.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "VideoInfoEpisodeCollectionViewCell.h"
@interface VideoInfoEpisodeCollectionViewCell ()
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIImageView *bgImgView;
@end

@implementation VideoInfoEpisodeCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_offset(UIEdgeInsetsMake(5, 5, 5, 5));
        }];
    }
    return self;
}

- (void)setModel:(VideoURLModel *)model {
    _model = model;
    self.titleLabel.text = model.title;
}

#pragma mark - 懒加载
- (UIImageView *)bgImgView {
	if(_bgImgView == nil) {
		_bgImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"episode_bg"]];
        [self.contentView addSubview:_bgImgView];
	}
	return _bgImgView;
}

- (UILabel *)titleLabel {
    if(_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}
@end
