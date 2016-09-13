//
//  BaseVideoListViewController.m
//  TucaoForiOS
//
//  Created by JimHuang on 16/9/13.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "BaseVideoListViewController.h"
#import "VideoInfoViewController.h"
#import "SectionTableViewCell.h"
#import <UITableView+FDTemplateLayoutCell.h>

@interface BaseVideoListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@end

@implementation BaseVideoListViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    SET_NAV_BAR_COLOR(MAIN_COLOR, NO)
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    VideoInfoViewController *vc = [[VideoInfoViewController alloc] init];
    vc.model = self.viewModel.videos[indexPath.row];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.videos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SectionTableViewCell" forIndexPath:indexPath];
    [cell setWithModel:self.viewModel.videos[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:@"SectionTableViewCell" cacheByIndexPath:indexPath configuration:^(SectionTableViewCell *cell) {
        [cell setWithModel:self.viewModel.videos[indexPath.row]];
    }];
}

#pragma mark - 懒加载
- (UITableView *)tableView {
    if(_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = BACK_GROUND_COLOR;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[SectionTableViewCell class] forCellReuseIdentifier:@"SectionTableViewCell"];
        @weakify(self)
        _tableView.mj_header = [MJRefreshNormalHeader headerWithDefaultRefreshingBlock:^{
            @strongify(self)
            if (!self) return;
            
            [self.viewModel refresh:YES completion:^(TucaoErrorModel *error) {
                [self.tableView.mj_header endRefreshing];
                [self.tableView reloadData];
            }];
        }];
        
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithhDefaultRefreshingBlock:^{
            @strongify(self)
            if (!self) return;
            [self.viewModel refresh:NO completion:^(TucaoErrorModel *error) {
                [self.tableView.mj_footer endRefreshing];
                [self.tableView reloadData];
            }];
        }];
        
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

@end
