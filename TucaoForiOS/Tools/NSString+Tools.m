//
//  NSString+Tools.m
//  TucaoForiOS
//
//  Created by JimHuang on 16/8/23.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "NSString+Tools.h"

@implementation NSString (Tools)
+ (NSString *)stringWithFormatNum:(NSInteger)num {
    if (num >= 10000) {
        return [NSString stringWithFormat:@"%.1lf万",num * 1.0 / 10000];
    }
    return [NSString stringWithFormat:@"%ld", (long)num];
}
@end
