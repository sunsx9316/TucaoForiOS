//
//  HomePageSectionHeaderFooterView.m
//  TucaoForiOS
//
//  Created by JimHuang on 16/8/24.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "HomePageSectionHeaderFooterView.h"
@interface HomePageSectionHeaderFooterView ()
@property (strong, nonatomic) UILabel *rightLabel;
@property (strong, nonatomic) UIImageView *rightArrowImgView;
@end

@implementation HomePageSectionHeaderFooterView
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = MAIN_COLOR;
        
        [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.mas_offset(10);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.iconImgView);
            make.left.equalTo(self.iconImgView.mas_right).mas_offset(10);
        }];
        
        [self.rightArrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_offset(-10);
            make.centerY.mas_equalTo(0);
        }];
        
        [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.rightArrowImgView);
            make.right.equalTo(self.rightArrowImgView.mas_left).mas_offset(-5);
        }];
    }
    return self;
}

#pragma mark - 懒加载
- (UIImageView *)iconImgView {
    if(_iconImgView == nil) {
        _iconImgView = [[UIImageView alloc] init];
        [self.contentView addSubview:_iconImgView];
    }
    return _iconImgView;
}

- (UILabel *)titleLabel {
    if(_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)rightLabel {
	if(_rightLabel == nil) {
		_rightLabel = [[UILabel alloc] init];
        _rightLabel.text = @"更多";
        _rightLabel.font = [UIFont systemFontOfSize:14];
        _rightLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_rightLabel];
	}
	return _rightLabel;
}

- (UIImageView *)rightArrowImgView {
	if(_rightArrowImgView == nil) {
		_rightArrowImgView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"common_rightArrowShadow"] imageByTintColor:[UIColor whiteColor]]];
        [self.contentView addSubview:_rightArrowImgView];
	}
	return _rightArrowImgView;
}

@end
