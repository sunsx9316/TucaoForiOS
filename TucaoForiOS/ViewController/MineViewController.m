//
//  MineViewController.m
//  TucaoForiOS
//
//  Created by JimHuang on 16/8/23.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "MineViewController.h"
#import "MineCenterTableViewCell.h"
#import "SearchHistoryListView.h"
#import "JHSearchBar.h"

#import "SearchListViewController.h"
#import "MineCollectionViewController.h"
#import "DownloadViewController.h"

#import <YYKeyboardManager.h>

@interface MineViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, JHSearchBarDelegate, YYKeyboardObserver>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *sourceArr;
@property (strong, nonatomic) JHSearchBar *searchBar;
@property (strong, nonatomic) SearchHistoryListView *historyListView;
@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = self.searchBar;
    self.navigationItem.leftBarButtonItem = nil;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.historyListView];
    [[YYKeyboardManager defaultManager] addObserver:self];
}

- (void)dealloc {
    [[YYKeyboardManager defaultManager] removeObserver:self];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MineCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineCenterTableViewCell" forIndexPath:indexPath];
    NSDictionary *dic = self.sourceArr[indexPath.row];
    cell.iconImgView.image = [UIImage imageNamed:dic[@"img"]];
    cell.titleLabel.text = dic[@"title"];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        DownloadViewController *vc = [[DownloadViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row == 2) {
        MineCollectionViewController *vc = [[MineCollectionViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - JHSearchBarDelegate
- (void)searchBar:(JHSearchBar *)searchBar animateStatus:(JHSearchBarAnimateStatus)animateStatus animateType:(JHSearchBarAnimateType)animateType {
    if (animateStatus == JHSearchBarAnimateStatusShow) {
        if (animateType == JHSearchBarAnimateTypeWillBegin) {
            [self.view addSubview:self.historyListView];
        }
        else if (animateType == JHSearchBarAnimateTypePlaying) {
            self.historyListView.frame = self.view.bounds;
        }
    }
    else if (animateStatus == JHSearchBarAnimateStatusDismiss) {
        CGRect frame = self.historyListView.frame;
        frame.origin.x = self.view.width;
        if (animateType == JHSearchBarAnimateTypePlaying) {
            self.historyListView.frame = frame;
        }
        else if (animateType == JHSearchBarAnimateTypeWillEnd) {
            [self.historyListView removeFromSuperview];
            searchBar.searchTextField.text = nil;
        }
    }
}

- (void)searchBarDidEndEditing {
    NSString *key = self.searchBar.searchTextField.text;
    if (key.length) {
        [self.historyListView addSearchKey:key];
        SearchListViewController *vc = [[SearchListViewController alloc] initWithKeyword:key];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - YYKeyboardObserver
- (void)keyboardChangedWithTransition:(YYKeyboardTransition)transition {
    YYKeyboardManager *manager = [YYKeyboardManager defaultManager];
    CGRect toFrame = [manager convertRect:transition.toFrame toView:self.view];
    self.historyListView.height = self.view.height - toFrame.size.height;
}

#pragma mark - 懒加载
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 60;
        _tableView.tableFooterView = [[UIView alloc] init];
        [_tableView registerClass:[MineCenterTableViewCell class] forCellReuseIdentifier:@"MineCenterTableViewCell"];
    }
    return _tableView;
}

- (NSArray *)sourceArr {
    if (_sourceArr == nil) {
        _sourceArr = @[@{@"img":@"mine_download", @"title": @"离线缓存"}, @{@"img":@"mine_history", @"title": @"历史纪录"},@{@"img":@"mine_favourite", @"title": @"我的收藏"}];
    }
    return _sourceArr;
}

- (SearchHistoryListView *)historyListView {
	if(_historyListView == nil) {
		_historyListView = [[SearchHistoryListView alloc] initWithFrame:CGRectMake(self.view.width, 0, self.view.width, self.view.height)];
        @weakify(self)
        [_historyListView setTouchIndexCallBack:^(NSString *keyword) {
            @strongify(self)
            if (!self) return;
            [self.searchBar.searchTextField resignFirstResponder];
            
            if (keyword.length) {
                SearchListViewController *vc = [[SearchListViewController alloc] initWithKeyword:keyword];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }];
	}
	return _historyListView;
}

- (JHSearchBar *)searchBar {
	if(_searchBar == nil) {
		_searchBar = [[JHSearchBar alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 30)];
        _searchBar.delegate = self;
	}
	return _searchBar;
}

@end
