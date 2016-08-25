//
//  HomePageSectionTableViewCell.m
//  TucaoForiOS
//
//  Created by JimHuang on 16/8/23.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "HomePageSectionTableViewCell.h"
#import "HomePageSectionCollectionViewCell.h"

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

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = BACK_GROUND_COLOR;
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    return self;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HomePageSectionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomePageSectionCollectionViewCell" forIndexPath:indexPath];
    cell.model = _model.videos[indexPath.item];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.touchItemAtIndex) {
        self.touchItemAtIndex(_model.videos[indexPath.item]);
    }
}

#pragma mark - 懒加载
- (UICollectionView *)collectionView {
	if(_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        layout.itemSize = CGSizeMake((WIDTH - 30) / 2, (WIDTH - 30) / 2);
		_collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.scrollEnabled = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = BACK_GROUND_COLOR;
        [_collectionView registerClass:[HomePageSectionCollectionViewCell class] forCellWithReuseIdentifier:@"HomePageSectionCollectionViewCell"];
        [self.contentView addSubview:_collectionView];
	}
	return _collectionView;
}

@end
