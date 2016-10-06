//
//  ToolsManager.m
//  TucaoForiOS
//
//  Created by Jim_Huang on 16/9/13.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "UserDefaultManager.h"

@interface UserDefaultManager ()
@property (strong, nonatomic) NSMutableOrderedSet <VideoURLModel *>*downloadOrderedSet;
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

- (void)clearAllSearchKey {
    [_historySearchKeys removeAllObjects];
    [self setHistorySearchKeys:_historySearchKeys];
}

- (NSArray<VideoURLModel *> *)downloadVideos {
    return self.downloadOrderedSet.array;
}

- (void)addDownloadVideo:(VideoURLModel *)model {
    if (!model) return;
    [self.downloadOrderedSet addObject:model];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:_downloadOrderedSet] forKey:@"downloadVideos"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)removeDownloadVideo:(VideoURLModel *)model {
    if (!model) return;
    [self.downloadOrderedSet removeObject:model];
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:_downloadOrderedSet] forKey:@"downloadVideos"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)downloadPath {
    if (_downloadPath == nil) {
        _downloadPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"video"];
    }
    return _downloadPath;
}

- (NSMutableOrderedSet <VideoURLModel *> *)downloadOrderedSet {
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
