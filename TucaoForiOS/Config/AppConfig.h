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
#define MAIN_COLOR RGBCOLOR(51, 151, 252)
#define MAIN_DARK_COLOR RGBCOLOR(53, 60, 59)
#define BACK_GROUND_COLOR [UIColor whiteColor]

//屏幕宽高
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
//导航栏
//设置成自定义颜色
#define SET_NAV_BAR_COLOR(color, isTranslucent) self.navigationController.navigationBar.barTintColor = color;\
[self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];\
self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];\
self.navigationController.navigationBar.translucent = isTranslucent;
//设置成默认样式
#define SET_NAV_BAR_DEFAULT SET_NAV_BAR_COLOR([UIColor whiteColor], NO)
//透明
#define SET_NAVIGATION_BAR_CLEAR SET_NAV_BAR_COLOR([UIColor whiteColor], YES)

//移除iOS7之后，cell默认左侧的分割线边距
#define kRemoveCellSeparator \
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{\
cell.separatorInset = UIEdgeInsetsZero;\
cell.layoutMargins = UIEdgeInsetsZero; \
cell.preservesSuperviewLayoutMargins = NO; \
}\

//吐槽的 appkey
#define TUCAO_APPKEY @"25tids8f1ew1821ed"

//YYWebImage 默认加载方法
#define YYWEBIMAGE_DEFAULT_OPTION YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation

#endif /* AppConfig_h */
