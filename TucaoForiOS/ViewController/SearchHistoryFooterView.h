//
//  SearchHistoryFooterView.h
//  TucaoForiOS
//
//  Created by Jim_Huang on 2016/10/8.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchHistoryFooterView : UITableViewHeaderFooterView
@property (copy, nonatomic) void(^touchCallBack)();
@end
