//
//  MineViewController.m
//  TucaoForiOS
//
//  Created by JimHuang on 16/8/23.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "MineViewController.h"
#import "MineCenterTableViewCell.h"

@interface MineViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *sourceArr;
@property (strong, nonatomic) UIView *searchBar;
@end

@implementation MineViewController
{
    CGFloat _cellHeight;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    SET_NAV_BAR_COLOR(MAIN_COLOR, NO)
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = self.searchBar;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MineCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineCenterTableViewCell" forIndexPath:indexPath];
    _cellHeight = [cell cellHeightWithArr:self.sourceArr];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _cellHeight;
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    UIButton *button = [self.searchBar viewWithTag:101];
    [button mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(0);
    }];
    [self.searchBar setNeedsUpdateConstraints];
    [self.searchBar updateConstraintsIfNeeded];
    [UIView animateWithDuration:0.3 animations:^{
        [self.searchBar layoutIfNeeded];
    }];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    UIButton *button = [self.searchBar viewWithTag:101];
    [button mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(60);
    }];
    [self.searchBar setNeedsUpdateConstraints];
    [self.searchBar updateConstraintsIfNeeded];
    [UIView animateWithDuration:0.3 animations:^{
        [self.searchBar layoutIfNeeded];
    }];
}

#pragma mark - 私有方法
- (void)touchCanCelButton:(UIButton *)sender {
    [[self.searchBar viewWithTag:100] resignFirstResponder];
}

#pragma mark - 懒加载
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 80;
        _tableView.tableFooterView = [[UIView alloc] init];
        @weakify(self)
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            @strongify(self)
            if (!self) return;
            
            [[self.searchBar viewWithTag:100] resignFirstResponder];
        }];
        tapGesture.cancelsTouchesInView = NO;
        [_tableView addGestureRecognizer:tapGesture];
        
        [_tableView registerClass:[MineCenterTableViewCell class] forCellReuseIdentifier:@"MineCenterTableViewCell"];
        [self.view addSubview:_tableView];
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
        [cancelButton addTarget:self action:@selector(touchCanCelButton:) forControlEvents:UIControlEventTouchUpInside];
        
        UITextField *searchTextField = [[UITextField alloc] init];
        searchTextField.tag = 100;
        searchTextField.placeholder = @"搜索关键词、视频id";
        searchTextField.font = [UIFont systemFontOfSize:13];
        searchTextField.tintColor = MAIN_COLOR;
        searchTextField.delegate = self;
        
        UIImageView *searchIconImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search_prompt_icon"]];
        searchIconImgView.contentMode = UIViewContentModeScaleAspectFit;
        
        [_searchBar addSubview:holdView];
        [_searchBar addSubview:cancelButton];
        [holdView addSubview:searchTextField];
        [holdView addSubview:searchIconImgView];
        
        
        [holdView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.mas_equalTo(0);
            make.right.equalTo(cancelButton.mas_left);
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
            make.right.centerY.mas_equalTo(0);
        }];
    }
    return _searchBar;
}

@end
