//
//  ViewedHistoryViewController.m
//  TucaoForiOS
//
//  Created by JimHuang on 16/10/11.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "ViewedHistoryViewController.h"
#import "ViewedHistoryViewModel.h"

@implementation ViewedHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"历史纪录";
    self.viewModel = [[ViewedHistoryViewModel alloc] init];
}

#pragma mark - UITableViewDelegate
- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        VideoModel *model = [self.viewModel videos][indexPath.row];
        [[UserDefaultManager shareUserDefaultManager] removeViewedHistory:model];
        [tableView beginUpdates];
        [tableView deleteRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView beginUpdates];
    }];
    return @[action];
}

@end
