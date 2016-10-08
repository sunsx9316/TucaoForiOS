//
//  MineCollectionViewController.m
//  TucaoForiOS
//
//  Created by Jim_Huang on 16/9/26.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "MineCollectionViewController.h"
#import "VideoInfoViewController.h"
#import "SectionTableViewCell.h"

#import <UITableView+FDTemplateLayoutCell.h>
#import "BaseTableView.h"

@interface MineCollectionViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) BaseTableView *tableView;

@end

@implementation MineCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的收藏";
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [UserDefaultManager shareUserDefaultManager].mineCollectionVideos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SectionTableViewCell" forIndexPath:indexPath];
    VideoModel *model = [UserDefaultManager shareUserDefaultManager].mineCollectionVideos[indexPath.row];
    [cell setWithModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:@"SectionTableViewCell" cacheByIndexPath:indexPath configuration:^(SectionTableViewCell *cell) {
        [cell setWithModel:[UserDefaultManager shareUserDefaultManager].mineCollectionVideos[indexPath.row]];
    }];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    VideoInfoViewController *vc = [[VideoInfoViewController alloc] init];
    vc.model = [UserDefaultManager shareUserDefaultManager].mineCollectionVideos[indexPath.row];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        VideoModel *model = [UserDefaultManager shareUserDefaultManager].mineCollectionVideos[indexPath.row];
        [[UserDefaultManager shareUserDefaultManager] removeMineCollectionVideo:model];
        [tableView deleteRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationAutomatic];    }];
    return @[action];
}

#pragma mark - 懒加载
- (BaseTableView *)tableView {
    if(_tableView == nil) {
        _tableView = [[BaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = BACK_GROUND_COLOR;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[SectionTableViewCell class] forCellReuseIdentifier:@"SectionTableViewCell"];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
@end
