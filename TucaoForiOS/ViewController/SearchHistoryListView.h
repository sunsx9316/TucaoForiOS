//
//  SearchHistoryListView.h
//  TucaoForiOS
//
//  Created by JimHuang on 16/9/13.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchHistoryListView : UIView
@property (copy, nonatomic) void(^touchIndexCallBack)(NSString *keyword);
@property (copy, nonatomic) void(^touchTableViewCallBack)();
- (void)addSearchKey:(NSString *)keyWord;
@end
