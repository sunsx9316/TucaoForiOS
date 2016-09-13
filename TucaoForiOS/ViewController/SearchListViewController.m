//
//  SearchListViewController.m
//  TucaoForiOS
//
//  Created by JimHuang on 16/9/13.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "SearchListViewController.h"
#import "SearchViewModel.h"

@interface SearchListViewController ()
@property (strong, nonatomic) SearchViewModel *vm;
@end

@implementation SearchListViewController

- (instancetype)initWithKeyword:(NSString *)keyword {
    if (self = [super init]) {
        _vm = [[SearchViewModel alloc] init];
        _vm.keyword = keyword;
        self.viewModel = _vm;
    }
    return self;
}

@end
