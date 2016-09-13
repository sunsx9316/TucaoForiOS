//
//  SearchHistoryClearAllTableViewCell.m
//  TucaoForiOS
//
//  Created by JimHuang on 16/9/13.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "SearchHistoryClearAllTableViewCell.h"

@interface SearchHistoryClearAllTableViewCell ()
@property (strong, nonatomic) UILabel *label;
@end

@implementation SearchHistoryClearAllTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
        }];
    }
    return self;
}

- (UILabel *)label {
	if(_label == nil) {
		_label = [[UILabel alloc] init];
        _label.textColor = [UIColor darkGrayColor];
        _label.font = [UIFont systemFontOfSize:15];
        _label.text = @"清除历史纪录";
        [self.contentView addSubview:_label];
	}
	return _label;
}

@end
