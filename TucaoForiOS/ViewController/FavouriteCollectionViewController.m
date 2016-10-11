//
//  MineCollectionViewController.m
//  TucaoForiOS
//
//  Created by Jim_Huang on 16/9/26.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "FavouriteCollectionViewController.h"
#import "FavouriteViewModel.h"

@interface FavouriteCollectionViewController ()

@end

@implementation FavouriteCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的收藏";
    self.viewModel = [[FavouriteViewModel alloc] init];
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        VideoModel *model = [self.viewModel videos][indexPath.row];
        [[UserDefaultManager shareUserDefaultManager] removeFavouriteCollectionVideo:model];
        [tableView beginUpdates];
        [tableView deleteRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView endUpdates];
    }];
    return @[action];
}
@end
