//
//  AnimationViewController.m
//  TucaoForiOS
//
//  Created by JimHuang on 16/8/23.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "AnimationViewController.h"

@interface AnimationViewController ()
@end

@implementation AnimationViewController

- (instancetype)init {
    if (self = [super init]) {
        self.sections = @[@"29", @"25", @"6", @"28"];
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"动画";
}

@end
