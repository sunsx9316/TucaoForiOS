//
//  SearchListViewController.m
//  TucaoForiOS
//
//  Created by JimHuang on 16/9/13.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "SearchListViewController.h"
#import "SearchViewModel.h"
#import "JHSearchBar.h"
#import "MBProgressHUD+Tools.h"

@interface SearchListViewController ()<JHSearchBarDelegate>
@property (strong, nonatomic) SearchViewModel *searchVM;
@property (strong, nonatomic) JHSearchBar *searchBar;
@end

@implementation SearchListViewController

- (instancetype)initWithKeyword:(NSString *)keyword {
    if (self = [super init]) {
        _searchVM = [[SearchViewModel alloc] init];
        _searchVM.keyword = keyword;
        self.viewModel = _searchVM;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = self.searchBar;
}

#pragma mark - JHSearchBarDelegate
- (void)searchBar:(JHSearchBar *)searchBar animateStatus:(JHSearchBarAnimateStatus)animateStatus animateType:(JHSearchBarAnimateType)animateType {
    if (animateStatus == JHSearchBarAnimateStatusDismiss) {
        if (animateType == JHSearchBarAnimateTypeWillEnd) {
            [[UserDefaultManager shareUserDefaultManager] addSearchKey:self.searchBar.searchTextField.text];
            self.searchBar.searchTextField.text = nil;
        }
    }
}

- (void)searchBarDidEndEditing {
    NSString *key = self.searchBar.searchTextField.text;
    if (key.length) {
        _searchVM.keyword = key;
        _searchBar.searchTextField.text = key;
        [self.tableView.mj_header beginRefreshing];
        [_searchVM refresh:YES completion:^(TucaoErrorModel *error) {
            [self.tableView reloadData];
        }];
    }
}

#pragma mark - 懒加载
- (JHSearchBar *)searchBar {
    if(_searchBar == nil) {
        _searchBar = [[JHSearchBar alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 30)];
        _searchBar.delegate = self;
        _searchBar.searchTextField.text = _searchVM.keyword;
    }
    return _searchBar;
}
@end
