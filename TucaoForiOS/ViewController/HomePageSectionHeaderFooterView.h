//
//  HomePageSectionHeaderFooterView.h
//  TucaoForiOS
//
//  Created by JimHuang on 16/8/24.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomePageSectionHeaderFooterView : UITableViewHeaderFooterView
@property (strong, nonatomic) UIImageView *iconImgView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (copy, nonatomic) void(^touchCallBack)();
@end
