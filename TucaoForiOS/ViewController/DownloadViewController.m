//
//  DownloadViewController.m
//  TucaoForiOS
//
//  Created by Jim_Huang on 16/9/30.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "DownloadViewController.h"
#import "VideoInfoDownloadSheetTableViewCell.h"
#import "DownloadHeaderView.h"
#import "BaseTableView.h"
#import "NSObject+Tools.h"

@interface DownloadViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) BaseTableView *tableView;
@property (strong, nonatomic) NSArray<VideoModel *>*downloadVideos;
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.downloadVideos.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.downloadVideos[section].URLs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoInfoDownloadSheetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VideoInfoDownloadSheetTableViewCell" forIndexPath:indexPath];
    [cell setWithModel:self.downloadVideos[indexPath.section].URLs[indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    DownloadHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"DownloadHeaderView"];
    [view setWithModel:self.downloadVideos[section]];
    return view;
}

//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    [self.downloadVideos enumerateObjectsUsingBlock:^(VideoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        [self.treeView expandRowForItem:obj expandChildren:YES withRowAnimation:RATreeViewRowAnimationNone];
//    }];
//}

//#pragma mark - RATreeViewDataSource
//- (NSInteger)treeView:(RATreeView *)treeView numberOfChildrenOfItem:(nullable id)item {
//    if (item == nil) {
//        return self.downloadVideos.count;
//    }
//    else if ([item isKindOfClass:[VideoModel class]]) {
//        VideoModel *model = item;
//        return model.URLs.count;
//    }
//    return 0;
//}
//
//- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(nullable id)item {
//    if ([item isKindOfClass:[VideoURLModel class]]) {
//        VideoInfoDownloadSheetTableViewCell *cell = [treeView dequeueReusableCellWithIdentifier:@"VideoInfoDownloadSheetTableViewCell"];
//        if (!cell) {
//            cell = [[VideoInfoDownloadSheetTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"VideoInfoDownloadSheetTableViewCell"];
//        }
//        [cell setWithModel:item];
//        return cell;
//    }
//    else if ([item isKindOfClass:[VideoModel class]]) {
//        DownloadHeaderTableViewCell *cell = [treeView dequeueReusableCellWithIdentifier:@"DownloadHeaderTableViewCell"];
//        if (!cell) {
//            cell = [[DownloadHeaderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DownloadHeaderTableViewCell"];
//        }
//        [cell setWithModel:item];
//        return cell;
//    }
//    return nil;
//}
//
//- (id)treeView:(RATreeView *)treeView child:(NSInteger)index ofItem:(nullable id)item {
//    if (item == nil) {
//        return self.downloadVideos[index];
//    }
//    else if ([item isKindOfClass:[VideoModel class]]) {
//        VideoModel *model = item;
//        return model.URLs[index];
//    }
//    return nil;
//}
//
//#pragma mark - RATreeViewDelegate
//- (CGFloat)treeView:(RATreeView *)treeView heightForRowForItem:(id)item {
//    if ([item isKindOfClass:[VideoURLModel class]]) {
//        return 50;
//    }
//    return 70;
//}
//
//- (void)treeView:(RATreeView *)treeView didSelectRowForItem:(id)item {
//    [treeView deselectRowForItem:item animated:YES];
//}
//
//- (NSArray *)treeView:(RATreeView *)treeView editActionsForItem:(id)item {
//    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//        if ([item isKindOfClass:[VideoURLModel class]]) {
//            [[UserDefaultManager shareUserDefaultManager] removeDownloadVideo:item];
//            [treeView deleteItemsAtIndexes:[NSIndexSet indexSetWithIndex:indexPath.row] inParent:[treeView parentForItem:item] withAnimation:RATreeViewRowAnimationAutomatic];
//        }
//    }];
//    return @[action];
//}

#pragma mark - 私有方法
- (void)updateProgress:(NSNotification *)aNotification {
    dispatch_async(dispatch_get_main_queue(), ^{
        VideoURLModel *model = aNotification.object;
        VideoModel *videoModel = [model weakAssociationWithKey:@"videoModel"];
        NSArray *arr = [UserDefaultManager shareUserDefaultManager].downloadVideos;
        if ([arr containsObject:model]) {
            NSIndexPath *index = [NSIndexPath indexPathForRow:[videoModel.URLs indexOfObject:model] inSection:[self.downloadVideos indexOfObject:videoModel]];
            VideoInfoDownloadSheetTableViewCell *cell = [self.tableView cellForRowAtIndexPath:index];
            [cell setWithModel:model];
        }
    });
}

#pragma mark - 懒加载
- (NSArray<VideoModel *> *)downloadVideos {
	if(_downloadVideos == nil) {
		_downloadVideos = [UserDefaultManager shareUserDefaultManager].downloadVideos;
	}
	return _downloadVideos;
}

- (BaseTableView *)tableView {
	if(_tableView == nil) {
		_tableView = [[BaseTableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[VideoInfoDownloadSheetTableViewCell class] forCellReuseIdentifier:@"VideoInfoDownloadSheetTableViewCell"];
        [_tableView registerClass:[DownloadHeaderView class] forHeaderFooterViewReuseIdentifier:@"DownloadHeaderView"];
        [self.view addSubview:_tableView];
	}
	return _tableView;
}

@end
