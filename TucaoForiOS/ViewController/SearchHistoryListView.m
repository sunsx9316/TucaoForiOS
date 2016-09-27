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
    [[ToolsManager shareToolsManager] addSearchKey:keyWord];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [ToolsManager shareToolsManager].historySearchKeys.count + ([ToolsManager shareToolsManager].historySearchKeys.count != 0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [ToolsManager shareToolsManager].historySearchKeys.count) {
        SearchHistoryClearAllTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchHistoryClearAllTableViewCell" forIndexPath:indexPath];
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    
    cell.textLabel.text = [ToolsManager shareToolsManager].historySearchKeys[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == [ToolsManager shareToolsManager].historySearchKeys.count) {
        [[ToolsManager shareToolsManager] clearAllSearchKey];
        [self.tableView reloadData];
    }
    else if (self.touchIndexCallBack && indexPath.row < [ToolsManager shareToolsManager].historySearchKeys.count) {
        self.touchIndexCallBack([ToolsManager shareToolsManager].historySearchKeys[indexPath.row]);
    }
}

#pragma mark - 懒加载
- (UITableView *)tableView {
    if(_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        [_tableView registerClass:[SearchHistoryClearAllTableViewCell class] forCellReuseIdentifier:@"SearchHistoryClearAllTableViewCell"];
        [self addSubview:_tableView];
    }
    return _tableView;
}

@end