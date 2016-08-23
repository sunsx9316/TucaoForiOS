//
//  HomePageViewController.m
//  TucaoForiOS
//
//  Created by JimHuang on 16/8/23.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "HomePageViewController.h"
#import "HomePageNetManager.h"

@interface HomePageViewController ()<UITableViewDelegate ,UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray<VideoCollectionModel *> *responseObjects;
@property (strong, nonatomic) NSArray *sectionsArr;
@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [HomePageNetManager batchGETRankWithSections:self.sectionsArr completionBlock:^(NSArray<VideoCollectionModel *> *responseObjects) {
        self.responseObjects = responseObjects;
    }];
}

#pragma mark - UITableViewDelegate

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionsArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}


#pragma mark - 懒加载
- (UITableView *)tableView {
	if(_tableView == nil) {
		_tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
	}
	return _tableView;
}

- (NSArray *)sectionsArr {
	if(_sectionsArr == nil) {
		_sectionsArr = @[@"19", @"20", @"21", @"22", @"23", @"24"];
	}
	return _sectionsArr;
}

@end
