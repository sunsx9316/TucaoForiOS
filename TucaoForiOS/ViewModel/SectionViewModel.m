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
    NSMutableArray *_videos;
}
@synthesize videos = _videos;

- (instancetype)initWithSection:(NSString *)section {
    if (self = [super init]) {
        _section = section;
        _videos = [NSMutableArray array];
    }
    return self;
}

- (void)refresh:(BOOL)isFirstPage completion:(void(^)(TucaoErrorModel *error))completionHandler {
    [SectionNetManager sectionListWithId:_section totalCount:self.videos.count completionHandler:^(VideoCollectionModel *models, TucaoErrorModel *error) {
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
