//
//  NSString+Tools.h
//  TucaoForiOS
//
//  Created by JimHuang on 16/8/23.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Tools)
+ (NSString *)stringWithFormatNum:(NSInteger)num;
/**
 *  从时间长整数转成字符串
 *
 *  @param time 时间长整数
 *
 *  @return 格式化的时间
 */
+ (NSString *)stringWithCreatTime:(NSString *)time;
@end
