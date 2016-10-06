//
//  SearchNetManager.m
//  TucaoForiOS
//
//  Created by JimHuang on 16/9/13.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "SearchNetManager.h"

@implementation SearchNetManager
+ (NSURLSessionDataTask *)searchListWithKeyword:(NSString *)keyword
                                            tid:(NSString *)tid
                                     totalCount:(NSUInteger)totalCount
                              completionHandler:(void(^)(VideoCollectionModel *models, TucaoErrorModel *error))complete {
    //http://www.tucao.tv/api_v2/search.php?apikey=25tids8f1ew1821ed&q=233&page=1&pagesize=20&tid=20
    NSUInteger page = totalCount / 21 + (totalCount % 21 != 0) + 1;
    if (tid.length == 0) tid = @"0";
    keyword = [keyword stringByURLEncode];
    
    return [self GETDataWithPath:[NSString stringWithFormat:@"http://www.tucao.tv/api_v2/search.php?apikey=%@&q=%@&page=%ld&pagesize=21&tid=%@", TUCAO_APPKEY, keyword, page, tid] parameters:nil completionHandler:^(NSData *responseObj, TucaoErrorModel *error) {
        if (responseObj == nil) {
            complete(nil, [TucaoErrorModel ErrorWithCode:TucaoErrorTypeNilObject]);
            return;
        }
        
        NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingAllowFragments error:nil][@"result"];
        if ([tempDic isKindOfClass:[NSDictionary class]]) {
            complete([VideoCollectionModel yy_modelWithDictionary:@{@"result":tempDic.allValues}], error);
        }
        else if ([tempDic isKindOfClass:[NSArray class]]) {
            complete([VideoCollectionModel yy_modelWithDictionary:@{@"result":tempDic}], error);
        }
        else {
            complete(nil, [TucaoErrorModel ErrorWithCode:TucaoErrorTypeNilObject]);
        }
    }];

}
@end
