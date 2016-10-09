//
//  ToolsManager.m
//  TucaoForiOS
//
//  Created by Jim_Huang on 16/9/13.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "UserDefaultManager.h"
#import "NSObject+Tools.h"

@interface UserDefaultManager ()
@property (strong, nonatomic) NSMutableOrderedSet <VideoModel *>*downloadOrderedSet;
@property (strong, nonatomic) NSMutableOrderedSet <VideoModel *>*mineCollectionOrderedSet;
@end

@implementation UserDefaultManager
{
    NSMutableArray *_historySearchKeys;
    NSString *_downloadPath;
    NSString *_downloadResumeDataPath;
}

+ (instancetype)shareUserDefaultManager {
    static dispatch_once_t onceToken;
    static UserDefaultManager *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [[UserDefaultManager alloc] init];
    });
    return manager;
}

#pragma mark - 收藏记录
- (void)addMineCollectionVideo:(VideoModel *)model {
    if (!model) return;
    
    [self.mineCollectionOrderedSet addObject:model];
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:_mineCollectionOrderedSet] forKey:@"mine_collection_video"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)removeMineCollectionVideo:(VideoModel *)model {
    if (!model) return;
    
    [self.mineCollectionOrderedSet removeObject:model];
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:_mineCollectionOrderedSet] forKey:@"mine_collection_video"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSArray *)mineCollectionVideos {
    return self.mineCollectionOrderedSet.array;
}


#pragma mark - 搜索纪录
- (void)setHistorySearchKeys:(NSMutableArray *)historySearchKeys {
    _historySearchKeys = historySearchKeys;
    [[NSUserDefaults standardUserDefaults] setObject:historySearchKeys forKey:@"history_search_key"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSArray<NSString *> *)historySearchKeys {
    if (_historySearchKeys == nil) {
        _historySearchKeys = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:@"history_search_key"]];
    }
    return _historySearchKeys;
}

- (void)addSearchKey:(NSString *)keyWord {
    if (keyWord.length == 0) return;
    //保存了则将它删除
    if ([_historySearchKeys containsObject:keyWord]) {
        [_historySearchKeys removeObject:keyWord];
    }
    [_historySearchKeys insertObject:keyWord atIndex:0];
    [self setHistorySearchKeys:_historySearchKeys];
}

- (void)removeSearchKey:(NSString *)keyWord {
    if (keyWord.length == 0) return;
    
    [_historySearchKeys removeObject:keyWord];
    [self setHistorySearchKeys:_historySearchKeys];
}

#pragma mark - 下载记录
- (NSArray<VideoModel *> *)downloadVideos {
    return self.downloadOrderedSet.array;
}

- (void)addDownloadVideo:(VideoURLModel *)model {
    VideoModel *videoModel = [model weakAssociationWithKey:@"videoModel"];
    
    if (!model || !videoModel) return;
    //存在则添加地址部分
    if ([self.downloadOrderedSet containsObject:videoModel]) {
        NSInteger index = [self.downloadOrderedSet indexOfObject:videoModel];
        VideoModel *aModel = [self.downloadOrderedSet objectAtIndex:index];
        if ([aModel.URLs containsObject:model]) {
            index = [aModel.URLs indexOfObject:model];
            aModel.URLs[index] = model;
        }
        else {
            [aModel.URLs addObject:model];
        }
    }
    else {
        [self.downloadOrderedSet addObject:videoModel];
    }
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:_downloadOrderedSet] forKey:@"downloadVideos"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)removeDownloadVideo:(VideoURLModel *)model {
    VideoModel *videoModel = [model weakAssociationWithKey:@"videoModel"];
    
    if (!model || !videoModel) return;
    
    if ([self.downloadOrderedSet containsObject:videoModel]) {
        //只剩一个直接移除
        if (self.downloadOrderedSet.count == 1) {
            [self.downloadOrderedSet removeObject:videoModel];
        }
        else {
            NSInteger index = [self.downloadOrderedSet indexOfObject:videoModel];
            VideoModel *aModel = [self.downloadOrderedSet objectAtIndex:index];
            [aModel.URLs removeObject:model];
        }
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:_downloadOrderedSet] forKey:@"downloadVideos"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - 下载路径
- (NSString *)downloadPath {
    if (_downloadPath == nil) {
        _downloadPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"video"];
    }
    return _downloadPath;
}

#pragma mark - 懒加载
- (NSMutableOrderedSet <VideoModel *> *)downloadOrderedSet {
	if(_downloadOrderedSet == nil) {
		_downloadOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"downloadVideos"]]];
	}
	return _downloadOrderedSet;
}

- (NSMutableOrderedSet <VideoModel *> *)mineCollectionOrderedSet {
	if(_mineCollectionOrderedSet == nil) {
        NSOrderedSet *set = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"mine_collection_video"]];
        _mineCollectionOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:set];
	}
	return _mineCollectionOrderedSet;
}

@end
