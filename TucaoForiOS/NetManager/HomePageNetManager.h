//
//  HomePageNetManager.h
//  TucaoForiOS
//
//  Created by JimHuang on 16/8/23.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "BaseNetManager.h"
#import "VideoCollectionModel.h"

@interface HomePageNetManager : BaseNetManager
+ (void)batchGETRankWithSections:(NSArray <NSString *>*)sections
                   progressBlock:(void(^)(NSUInteger numberOfFinishedOperations, VideoCollectionModel *model))progressBlock
                 completionBlock:(void(^)())completionBlock;
@end
