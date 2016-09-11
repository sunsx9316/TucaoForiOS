//
//  ThreeDViewController.m
//  TucaoForiOS
//
//  Created by JimHuang on 16/8/23.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "ThreeDViewController.h"

@interface ThreeDViewController ()

@end

@implementation ThreeDViewController

- (instancetype)init {
    if (self = [super init]) {
        self.sections = @[@"9", @"32", @"57", @"61", @"65", @"15"];
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"三次元";
}

@end
