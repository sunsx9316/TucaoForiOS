//
//  SearchHistoryFooterView.m
//  TucaoForiOS
//
//  Created by Jim_Huang on 2016/10/8.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "SearchHistoryFooterView.h"

@interface SearchHistoryFooterView ()
@property (strong, nonatomic) UILabel *label;
@end

@implementation SearchHistoryFooterView
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
        }];
    }
    return self;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.touchCallBack) {
        self.touchCallBack();
    }
}

#pragma mark - 懒加载
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
