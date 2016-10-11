//
//  ViewedHistoryViewModel.m
//  TucaoForiOS
//
//  Created by JimHuang on 16/10/11.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "ViewedHistoryViewModel.h"

@implementation ViewedHistoryViewModel
@synthesize videos;

- (void)refresh:(BOOL)isFirstPage completion:(void(^)(TucaoErrorModel *error))completionHandler {
    if (completionHandler) {
        TucaoErrorModel *err;
        if (self.videos == nil) {
            err = [TucaoErrorModel ErrorWithCode:TucaoErrorTypeNilObject];
        }
        completionHandler(err);
    }
}

#pragma mark - 懒加载
- (NSArray <VideoModel *> *)videos {
    return [UserDefaultManager shareUserDefaultManager].viewedHistoryVideos;
}
@end
