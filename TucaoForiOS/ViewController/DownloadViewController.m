//
//  DownloadViewController.m
//  TucaoForiOS
//
//  Created by Jim_Huang on 16/9/30.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "DownloadViewController.h"
#import "VideoInfoDownloadSheetTableViewCell.h"
#import "BaseTableView.h"

@interface DownloadViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) BaseTableView *tableView;
@end

@implementation DownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"离线缓存";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateProgress:) name:@"UPDATE_PROGRESS" object:nil];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [UserDefaultManager shareUserDefaultManager].downloadVideos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoInfoDownloadSheetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VideoInfoDownloadSheetTableViewCell" forIndexPath:indexPath];
    VideoURLModel *model = [UserDefaultManager shareUserDefaultManager].downloadVideos[indexPath.row];
    [cell setWithModel:model];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 私有方法
- (void)updateProgress:(NSNotification *)aNotification {
    dispatch_async(dispatch_get_main_queue(), ^{
        VideoURLModel *model = aNotification.object;
        NSArray *arr = [UserDefaultManager shareUserDefaultManager].downloadVideos;
        if ([arr containsObject:model]) {
            NSInteger index = [arr indexOfObject:model];
            VideoInfoDownloadSheetTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
            [cell setWithModel:model];
        }        
    });
}

#pragma mark - 懒加载
- (BaseTableView *)tableView {
	if(_tableView == nil) {
		_tableView = [[BaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[VideoInfoDownloadSheetTableViewCell class] forCellReuseIdentifier:@"VideoInfoDownloadSheetTableViewCell"];
        [self.view addSubview:_tableView];
	}
	return _tableView;
}

@end
