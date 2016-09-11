//
//  BangumiViewController.m
//  TucaoForiOS
//
//  Created by JimHuang on 16/8/23.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "BangumiViewController.h"

@interface BangumiViewController ()

@end

@implementation BangumiViewController

- (instancetype)init {
    if (self = [super init]) {
        self.sections = @[@"11", @"43", @"26", @"10"];
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新番";
}
@end
