//
//  BaseSectionViewController.m
//  TucaoForiOS
//
//  Created by JimHuang on 16/9/1.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "BaseSectionViewController.h"
#import "SectionViewModel.h"
@implementation BaseSectionViewController
- (instancetype)initWithSection:(NSString *)section {
    if (self = [super init]) {
        self.viewModel = [[SectionViewModel alloc] initWithSection:section];
    }
    return self;
}
@end
