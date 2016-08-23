//
//  TucaoError.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/8/15.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

typedef NS_ENUM(NSUInteger, TucaoErrorType) {
    /**
     *  空对象错误
     */
    TucaoErrorTypeNilObject,
    /**
     *  没有弹幕匹配的错误
     */
    TucaoErrorTypeNoMatchDanmaku,
    /**
     *  版本不存在
     */
    TucaoErrorTypeVersionNoExist,
    /**
     *  分集不存在
     */
    TucaoErrorTypeEpisodeNoExist,
    /**
     *  弹幕不存在
     */
    TucaoErrorTypeDanmakuNoExist,
    /**
     *  视频不存在
     */
    TucaoErrorTypeVideoNoExist
};

#import <Foundation/Foundation.h>
/**
 *  错误模型
 */
@interface TucaoErrorModel : NSError
+ (instancetype)ErrorWithCode:(TucaoErrorType)errorCode;
+ (instancetype)ErrorWithError:(NSError *)error;
@end
