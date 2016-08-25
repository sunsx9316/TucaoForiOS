//
//  BaseViewController.m
//  TucaoForiOS
//
//  Created by JimHuang on 16/8/23.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    SET_NAV_BAR_DEFAULT
    self.hidesBottomBarWhenPushed = YES;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor]};
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configLeftItem];
}

#pragma mark - 私有方法
- (void)configLeftItem {
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [backButton addTarget:self action:@selector(touchLeftItem:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[[UIImage imageNamed:@"common_rightArrowShadow"] imageByRotate180] forState:UIControlStateNormal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)touchLeftItem:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
