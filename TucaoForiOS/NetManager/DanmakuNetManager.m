//
//  DanmakuNetManager.m
//  TucaoForiOS
//
//  Created by JimHuang on 16/8/24.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "DanmakuNetManager.h"
#import "DanmakuDataFormatter.h"

@implementation DanmakuNetManager
+ (NSURLSessionDataTask *)danmakuDicWithHid:(NSString *)hid part:(NSString *)part completionHandler:(void(^)(NSDictionary *danmakuDic, TucaoErrorModel *error))complete {
    //http://www.tucao.tv/index.php?m=mukio&c=index&a=init&playerID=44-4053191-1-0&r=996
    
    if (part.length == 0) {
        part = @"0";
    }
    
    NSString *path = [[NSString alloc] initWithFormat:@"http://www.tucao.tv/index.php?m=mukio&c=index&a=init&playerID=11-%@-1-%@&r=%u", hid, part, arc4random()];
    return [self GETDataWithPath:path parameters:nil completionHandler:^(id responseObj, TucaoErrorModel *error) {
        NSDictionary *dic = [DanmakuDataFormatter dicWithObj:responseObj];
        complete(dic, error);
    }];
}
@end
