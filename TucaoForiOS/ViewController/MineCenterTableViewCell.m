//
//  MineCenterTableViewCell.m
//  TucaoForiOS
//
//  Created by Jim_Huang on 16/9/13.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "MineCenterTableViewCell.h"

@implementation MineCenterTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(10);
            make.centerY.mas_equalTo(0);
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconImgView.mas_right).mas_offset(10);
            make.centerY.mas_equalTo(0);
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
        _titleLabel.textColor = [UIColor darkGrayColor];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}
@end
