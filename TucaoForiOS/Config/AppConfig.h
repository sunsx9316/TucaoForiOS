//
//  AppConfig.h
//  TucaoForiOS
//
//  Created by JimHuang on 16/8/23.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#ifndef AppConfig_h
#define AppConfig_h

#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...)
#endif

//颜色
#define RGBCOLOR(r,g,b) RGBACOLOR(r,g,b,1)
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

//项目主色调
#define MAIN_COLOR RGBCOLOR(255, 51, 102)

//屏幕宽高
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
//导航栏
//设置成默认样式
#define SET_NAV_BAR_DEFAULT self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];\
[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"common_img_bar_top"] forBarMetrics:UIBarMetricsDefault];\
self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];\
self.navigationController.navigationBar.translucent = NO;

//移除iOS7之后，cell默认左侧的分割线边距
#define kRemoveCellSeparator \
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{\
cell.separatorInset = UIEdgeInsetsZero;\
cell.layoutMargins = UIEdgeInsetsZero; \
cell.preservesSuperviewLayoutMargins = NO; \
}\

//吐槽的 appkey
#define TUCAO_APPKEY @"25tids8f1ew1821ed"

#endif /* AppConfig_h */
