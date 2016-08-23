//
//  TucaoError.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/8/15.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "TucaoErrorModel.h"

@implementation TucaoErrorModel
+ (instancetype)ErrorWithCode:(TucaoErrorType)errorCode {
    NSString *errorMessage;
    
    switch (errorCode) {
        case TucaoErrorTypeNilObject:
            errorMessage = @"对象为空";
            break;
        case TucaoErrorTypeNoMatchDanmaku:
            errorMessage = @"弹幕不存在";
            break;
        case TucaoErrorTypeVersionNoExist:
            errorMessage = @"版本不存在";
            break;
        case TucaoErrorTypeEpisodeNoExist:
            errorMessage = @"分集不存在";
            break;
        case TucaoErrorTypeDanmakuNoExist:
            errorMessage = @"弹幕不存在";
            break;
        case TucaoErrorTypeVideoNoExist:
            errorMessage = @"视频不存在";
            break;
        default:
            errorMessage = @"未知错误";
            break;
    }
    
    TucaoErrorModel *error = [[TucaoErrorModel alloc] initWithDomain:errorMessage code:errorCode userInfo:nil];
    return error;
}

+ (instancetype)ErrorWithError:(NSError *)error {
    if (!error) return nil;
    
    TucaoErrorModel *model = [[TucaoErrorModel alloc] initWithDomain:error.domain code:error.code userInfo:error.userInfo];
    return model;
}

@end
