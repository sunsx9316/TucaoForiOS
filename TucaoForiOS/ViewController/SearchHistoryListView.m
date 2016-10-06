//
//  SearchHistoryListView.m
//  TucaoForiOS
//
//  Created by JimHuang on 16/9/13.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "SearchHistoryListView.h"
#import "SearchHistoryClearAllTableViewCell.h"

@interface SearchHistoryListView ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@end

@implementation SearchHistoryListView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    return self;
}

- (void)addSearchKey:(NSString *)keyWord {
    [[UserDefaultManager shareUserDefaultManager] addSearchKey:keyWord];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [UserDefaultManager shareUserDefaultManager].historySearchKeys.count + ([UserDefaultManager shareUserDefaultManager].historySearchKeys.count != 0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [UserDefaultManager shareUserDefaultManager].historySearchKeys.count) {
        SearchHistoryClearAllTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchHistoryClearAllTableViewCell" forIndexPath:indexPath];
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    
    cell.textLabel.text = [UserDefaultManager shareUserDefaultManager].historySearchKeys[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == [UserDefaultManager shareUserDefaultManager].historySearchKeys.count) {
        [[UserDefaultManager shareUserDefaultManager] clearAllSearchKey];
        [self.tableView reloadData];
    }
    else if (self.touchIndexCallBack && indexPath.row < [UserDefaultManager shareUserDefaultManager].historySearchKeys.count) {
        self.touchIndexCallBack([UserDefaultManager shareUserDefaultManager].historySearchKeys[indexPath.row]);
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString *key = [UserDefaultManager shareUserDefaultManager].historySearchKeys[indexPath.row];
        [[UserDefaultManager shareUserDefaultManager] removeSearchKey:key];
        [tableView reloadData];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}


#pragma mark - 懒加载
- (UITableView *)tableView {
    if(_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 50;
        _tableView.tableFooterView = [[UIView alloc] init];
        [_tableView registerClass:[SearchHistoryClearAllTableViewCell class] forCellReuseIdentifier:@"SearchHistoryClearAllTableViewCell"];
        [self addSubview:_tableView];
    }
    return _tableView;
}

@end
