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
+ (NSURLSessionDataTask *)videoPlayURLWithType:(NSString *)type
                                           vid:(NSString *)vid
                             completionHandler:(void(^)(NSArray *URLs, TucaoErrorModel *error))complete;
/**
 *  批量获取视频地址 完成之后会自动给模型的下载状态和地址赋值
 *
 *  @param model           视频模型
 *  @param progressBlock   进度回调
 *  @param completionBlock 完成回调
 */
+ (void)batchGETVideoPlayURLWithModels:(NSArray <VideoURLModel *>*)models
                   progressBlock:(void(^)(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations))progressBlock
                 completionBlock:(void(^)())completionBlock;
@end
