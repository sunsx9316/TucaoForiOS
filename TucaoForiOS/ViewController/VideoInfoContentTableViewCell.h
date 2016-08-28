//
//  VideoInfoContentTableViewCell.h
//  TucaoForiOS
//
//  Created by JimHuang on 16/8/28.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoCollectionModel.h"

@interface VideoInfoContentTableViewCell : UITableViewCell
@property (strong, nonatomic) VideoModel *model;
@property (copy, nonatomic) void(^carouselDidScrollWithPrgress)(CGFloat progress);
@end
