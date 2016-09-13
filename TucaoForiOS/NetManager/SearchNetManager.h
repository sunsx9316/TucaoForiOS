//
//  SearchNetManager.h
//  TucaoForiOS
//
//  Created by JimHuang on 16/9/13.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "BaseNetManager.h"

@interface SearchNetManager : BaseNetManager
+ (NSURLSessionDataTask *)searchListWithKeyword:(NSString *)keyword
                                            tid:(NSString *)tid
                                 totalCount:(NSUInteger)totalCount
                          completionHandler:(void(^)(VideoCollectionModel *models, TucaoErrorModel *error))complete;
@end
