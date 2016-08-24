//
//  VideoNetManager.h
//  TucaoForiOS
//
//  Created by JimHuang on 16/8/24.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "BaseNetManager.h"

@interface VideoNetManager : BaseNetManager
/**
 *  获取视频播放 url
 *
 *  @param type     视频类型
 *  @param vid      视频 id
 *  @param complete 回调
 *
 *  @return 任务
 */
+ (NSURLSessionDataTask *)videoPlayURLWithType:(NSString *)type vid:(NSString *)vid completionHandler:(void(^)(NSArray *URLs, TucaoErrorModel *error))complete;
@end
