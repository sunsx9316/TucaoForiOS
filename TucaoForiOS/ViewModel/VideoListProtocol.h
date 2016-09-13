//
//  VideoListProtocol.h
//  TucaoForiOS
//
//  Created by JimHuang on 16/9/13.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VideoCollectionModel.h"

@protocol VideoListProtocol <NSObject>
@property (strong, nonatomic) NSMutableArray <VideoModel *>*videos;
- (void)refresh:(BOOL)isFirstPage completion:(void(^)(TucaoErrorModel *error))completionHandler;
@end
