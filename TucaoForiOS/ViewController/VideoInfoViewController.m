//
//  VideoInfoViewController.m
//  TucaoForiOS
//
//  Created by JimHuang on 16/8/25.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "VideoInfoViewController.h"
#import "UserInfoWebViewController.h"

#import "VideoInfoContainerTableViewCell.h"
#import <GPUImage.h>

@interface VideoInfoViewController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIImageView *headImgView;
@property (strong, nonatomic) NSMutableArray *blurImgArr;
@end

@implementation VideoInfoViewController
{
    CGFloat _cellHeight;
    UIImage *_originalImage;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    SET_NAVIGATION_BAR_CLEAR
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = [@"h" stringByAppendingString:_model.hid];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoInfoContainerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VideoInfoContainerTableViewCell" forIndexPath:indexPath];
    _cellHeight = [cell cellHeightWithModel:self.model];
    __weak typeof(self)weakSelf = self;
    float maxCount = self.headImgView.height / 10 - 1;
    //在更改 cell 的偏移值的同时 更改外部 tableView 的偏移值
    [cell setTableViewDidScroll:^(CGFloat contentOffsetY) {
        if (contentOffsetY > 0) {
            CGPoint p = CGPointMake(0, contentOffsetY);
            weakSelf.tableView.contentOffset = p;
            
            contentOffsetY = contentOffsetY / 10 - 1;
            
            if (contentOffsetY > maxCount) {
                contentOffsetY = maxCount;
            }
            if (contentOffsetY < 0) {
                contentOffsetY = 0;
            }
            
            UIImage *img = weakSelf.blurImgArr[(NSInteger)contentOffsetY];
            if ([img isKindOfClass:[UIImage class]]) {
                weakSelf.headImgView.image = img;
            }
        }
    }];
    
    [cell setTouchUserRow:^(NSString *userName, NSString *userId) {
        UserInfoWebViewController *vc = [[UserInfoWebViewController alloc] init];
        vc.userId = userId;
        vc.title = userName;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _cellHeight;
}

#pragma mark - 私有方法
/**
 *  模糊图片
 *
 *  @param blurRadiusInPixels 模糊半径
 *
 *  @return 图片
 */
- (UIImage *)blurImageWithBlurRadiusInPixels:(CGFloat)blurRadiusInPixels {
    GPUImageiOSBlurFilter *stillImageFilter = [[GPUImageiOSBlurFilter alloc] init];
    stillImageFilter.blurRadiusInPixels = blurRadiusInPixels;
    return [stillImageFilter imageByFilteringImage:_originalImage];
}

#pragma mark - 懒加载
- (UITableView *)tableView {
    if(_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = self.headImgView;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.bounces = NO;
        _tableView.scrollEnabled = NO;
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[VideoInfoContainerTableViewCell class] forCellReuseIdentifier:@"VideoInfoContainerTableViewCell"];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (UIImageView *)headImgView {
    if(_headImgView == nil) {
        _headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 180)];
        _headImgView.contentMode = UIViewContentModeScaleAspectFill;
        _headImgView.clipsToBounds = YES;
        _headImgView.hidden = YES;
        @weakify(self)
        [_headImgView yy_setImageWithURL:self.model.thumb placeholder:nil options:YYWEBIMAGE_DEFAULT_OPTION completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
            @strongify(self)
            if (!self) return;
            
            self->_originalImage = image;
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                for (NSInteger i = 0; i < self.blurImgArr.count; ++i) {
                    self.blurImgArr[i] = [self blurImageWithBlurRadiusInPixels:i + 3];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.headImgView.image = self.blurImgArr.firstObject;
                    self.headImgView.hidden = NO;
                });
            });
        }];
    }
    return _headImgView;
}

- (NSMutableArray *)blurImgArr {
    if(_blurImgArr == nil) {
        _blurImgArr = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < self.headImgView.height; i+=10) {
            [_blurImgArr addObject:[NSNull null]];
        }
    }
    return _blurImgArr;
}

@end
