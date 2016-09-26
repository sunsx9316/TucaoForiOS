//
//  ToolsManager.h
//  TucaoForiOS
//
//  Created by Jim_Huang on 16/9/13.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VideoCollectionModel.h"

@interface ToolsManager : NSObject
+ (instancetype)shareToolsManager;
@property (strong, nonatomic, readonly) NSArray *mineCollectionVideos;
- (void)addMineCollectionVideo:(VideoModel *)model;
- (void)removeMineCollectionVideo:(VideoModel *)model;

- (NSMutableArray *)historySearchKeys;
- (void)addSearchKey:(NSString *)keyWord;
- (void)clearAllSearchKey;
@end
