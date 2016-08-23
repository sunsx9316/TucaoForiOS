//
//  HomePageSectionTableViewCell.m
//  TucaoForiOS
//
//  Created by JimHuang on 16/8/23.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "HomePageSectionTableViewCell.h"
@interface HomePageSectionTableViewCell ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) UICollectionView *collectionView;
@end

@implementation HomePageSectionTableViewCell
{
    VideoCollectionModel *_model;
}

- (CGFloat)cellHeightWithModel:(VideoCollectionModel *)model {
    _model = model;
    
    [self.collectionView reloadData];
    
    [self.collectionView setNeedsUpdateConstraints];
    [self.collectionView updateConstraintsIfNeeded];
    
    return self.collectionView.collectionViewLayout.collectionViewContentSize.height;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (UICollectionView *)collectionView {
	if(_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        layout.itemSize = CGSizeMake((WIDTH - 30) / 2, (WIDTH - 30) / 2);
		_collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
	}
	return _collectionView;
}

@end
