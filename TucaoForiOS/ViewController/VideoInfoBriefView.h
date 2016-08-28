//
//  VideoInfoBriefView.h
//  TucaoForiOS
//
//  Created by JimHuang on 16/8/28.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoCollectionModel.h"

@interface VideoInfoBriefView : UIView
@property (copy, nonatomic) void(^touchUserRowCallBack)(NSString *userName, NSString *userId);
- (instancetype)initWithFrame:(CGRect)frame model:(VideoModel *)model;
@end
