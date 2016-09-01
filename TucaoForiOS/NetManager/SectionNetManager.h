//
//  SectionNetManager.h
//  TucaoForiOS
//
//  Created by JimHuang on 16/9/1.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "BaseNetManager.h"

@interface SectionNetManager : BaseNetManager
/**
 *  请求分区列表
 *
 *  @param Id         分区id
 *  @param totalCount 当前集合总数
 *  @param complete   回调
 *
 *  @return 任务
 */
+ (NSURLSessionDataTask *)sectionListWithId:(NSString *)Id
                                       totalCount:(NSUInteger)totalCount
                          completionHandler:(void(^)(VideoCollectionModel *models, TucaoErrorModel *error))complete;
@end
