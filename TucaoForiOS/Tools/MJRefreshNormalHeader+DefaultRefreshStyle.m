//
//  MJRefreshNormalHeader+DefaultRefreshStyle.m
//  TucaoForiOS
//
//  Created by JimHuang on 16/8/24.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "MJRefreshNormalHeader+DefaultRefreshStyle.h"

@implementation MJRefreshNormalHeader (DefaultRefreshStyle)
+ (instancetype)headerWithDefaultRefreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock {
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:refreshingBlock];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.automaticallyChangeAlpha = YES;
    [header setTitle:@"再拉，再拉就刷新给你看" forState:MJRefreshStateIdle];
    [header setTitle:@"够了啦，松开人家嘛" forState:MJRefreshStatePulling];
    [header setTitle:@"刷呀刷，好累啊，喵(＾▽＾)" forState:MJRefreshStateRefreshing];
    return header;
}
@end
