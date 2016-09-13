//
//  SectionViewController.m
//  TucaoForiOS
//
//  Created by JimHuang on 16/8/23.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "SectionViewController.h"
#import "SectionCollectionViewCell.h"
#import "AnimationViewController.h"
#import "MusicViewController.h"
#import "ThreeDViewController.h"
#import "GameViewController.h"
#import "MovieViewController.h"
#import "BangumiViewController.h"

@interface SectionViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *resourceArr;
@end

@implementation SectionViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    SET_NAV_BAR_COLOR(MAIN_COLOR, NO)
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.resourceArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SectionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SectionCollectionViewCell" forIndexPath:indexPath];
//    cell.backgroundColor = self.resourceArr[indexPath.item][@"color"];
    cell.iconImgView.image = self.resourceArr[indexPath.item][@"icon"];
    cell.titleLabel.text = self.resourceArr[indexPath.item][@"title"];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == 0) {
        AnimationViewController *vc = [[AnimationViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.item == 1) {
        MusicViewController *vc = [[MusicViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.item == 2) {
        ThreeDViewController *vc = [[ThreeDViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.item == 3) {
        GameViewController *vc = [[GameViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.item == 4) {
        MovieViewController *vc = [[MovieViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.item == 5) {
        BangumiViewController *vc = [[BangumiViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - 懒加载
- (UICollectionView *)collectionView {
	if(_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        float value = (self.view.width - 40) / 3 - 1;
        layout.itemSize = CGSizeMake(value, value + 10);
		_collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = BACK_GROUND_COLOR;
        [_collectionView registerClass:[SectionCollectionViewCell class] forCellWithReuseIdentifier:@"SectionCollectionViewCell"];
        [self.view addSubview:_collectionView];
	}
	return _collectionView;
}

- (NSArray *)resourceArr {
	if(_resourceArr == nil) {
        _resourceArr = @[
  @{@"title":@"动画", @"icon": [[UIImage imageNamed:@"home_anima"] imageByTintColor:RGBCOLOR(212, 131, 247)]},
  @{@"title":@"音乐", @"icon": [[UIImage imageNamed:@"home_music"] imageByTintColor:RGBCOLOR(250, 220, 1)]},
  @{@"title":@"三次元", @"icon": [[UIImage imageNamed:@"home_threeD"] imageByTintColor:RGBCOLOR(203, 43, 29)]},
  @{@"title":@"游戏", @"icon": [[UIImage imageNamed:@"home_game"] imageByTintColor:RGBCOLOR(250, 175, 11)]},
  @{@"title":@"影剧", @"icon": [[UIImage imageNamed:@"home_movie"] imageByTintColor:RGBCOLOR(130, 211, 101)]},
  @{@"title":@"新番", @"icon": [[UIImage imageNamed:@"home_bangumi"] imageByTintColor:RGBCOLOR(25, 190, 157)]}];
	}
	return _resourceArr;
}

@end
