//
//  SectionTableViewCell.m
//  TucaoForiOS
//
//  Created by JimHuang on 16/9/1.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "SectionTableViewCell.h"
@interface SectionTableViewCell ()
@property (strong, nonatomic) YYAnimatedImageView *iconImgView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *playCountLabel;
@end

@implementation SectionTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_offset(10);
            make.bottom.mas_lessThanOrEqualTo(-10);
            make.size.mas_equalTo(CGSizeMake(120, 60));
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.iconImgView);
            make.left.equalTo(self.iconImgView.mas_right).mas_offset(10);
            make.right.mas_lessThanOrEqualTo(-10);
        }];
        
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconImgView.mas_right).mas_offset(10);
            make.top.equalTo(self.titleLabel.mas_bottom).mas_offset(10);
            make.bottom.mas_offset(-10);
            make.right.equalTo(self.playCountLabel.mas_left).mas_offset(-10);
            make.width.priorityLow();
        }];
        
        [self.playCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_offset(-10);
            make.top.equalTo(self.nameLabel);
            make.bottom.mas_offset(-10);
        }];
    }
    return self;
}

- (void)setWithModel:(VideoModel *)model {
    [self.iconImgView yy_setImageWithURL:model.thumb options:YYWEBIMAGE_DEFAULT_OPTION];
    self.titleLabel.text = model.title;
    self.nameLabel.text = [NSString stringWithFormat:@"UP主：%@", model.user];
    self.playCountLabel.text = [NSString stringWithFormat:@"播放：%@", model.play];
}

#pragma mark - 懒加载
- (YYAnimatedImageView *)iconImgView {
	if(_iconImgView == nil) {
		_iconImgView = [[YYAnimatedImageView alloc] init];
        _iconImgView.clipsToBounds = YES;
        _iconImgView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_iconImgView];
	}
	return _iconImgView;
}

- (UILabel *)titleLabel {
	if(_titleLabel == nil) {
		_titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.numberOfLines = 0;
        [self.contentView addSubview:_titleLabel];
	}
	return _titleLabel;
}

- (UILabel *)nameLabel {
	if(_nameLabel == nil) {
		_nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor lightGrayColor];
        _nameLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_nameLabel];
	}
	return _nameLabel;
}

- (UILabel *)playCountLabel {
	if(_playCountLabel == nil) {
		_playCountLabel = [[UILabel alloc] init];
        _playCountLabel.textColor = [UIColor lightGrayColor];
        _playCountLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_playCountLabel];
	}
	return _playCountLabel;
}

@end
