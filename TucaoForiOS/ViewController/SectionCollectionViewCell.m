//
//  SectionCollectionViewCell.m
//  TucaoForiOS
//
//  Created by JimHuang on 16/9/12.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "SectionCollectionViewCell.h"

@interface SectionCollectionViewCell ()
@property (strong, nonatomic) UIImageView *bgImgView;
@end

@implementation SectionCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_offset(10);
            make.size.mas_equalTo(CGSizeMake(60, 60));
        }];
        
        [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.bgImgView);
            make.size.mas_equalTo(CGSizeMake(25, 25));
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_offset(-10);
            make.centerX.mas_equalTo(0);
        }];
        
    }
    return self;
}

#pragma mark - 懒加载
- (UIImageView *)iconImgView {
	if(_iconImgView == nil) {
		_iconImgView = [[UIImageView alloc] init];
        _iconImgView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_iconImgView];
	}
	return _iconImgView;
}

- (UILabel *)titleLabel {
	if(_titleLabel == nil) {
		_titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_titleLabel];
	}
	return _titleLabel;
}

- (UIImageView *)bgImgView {
    if (_bgImgView == nil) {
        _bgImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_region_border"]];
        _bgImgView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_bgImgView];
    }
    return _bgImgView;
}

@end
