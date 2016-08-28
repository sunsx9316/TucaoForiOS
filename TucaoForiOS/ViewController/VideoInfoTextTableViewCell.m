//
//  VideoInfoTextTableViewCell.m
//  TucaoForiOS
//
//  Created by JimHuang on 16/8/27.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "VideoInfoTextTableViewCell.h"

@implementation VideoInfoTextTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_offset(10);
            make.bottom.mas_offset(-10);
            make.right.mas_lessThanOrEqualTo(-10);
        }];
    }
    return self;
}

#pragma mark - 懒加载
- (UILabel *)titleLabel {
    if(_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.numberOfLines = 0;
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}
@end
