//
//  DanmakuNetManager.h
//  TucaoForiOS
//
//  Created by JimHuang on 16/8/24.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "BaseNetManager.h"

@interface DanmakuNetManager : BaseNetManager
+ (NSURLSessionDataTask *)danmakuDicWithHid:(NSString *)hid
                                       part:(NSString *)part
                          completionHandler:(void(^)(NSDictionary *danmakuDic, TucaoErrorModel *error))complete;
@end
