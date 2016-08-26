//
//  VideoInfoViewController.h
//  TucaoForiOS
//
//  Created by JimHuang on 16/8/25.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

//#import "BaseViewController.h"
#import "VideoCollectionModel.h"
#import <WMPageController.h>

@interface VideoInfoContainerViewController : WMPageController
@property (strong, nonatomic) VideoModel *model;
@end
