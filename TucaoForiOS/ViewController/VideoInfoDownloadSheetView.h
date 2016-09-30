//
//  VIdeoInfoDownloadSheetView.h
//  TucaoForiOS
//
//  Created by Jim_Huang on 16/9/30.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoCollectionModel.h"

@interface VideoInfoDownloadSheetView : UIView
@property (strong, nonatomic) VideoModel *model;
@property (copy, nonatomic) void(^touchJumpToDownloadViewControllerButtonCallBack)();
@property (copy, nonatomic) void(^touchTableViewWithModel)(VideoURLModel *model);
- (void)show;
- (void)dismiss;
@end
