//
//  ToolsManager.h
//  TucaoForiOS
//
//  Created by Jim_Huang on 16/9/13.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VideoCollectionModel.h"

@interface UserDefaultManager : NSObject
+ (instancetype)shareUserDefaultManager;
@property (strong, nonatomic, readonly) NSArray *mineCollectionVideos;
- (void)addMineCollectionVideo:(VideoModel *)model;
- (void)removeMineCollectionVideo:(VideoModel *)model;

@property (strong, nonatomic, readonly) NSArray <VideoURLModel *>*downloadVieos;
- (void)addDownloadVieos:(VideoURLModel *)model;
- (void)removeDownloadVieos:(VideoURLModel *)model;

@property (strong, nonatomic, readonly) NSString *downloadPath;
@property (strong, nonatomic, readonly) NSString *downloadResumeDataPath;

- (NSMutableArray *)historySearchKeys;
- (void)addSearchKey:(NSString *)keyWord;
- (void)clearAllSearchKey;
@end
