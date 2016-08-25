//
//  VideoInfoUserTableViewCell.m
//  TucaoForiOS
//
//  Created by JimHuang on 16/8/25.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "VideoInfoUserTableViewCell.h"
@interface VideoInfoUserTableViewCell ()

@end

@implementation VideoInfoUserTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(20);
            make.top.mas_offset(10);
        }];
        
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.userNameLabel);
            make.top.equalTo(self.userNameLabel.mas_bottom).mas_offset(5);
            make.bottom.mas_offset(-10);
        }];
    }
    return self;
}

#pragma mark - 懒加载
- (UILabel *)userNameLabel {
    if(_userNameLabel == nil) {
        _userNameLabel = [[UILabel alloc] init];
        _userNameLabel.textColor = [UIColor blackColor];
        _userNameLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_userNameLabel];
    }
    return _userNameLabel;
}

- (UILabel *)timeLabel {
    if(_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor lightGrayColor];
        _timeLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_timeLabel];
    }
    return _timeLabel;
}

@end
