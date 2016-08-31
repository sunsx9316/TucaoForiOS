//
//  HomePageViewController.m
//  TucaoForiOS
//
//  Created by JimHuang on 16/8/23.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "HomePageViewController.h"
#import "VideoInfoViewController.h"

#import "HomePageNetManager.h"
#import "HomePageSectionTableViewCell.h"
#import "HomePageSectionHeaderFooterView.h"

@interface HomePageViewController ()<UITableViewDelegate ,UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableDictionary <NSNumber *, VideoCollectionModel *>*responseObjects;
@property (strong, nonatomic) NSArray *sectionsArr;
@property (strong, nonatomic) NSMutableDictionary *cellHeightDic;
@end

@implementation HomePageViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    SET_NAV_BAR_DEFAULT
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor]};
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configLeftItem];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.responseObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomePageSectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomePageSectionTableViewCell" forIndexPath:indexPath];
    self.cellHeightDic[indexPath] = @([cell cellHeightWithModel:self.responseObjects[@(indexPath.section)]]);
    @weakify(self)
    [cell setTouchItemAtIndex:^(VideoModel *model) {
        @strongify(self)
        if (!self || !model) return;
        
        VideoInfoViewController *vc = [[VideoInfoViewController alloc] init];
        vc.model = model;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.cellHeightDic[indexPath] floatValue];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HomePageSectionHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HomePageSectionHeaderFooterView"];
    switch (section) {
        case 0:
            view.titleLabel.text = @"动画";
            view.iconImgView.image = [UIImage imageNamed:@"home_anima"];
            break;
        case 1:
            view.titleLabel.text = @"音乐";
            view.iconImgView.image = [UIImage imageNamed:@"home_music"];
            break;
        case 2:
            view.titleLabel.text = @"游戏";
            view.iconImgView.image = [UIImage imageNamed:@"home_game"];
            break;
        case 3:
            view.titleLabel.text = @"三次元";
            view.iconImgView.image = [UIImage imageNamed:@"home_threeD"];
            break;
        case 4:
            view.titleLabel.text = @"影剧";
            view.iconImgView.image = [UIImage imageNamed:@"home_movie"];
            break;
        case 5:
            view.titleLabel.text = @"新番";
            view.iconImgView.image = [UIImage imageNamed:@"home_bangumi"];
            break;
        default:
            break;
    }
    return view;
}

#pragma mark - 私有方法
- (void)configLeftItem {
    UIImageView *logoImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_logo"]];
    logoImgView.contentMode = UIViewContentModeScaleAspectFit;
    logoImgView.frame = CGRectMake(0, 0, 80, 40);
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:logoImgView];
    self.navigationItem.leftBarButtonItem = item;
}

#pragma mark  请求
/**
 *  请求各分区内容
 */
- (void)requestRankWithSections {
    [HomePageNetManager batchGETRankWithSections:self.sectionsArr progressBlock:^(NSUInteger numberOfFinishedOperations, VideoCollectionModel *model) {
        self.responseObjects[@(numberOfFinishedOperations)] = model;
        [self.tableView reloadData];
    } completionBlock:^{
        [self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark - 懒加载
- (UITableView *)tableView {
	if(_tableView == nil) {
		_tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[HomePageSectionTableViewCell class] forCellReuseIdentifier:@"HomePageSectionTableViewCell"];
        [_tableView registerClass:[HomePageSectionHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"HomePageSectionHeaderFooterView"];
        @weakify(self)
        _tableView.mj_header = [MJRefreshNormalHeader headerWithDefaultRefreshingBlock:^{
            @strongify(self)
            if (!self) return;
            
            [self requestRankWithSections];
        }];
        [self.view addSubview:_tableView];
	}
	return _tableView;
}

- (NSArray *)sectionsArr {
	if(_sectionsArr == nil) {
		_sectionsArr = @[@"19", @"20", @"21", @"22", @"23", @"24"];
	}
	return _sectionsArr;
}

- (NSMutableDictionary *)cellHeightDic {
	if(_cellHeightDic == nil) {
		_cellHeightDic = [[NSMutableDictionary alloc] init];
	}
	return _cellHeightDic;
}

- (NSMutableDictionary <NSNumber *, VideoCollectionModel *> *)responseObjects {
	if(_responseObjects == nil) {
		_responseObjects = [[NSMutableDictionary <NSNumber *, VideoCollectionModel *> alloc] init];
	}
	return _responseObjects;
}

@end
