//
//  VideoInfoEpisodeTableViewCell.h
//  TucaoForiOS
//
//  Created by JimHuang on 16/8/25.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface VideoInfoEpisodeTableViewCell : UITableViewCell
- (CGFloat)cellHeightWithModels:(NSArray <VideoURLModel *>*)models;
@property (copy, nonatomic) void(^touchItemAtIndex)(NSUInteger);
@end
