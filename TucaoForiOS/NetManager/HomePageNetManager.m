//
//  HomePageNetManager.m
//  TucaoForiOS
//
//  Created by JimHuang on 16/8/23.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "HomePageNetManager.h"

@implementation HomePageNetManager
+ (void)batchGETRankWithSections:(NSArray <NSString *>*)sections
                   progressBlock:(void(^)(NSUInteger numberOfFinishedOperations, VideoCollectionModel *model))progressBlock
                 completionBlock:(void(^)())completionBlock {
    //http://www.tucao.tv/api_v2/rank.php?tid=19&apikey=25tids8f1ew1821ed&date=0
    NSMutableArray *tempArr = [NSMutableArray array];
    
    [sections enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [tempArr addObject:[NSString stringWithFormat:@"http://www.tucao.tv/api_v2/list.php?tid=%@&page=1&pagesize=21&apikey=%@&date=0", obj, TUCAO_APPKEY]];
    }];
    
    [self batchGETDataWithPaths:tempArr progressBlock:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations, __autoreleasing id *responseObj) {
        NSLog(@"%ld %ld", numberOfFinishedOperations, totalNumberOfOperations);
        if (progressBlock) {
            if (responseObj != nil) {
                NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:*responseObj options:NSJSONReadingAllowFragments error:nil][@"result"];
                if ([tempDic isKindOfClass:[NSDictionary class]]) {
                    progressBlock(numberOfFinishedOperations, [VideoCollectionModel yy_modelWithDictionary:@{@"result":tempDic.allValues}]);
                }
                else if ([tempDic isKindOfClass:[NSArray class]]) {
                    progressBlock(numberOfFinishedOperations, [VideoCollectionModel yy_modelWithDictionary:@{@"result":tempDic}]);
                }
            }
            else {
                progressBlock(numberOfFinishedOperations, nil);
            }
        }
    } completionBlock:^(NSArray *responseObjects, NSArray<NSURLSessionTask *> *tasks) {
        if (completionBlock) {
            completionBlock();
        }
    }];
}
@end
