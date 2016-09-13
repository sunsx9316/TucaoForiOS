//
//  SearchViewModel.m
//  TucaoForiOS
//
//  Created by JimHuang on 16/9/13.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "SearchViewModel.h"
#import "SearchNetManager.h"

@implementation SearchViewModel
@synthesize videos = _videos;

- (void)refresh:(BOOL)isFirstPage completion:(void (^)(TucaoErrorModel *))completionHandler {
    [SearchNetManager searchListWithKeyword:_keyword tid:_tid totalCount:self.videos.count completionHandler:^(VideoCollectionModel *models, TucaoErrorModel *error) {
        if (isFirstPage) {
            [self.videos removeAllObjects];
        }
        [self.videos addObjectsFromArray:models.videos];
        if (completionHandler) {
            completionHandler(error);
        }
    }];
}

#pragma mark - 懒加载
- (NSMutableArray <VideoModel *> *)videos {
    if(_videos == nil) {
        _videos = [[NSMutableArray <VideoModel *> alloc] init];
    }
    return _videos;
}
@end
