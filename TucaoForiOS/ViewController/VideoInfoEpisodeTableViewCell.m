//
//  VideoInfoEpisodeTableViewCell.m
//  TucaoForiOS
//
//  Created by JimHuang on 16/8/25.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "VideoInfoEpisodeTableViewCell.h"
#import "VideoInfoEpisodeCollectionViewCell.h"

@interface VideoInfoEpisodeTableViewCell()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) UICollectionView *collectionView;
@end

@implementation VideoInfoEpisodeTableViewCell
{
    NSArray <VideoURLModel *>*_models;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    return self;
}

- (CGFloat)cellHeightWithModels:(NSArray <VideoURLModel *>*)models {
    _models = models;
    [self.collectionView reloadData];
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    
    return self.collectionView.collectionViewLayout.collectionViewContentSize.height;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _models.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VideoInfoEpisodeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"VideoInfoEpisodeCollectionViewCell" forIndexPath:indexPath];
    cell.model = _models[indexPath.item];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.touchItemAtIndex) {
        self.touchItemAtIndex(indexPath.item);
    }
}

#pragma mark - 懒加载
- (UICollectionView *)collectionView {
	if(_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake((WIDTH - 50) / 4, 35);
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
		_collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.scrollEnabled = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = BACK_GROUND_COLOR;
        [_collectionView registerClass:[VideoInfoEpisodeCollectionViewCell class] forCellWithReuseIdentifier:@"VideoInfoEpisodeCollectionViewCell"];
        [self.contentView addSubview:_collectionView];
	}
	return _collectionView;
}

@end
