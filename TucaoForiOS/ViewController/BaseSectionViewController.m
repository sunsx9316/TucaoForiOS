//
//  BaseSectionViewController.m
//  TucaoForiOS
//
//  Created by JimHuang on 16/9/1.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "BaseSectionViewController.h"
#import "SectionTableViewCell.h"
#import <UITableView+FDTemplateLayoutCell.h>
#import "SectionNetManager.h"
#import "VideoInfoViewController.h"

@interface BaseSectionViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray <VideoModel *>*videos;
@end

@implementation BaseSectionViewController
{
    NSString *_section;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    SET_NAV_BAR_COLOR(MAIN_COLOR, NO)
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
}

- (instancetype)initWithSection:(NSString *)section {
    if (self = [super init]) {
        _section = section;
    }
    return self;
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
    vc.model = self.videos[indexPath.row];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.videos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SectionTableViewCell" forIndexPath:indexPath];
    [cell setWithModel:self.videos[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:@"SectionTableViewCell" cacheByIndexPath:indexPath configuration:^(SectionTableViewCell *cell) {
        [cell setWithModel:self.videos[indexPath.row]];
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
            
            [SectionNetManager sectionListWithId:self->_section totalCount:0 completionHandler:^(VideoCollectionModel *models, TucaoErrorModel *error) {
                [self.tableView.mj_header endRefreshing];
                [self.videos removeAllObjects];
                [self.videos addObjectsFromArray:models.videos];
                [self.tableView reloadData];
            }];
        }];
        
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithhDefaultRefreshingBlock:^{
            @strongify(self)
            if (!self) return;
            
            [SectionNetManager sectionListWithId:self->_section totalCount:self.videos.count completionHandler:^(VideoCollectionModel *models, TucaoErrorModel *error) {
                [self.tableView.mj_footer endRefreshing];
                [self.videos addObjectsFromArray:models.videos];
                [self.tableView reloadData];
            }];
        }];
        
        [self.view addSubview:_tableView];
	}
	return _tableView;
}

- (NSMutableArray <VideoModel *> *)videos {
	if(_videos == nil) {
		_videos = [[NSMutableArray <VideoModel *> alloc] init];
	}
	return _videos;
}

@end
