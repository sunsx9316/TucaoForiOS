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

@property (strong, nonatomic, readonly) NSArray <VideoModel *>*downloadVideos;
- (void)addDownloadVideo:(VideoURLModel *)model;
- (void)removeDownloadVideo:(VideoURLModel *)model;

@property (strong, nonatomic) NSMutableArray *historySearchKeys;
- (void)addSearchKey:(NSString *)keyWord;
- (void)removeSearchKey:(NSString *)keyWord;

@property (strong, nonatomic, readonly) NSString *downloadPath;
@end
