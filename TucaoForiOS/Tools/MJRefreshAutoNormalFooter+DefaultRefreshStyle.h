//
//  MJRefreshAutoFooter+DefaultRefreshStyle.h
//  TucaoForiOS
//
//  Created by JimHuang on 16/8/31.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import <MJRefresh/MJRefresh.h>

@interface MJRefreshAutoNormalFooter (DefaultRefreshStyle)
/**
 *  默认的刷新方式
 *
 *  @param refreshingBlock 刷新回调
 *
 *  @return self
 */
+ (instancetype)footerWithhDefaultRefreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock;
@end
