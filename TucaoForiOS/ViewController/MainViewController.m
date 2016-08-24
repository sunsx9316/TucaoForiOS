//
//  MainViewController.m
//  TucaoForiOS
//
//  Created by JimHuang on 16/8/23.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "MainViewController.h"
#import "HomePageViewController.h"
#import "SectionViewController.h"
#import "MineViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UINavigationController *homePageVC = [self navigationControllerWithNormalImg:[UIImage imageNamed:@"home_home_tab"] selectImg:[UIImage imageNamed:@"home_home_tab_s"] rootVC:[[HomePageViewController alloc] init] title:@"首页"];
    UINavigationController *sectionVC = [self navigationControllerWithNormalImg:[UIImage imageNamed:@"home_category_tab"] selectImg:[UIImage imageNamed:@"home_category_tab_s"] rootVC:[[SectionViewController alloc] init] title:@"分区"];
    UINavigationController *mineVC = [self navigationControllerWithNormalImg:[UIImage imageNamed:@"home_mine_tab"] selectImg:[UIImage imageNamed:@"home_mine_tab_s"] rootVC:[[MineViewController alloc] init] title:@"我的"];
    
    self.viewControllers = @[homePageVC, sectionVC, mineVC];
    self.tabBar.translucent = NO;
}


- (UINavigationController *)navigationControllerWithNormalImg:(UIImage *)normalImg selectImg:(UIImage *)selectImg rootVC:(UIViewController *)rootVC title:(NSString *)title {
    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:nil image:normalImg selectedImage:[[selectImg imageByTintColor:MAIN_COLOR] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:rootVC];
    rootVC.title = title;
    navVC.tabBarItem = item;
    item.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    return navVC;
}
@end
