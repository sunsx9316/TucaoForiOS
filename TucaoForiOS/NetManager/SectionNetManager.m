//
//  SectionNetManager.m
//  TucaoForiOS
//
//  Created by JimHuang on 16/9/1.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "SectionNetManager.h"

@implementation SectionNetManager
+ (NSURLSessionDataTask *)sectionListWithId:(NSString *)Id
                                 totalCount:(NSUInteger)totalCount
                          completionHandler:(void(^)(VideoCollectionModel *models, TucaoErrorModel *error))complete {
    //http://www.tucao.tv/api_v2/list.php?tid=20&page=1&pagesize=21&apikey=25tids8f1ew1821ed&date=0
    
    NSUInteger page = totalCount / 21 + (totalCount % 21 != 0) + 1;
    
    return [self GETDataWithPath:[NSString stringWithFormat:@"http://www.tucao.tv/api_v2/list.php?tid=%@&page=%lu&pagesize=21&apikey=%@&date=0", Id, page, TUCAO_APPKEY] parameters:nil completionHandler:^(NSData *responseObj, TucaoErrorModel *error) {
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
