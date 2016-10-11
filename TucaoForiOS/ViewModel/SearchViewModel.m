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
{
    NSMutableArray *_videos;
}

@synthesize videos = _videos;
- (instancetype)init {
    if (self = [super init]) {
        _videos = [NSMutableArray array];
    }
    return self;
}

- (void)refresh:(BOOL)isFirstPage completion:(void (^)(TucaoErrorModel *))completionHandler {
    [SearchNetManager searchListWithKeyword:_keyword tid:_tid totalCount:self.videos.count completionHandler:^(VideoCollectionModel *models, TucaoErrorModel *error) {
        if (isFirstPage) {
            [_videos removeAllObjects];
        }
        [_videos addObjectsFromArray:models.videos];
        if (completionHandler) {
            completionHandler(error);
        }
    }];
}

@end
