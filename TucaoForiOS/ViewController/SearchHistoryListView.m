//
//  SearchHistoryListView.m
//  TucaoForiOS
//
//  Created by JimHuang on 16/9/13.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "SearchHistoryListView.h"
#import "SearchHistoryFooterView.h"

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
    return [UserDefaultManager shareUserDefaultManager].historySearchKeys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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
    self.touchIndexCallBack([UserDefaultManager shareUserDefaultManager].historySearchKeys[indexPath.row]);
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSString *key = [UserDefaultManager shareUserDefaultManager].historySearchKeys[indexPath.row];
        [[UserDefaultManager shareUserDefaultManager] removeSearchKey:key];
        [tableView reloadData];
    }];
    return @[action];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if ([UserDefaultManager shareUserDefaultManager].historySearchKeys.count == 0) return nil;
    
    SearchHistoryFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"SearchHistoryFooterView"];
    @weakify(self)
    [view setTouchCallBack:^{
        @strongify(self)
        if (!self) return;
        [UserDefaultManager shareUserDefaultManager].historySearchKeys = nil;
        [self.tableView reloadData];
    }];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return [UserDefaultManager shareUserDefaultManager].historySearchKeys.count ? 50 : 0.1;
}


#pragma mark - 懒加载
- (UITableView *)tableView {
    if(_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 50;
        _tableView.tableFooterView = [[UIView alloc] init];
        [_tableView registerClass:[SearchHistoryFooterView class] forHeaderFooterViewReuseIdentifier:@"SearchHistoryFooterView"];
        [self addSubview:_tableView];
    }
    return _tableView;
}

@end
