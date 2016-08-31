//
//  MJRefreshAutoFooter+DefaultRefreshStyle.m
//  TucaoForiOS
//
//  Created by JimHuang on 16/8/31.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "MJRefreshAutoNormalFooter+DefaultRefreshStyle.h"

@implementation MJRefreshAutoNormalFooter (DefaultRefreshStyle)
+ (instancetype)footerWithhDefaultRefreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock {
    MJRefreshAutoNormalFooter *foot = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:refreshingBlock];
    foot.automaticallyChangeAlpha = YES;
    [foot setTitle:@"再拉，再拉就刷新给你看" forState:MJRefreshStateIdle];
    [foot setTitle:@"够了啦，松开人家嘛" forState:MJRefreshStatePulling];
    [foot setTitle:@"刷呀刷，好累啊，喵(＾▽＾)" forState:MJRefreshStateRefreshing];
    return foot;
}
@end
