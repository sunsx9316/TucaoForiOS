//
//  DownloadHeaderView.m
//  TucaoForiOS
//
//  Created by Jim_Huang on 2016/10/9.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "DownloadHeaderView.h"

@interface DownloadHeaderView ()
@property (strong, nonatomic) UIImageView *iconImgView;
@property (strong, nonatomic) UILabel *titleLabel;
@end

@implementation DownloadHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.centerY.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(70, 50));
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconImgView.mas_right).mas_offset(10);
            make.centerY.equalTo(self.iconImgView);
            make.right.mas_lessThanOrEqualTo(-10);
        }];
    }
    return self;
}

- (void)setWithModel:(VideoModel *)model {
    [self.iconImgView yy_setImageWithURL:model.thumb options:YYWEBIMAGE_DEFAULT_OPTION];
    self.titleLabel.text = model.title;
}

#pragma mark - 懒加载
- (UIImageView *)iconImgView {
    if(_iconImgView == nil) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.contentMode = UIViewContentModeScaleAspectFill;
        _iconImgView.clipsToBounds = YES;
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
