//
//  HomePageNetManager.m
//  TucaoForiOS
//
//  Created by JimHuang on 16/8/23.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "HomePageNetManager.h"

@implementation HomePageNetManager
+ (void)batchGETRankWithSections:(NSArray <NSString *>*)sections completionBlock:(void(^)(NSArray <VideoCollectionModel *>*responseObjects))completionBlock {
    //http://www.tucao.tv/api_v2/rank.php?tid=19&apikey=25tids8f1ew1821ed&date=0
    NSMutableArray *tempArr = [NSMutableArray array];
    
    [sections enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [tempArr addObject:[NSString stringWithFormat:@"http://www.tucao.tv/api_v2/rank.php?tid=%@&apikey=%@&date=0", obj, TUCAO_APPKEY]];
    }];
    
    [self batchGETDataWithPaths:tempArr progressBlock:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations, __autoreleasing id *responseObj) {
        NSLog(@"%ld %ld", numberOfFinishedOperations, totalNumberOfOperations);
    } completionBlock:^(NSArray *responseObjects, NSArray<NSURLSessionTask *> *tasks) {
        NSMutableArray *responseArr = [NSMutableArray array];
        for (NSData *data in responseObjects) {
            VideoCollectionModel *model = [VideoCollectionModel yy_modelWithJSON:data];
            if (model) {
                [responseArr addObject:model];
            }
        }
        completionBlock(responseArr);
    }];
}
@end
