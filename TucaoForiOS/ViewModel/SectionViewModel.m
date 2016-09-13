//
//  SectionViewModel.m
//  TucaoForiOS
//
//  Created by JimHuang on 16/9/13.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "SectionViewModel.h"
#import "SectionNetManager.h"

@implementation SectionViewModel
{
    NSString *_section;
}
@synthesize videos = _videos;

- (instancetype)initWithSection:(NSString *)section {
    if (self = [super init]) {
        _section = section;
    }
    return self;
}

- (void)refresh:(BOOL)isFirstPage completion:(void(^)(TucaoErrorModel *error))completionHandler {
    [SectionNetManager sectionListWithId:_section totalCount:self.videos.count completionHandler:^(VideoCollectionModel *models, TucaoErrorModel *error) {
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
