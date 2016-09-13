//
//  MineCenterTableViewCell.m
//  TucaoForiOS
//
//  Created by Jim_Huang on 16/9/13.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "MineCenterTableViewCell.h"
#import "MineCenterCollectionViewCell.h"

@interface MineCenterTableViewCell ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) UICollectionView *collectionView;
@end

@implementation MineCenterTableViewCell
{
    NSArray *_arr;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    return self;
}

- (CGFloat)cellHeightWithArr:(NSArray <NSDictionary *>*)arr {
    _arr = arr;
    [self.collectionView reloadData];
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
//    [self.collectionView layoutIfNeeded];
    return self.collectionView.collectionViewLayout.collectionViewContentSize.height;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _arr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = _arr[indexPath.item];
    MineCenterCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MineCenterCollectionViewCell" forIndexPath:indexPath];
    cell.iconImgView.image = [UIImage imageNamed:dic[@"img"]];
    cell.titleLabel.text = dic[@"title"];
    return cell;
}

#pragma mark - 懒加载
- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        float value = WIDTH / 4;
        layout.itemSize = CGSizeMake(value, value);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = BACK_GROUND_COLOR;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[MineCenterCollectionViewCell class] forCellWithReuseIdentifier:@"MineCenterCollectionViewCell"];
        [self.contentView addSubview:_collectionView];
    }
    return _collectionView;
}

@end
