//
//  BaseVideoListViewController.h
//  TucaoForiOS
//
//  Created by JimHuang on 16/9/13.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "BaseViewController.h"
#import "VideoListProtocol.h"
#import "BaseTableView.h"

@interface BaseVideoListViewController : BaseViewController
@property (strong, nonatomic) id<VideoListProtocol>viewModel;
@property (strong, nonatomic) BaseTableView *tableView;
@end
