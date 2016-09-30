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
#import "SearchListViewController.h"
#import "MineCollectionViewController.h"
#import "DownloadViewController.h"

@interface MineViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *sourceArr;
@property (strong, nonatomic) UIView *searchBar;
@property (strong, nonatomic) SearchHistoryListView *historyListView;
@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = self.searchBar;
    self.navigationItem.leftBarButtonItem = nil;
    [self.view addSubview:self.tableView];
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

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    textField.text = nil;
    CGRect frame = self.historyListView.frame;
    frame.origin.x = self.view.width;
    
    UIButton *button = [self.searchBar viewWithTag:101];
    [button mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(0);
        make.right.mas_offset(10);
    }];
    [self.searchBar setNeedsUpdateConstraints];
    [self.searchBar updateConstraintsIfNeeded];
    [UIView animateWithDuration:0.3 animations:^{
        [self.searchBar layoutIfNeeded];
        self.historyListView.frame = frame;
    } completion:nil];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.view addSubview:self.historyListView];
    
    UIButton *button = [self.searchBar viewWithTag:101];
    [button mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(60);
        make.right.mas_equalTo(0);
    }];
    [self.searchBar setNeedsUpdateConstraints];
    [self.searchBar updateConstraintsIfNeeded];
    [UIView animateWithDuration:0.3 animations:^{
        [self.searchBar layoutIfNeeded];
        self.historyListView.frame = self.view.bounds;
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.historyListView addSearchKey:textField.text];
    NSString *key = textField.text;
    [self.historyListView removeFromSuperview];
    if (key.length) {
        SearchListViewController *vc = [[SearchListViewController alloc] initWithKeyword:key];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    [self touchCancelButton:nil];
    return YES;
}

#pragma mark - 私有方法
- (void)touchCancelButton:(UIButton *)sender {
    [[self.searchBar viewWithTag:100] resignFirstResponder];
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

- (UIView *)searchBar {
    if (_searchBar == nil) {
        _searchBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 30)];
        
        UIView *holdView = [[UIView alloc] init];
        holdView.backgroundColor = [UIColor whiteColor];
        holdView.layer.masksToBounds = YES;
        holdView.layer.cornerRadius = 5;
        
        UIButton *cancelButton = [[UIButton alloc] init];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        cancelButton.tag = 101;
        [cancelButton addTarget:self action:@selector(touchCancelButton:) forControlEvents:UIControlEventTouchUpInside];
        
        UITextField *searchTextField = [[UITextField alloc] init];
        searchTextField.tag = 100;
        searchTextField.placeholder = @"搜索关键词、视频id";
        searchTextField.font = [UIFont systemFontOfSize:13];
        searchTextField.tintColor = MAIN_COLOR;
        searchTextField.delegate = self;
        searchTextField.returnKeyType = UIReturnKeySearch;
        
        UIImageView *searchIconImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search_prompt_icon"]];
        searchIconImgView.contentMode = UIViewContentModeScaleAspectFit;
        
        [_searchBar addSubview:holdView];
        [_searchBar addSubview:cancelButton];
        [holdView addSubview:searchTextField];
        [holdView addSubview:searchIconImgView];
        
        
        [holdView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.mas_equalTo(0);
            make.right.equalTo(cancelButton.mas_left).mas_offset(-10);
        }];
        
        [searchIconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.mas_offset(10);
            make.width.priorityHigh();
        }];
        
        [searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(searchIconImgView.mas_right).mas_offset(10);
            make.top.mas_offset(5);
            make.bottom.mas_offset(-5);
            make.right.equalTo(cancelButton.mas_left);
        }];
        
        [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
            make.height.mas_equalTo(30);
            make.centerY.mas_equalTo(0);
            make.right.mas_offset(10);
        }];
    }
    return _searchBar;
}

- (SearchHistoryListView *)historyListView {
	if(_historyListView == nil) {
		_historyListView = [[SearchHistoryListView alloc] initWithFrame:CGRectMake(self.view.width, 0, self.view.width, self.view.height)];
        @weakify(self)
        [_historyListView setTouchIndexCallBack:^(NSString *keyword) {
            @strongify(self)
            if (!self) return;
            [self touchCancelButton:nil];
            if (keyword.length) {
                SearchListViewController *vc = [[SearchListViewController alloc] initWithKeyword:keyword];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }];
	}
	return _historyListView;
}

@end
