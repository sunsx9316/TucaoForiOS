//
//  ToolsManager.m
//  TucaoForiOS
//
//  Created by Jim_Huang on 16/9/13.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "UserDefaultManager.h"

@implementation UserDefaultManager
{
    NSMutableArray *_historySearchKeys;
    //收藏数组
    NSMutableOrderedSet <VideoModel *>*_mineCollectionVideos;
    NSMutableOrderedSet <VideoURLModel *>*_downloadVieos;
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

- (void)addMineCollectionVideo:(VideoModel *)model {
    if (!model) return;
    
    [_mineCollectionVideos addObject:model];
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:_mineCollectionVideos] forKey:@"mine_collection_video"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)removeMineCollectionVideo:(VideoModel *)model {
    if (!model) return;
    
    [_mineCollectionVideos removeObject:model];
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:_mineCollectionVideos] forKey:@"mine_collection_video"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSArray *)mineCollectionVideos {
    if (_mineCollectionVideos == nil) {
        NSOrderedSet *set = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"mine_collection_video"]];
        _mineCollectionVideos = [NSMutableOrderedSet orderedSetWithOrderedSet:set];
    }
    return _mineCollectionVideos.array;
}

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

- (void)clearAllSearchKey {
    [_historySearchKeys removeAllObjects];
    [self setHistorySearchKeys:_historySearchKeys];
}

- (NSArray *)downloadVieos {
    if(_downloadVieos == nil) {
        _downloadVieos = [NSMutableOrderedSet orderedSetWithOrderedSet:[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"downloadVieos"]]];
    }
    return _downloadVieos.array;
}

- (void)addDownloadVieos:(VideoURLModel *)model {
    if (!model) return;
    [_downloadVieos addObject:model];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:_downloadVieos] forKey:@"downloadVieos"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)removeDownloadVieos:(VideoURLModel *)model {
    if (!model) return;
    [_downloadVieos removeObject:model];
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:_downloadVieos] forKey:@"downloadVieos"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)downloadPath {
    if (_downloadPath == nil) {
        _downloadPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"video"];
    }
    return _downloadPath;
}

- (NSString *)downloadResumeDataPath {
    if (_downloadResumeDataPath == nil) {
        _downloadResumeDataPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"videoResumeData"];
    }
    return _downloadResumeDataPath;
}

@end
