//
//  HomePageViewController.m
//  TucaoForiOS
//
//  Created by JimHuang on 16/8/23.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "HomePageViewController.h"
#import "HomePageNetManager.h"
#import "HomePageSectionTableViewCell.h"

@interface HomePageViewController ()<UITableViewDelegate ,UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray<VideoCollectionModel *> *responseObjects;
@property (strong, nonatomic) NSArray *sectionsArr;
@property (strong, nonatomic) NSMutableDictionary *cellHeightDic;
@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [HomePageNetManager batchGETRankWithSections:self.sectionsArr progressBlock:^(NSUInteger numberOfFinishedOperations, VideoCollectionModel *model) {
        self.responseObjects[numberOfFinishedOperations] = model;
        [self.tableView reloadSection:numberOfFinishedOperations withRowAnimation:UITableViewRowAnimationNone];
    } completionBlock:nil];
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
    self.cellHeightDic[indexPath] = @([cell cellHeightWithModel:self.responseObjects[indexPath.section]]);
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.cellHeightDic[indexPath] floatValue];
}


#pragma mark - 懒加载
- (UITableView *)tableView {
	if(_tableView == nil) {
		_tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[HomePageSectionTableViewCell class] forCellReuseIdentifier:@"HomePageSectionTableViewCell"];
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

- (NSMutableArray<VideoCollectionModel *> *)responseObjects {
	if(_responseObjects == nil) {
        _responseObjects = [NSMutableArray arrayWithArray:@[[[NSNull alloc] init], [[NSNull alloc] init], [[NSNull alloc] init], [[NSNull alloc] init], [[NSNull alloc] init], [[NSNull alloc] init]]];
	}
	return _responseObjects;
}

@end
