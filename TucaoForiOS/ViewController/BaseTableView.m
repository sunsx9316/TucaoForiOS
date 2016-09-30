//
//  BaseTableView.m
//  TucaoForiOS
//
//  Created by Jim_Huang on 16/9/30.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "BaseTableView.h"

@interface BaseTableView ()
@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UIView *emptyView;
@end

@implementation BaseTableView

- (void)reloadData {
    [super reloadData];
    [self reloadFootView];
}

- (void)deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation {
    [super deleteRowsAtIndexPaths:indexPaths withRowAnimation:animation];
    [self reloadFootView];
}


- (void)reloadFootView {
    if ([self numberOfRowsInSection:0]) {
        self.tableFooterView = self.emptyView;
    }
    else {
        self.tableFooterView = self.label;
    }
}

- (UILabel *)label {
	if(_label == nil) {
		_label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, 30)];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor darkGrayColor];
        _label.text = @"暂无数据";
        _label.font = [UIFont systemFontOfSize:15];
	}
	return _label;
}

- (UIView *)emptyView {
	if(_emptyView == nil) {
		_emptyView = [[UIView alloc] init];
	}
	return _emptyView;
}

@end
