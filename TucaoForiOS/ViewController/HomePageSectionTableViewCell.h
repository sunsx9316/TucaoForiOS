//
//  HomePageSectionTableViewCell.h
//  TucaoForiOS
//
//  Created by JimHuang on 16/8/23.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoCollectionModel.h"

@interface HomePageSectionTableViewCell : UITableViewCell
- (CGFloat)cellHeightWithModel:(VideoCollectionModel *)model;
@property (copy, nonatomic) void(^touchItemAtIndex)(VideoModel *model);
@end
