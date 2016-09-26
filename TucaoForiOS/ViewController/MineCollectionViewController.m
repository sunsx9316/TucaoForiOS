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

@interface MineCollectionViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;

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
    return [ToolsManager shareToolsManager].mineCollectionVideos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SectionTableViewCell" forIndexPath:indexPath];
    VideoModel *model = [ToolsManager shareToolsManager].mineCollectionVideos[indexPath.row];
    [cell setWithModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:@"SectionTableViewCell" cacheByIndexPath:indexPath configuration:^(SectionTableViewCell *cell) {
        [cell setWithModel:[ToolsManager shareToolsManager].mineCollectionVideos[indexPath.row]];
    }];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    VideoInfoViewController *vc = [[VideoInfoViewController alloc] init];
    vc.model = [ToolsManager shareToolsManager].mineCollectionVideos[indexPath.row];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        VideoModel *model = [ToolsManager shareToolsManager].mineCollectionVideos[indexPath.row];
        [[ToolsManager shareToolsManager] removeMineCollectionVideo:model];
        [tableView deleteRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationAutomatic];
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
        _tableView.backgroundColor = BACK_GROUND_COLOR;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[SectionTableViewCell class] forCellReuseIdentifier:@"SectionTableViewCell"];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
@end
