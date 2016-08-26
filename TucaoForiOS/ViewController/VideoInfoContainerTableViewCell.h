//
//  VideoInfoContainerTableViewCell.h
//  TucaoForiOS
//
//  Created by JimHuang on 16/8/25.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoCollectionModel.h"

@interface VideoInfoContainerTableViewCell : UITableViewCell
@property (strong, nonatomic) VideoModel *model;
@property (copy, nonatomic) void(^tableViewDidScroll)(CGFloat contentOffsetY);
@property (copy, nonatomic) void(^touchUserRow)(NSString *userName, NSString *userId);
@end
