//
//  SectionCollectionViewCell.m
//  TucaoForiOS
//
//  Created by JimHuang on 16/9/12.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "SectionCollectionViewCell.h"

@interface SectionCollectionViewCell ()

@end

@implementation SectionCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_offset(10);
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
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_titleLabel];
	}
	return _titleLabel;
}

@end
