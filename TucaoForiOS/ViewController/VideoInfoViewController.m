//
//  VideoInfoViewController.m
//  TucaoForiOS
//
//  Created by JimHuang on 16/8/27.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "VideoInfoViewController.h"
#import "UserInfoWebViewController.h"
#import "DownloadViewController.h"

#import "PlayerView.h"
#import "VideoInfoBriefView.h"
#import "VideoInfoTextTableViewCell.h"
#import "VideoInfoNumberTableViewCell.h"
#import "VideoInfoButtonTableViewCell.h"
#import "VideoInfoUserTableViewCell.h"
#import "VideoInfoEpisodeTableViewCell.h"
#import "HeadHitDisableTableView.h"
#import "VideoInfoDownloadSheetView.h"

#import "MBProgressHUD+Tools.h"
#import "UIImage+ImageEffects.h"
#import <UITableView+FDTemplateLayoutCell.h>
#import <UINavigationController+FDFullscreenPopGesture.h>

#import "VideoNetManager.h"
#import "DanmakuNetManager.h"

#define HEAD_VIEW_HEGHT 180
#define TRANSFORM_TIME 0.3
#define HEAD_IMG_VIEW_MIN_ALPHA 0.6

@interface VideoInfoViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) HeadHitDisableTableView *tableView;
@property (strong, nonatomic) YYAnimatedImageView *headImgView;
@property (strong, nonatomic) UIButton *playControlButton;
@property (strong, nonatomic) PlayerView *playerView;
@property (strong, nonatomic) UIView *headBGView;
@property (strong, nonatomic) VideoInfoDownloadSheetView *videosView;
@end

@implementation VideoInfoViewController
{
    BOOL _isFullScreen;
    CGFloat _episodesCellHeight;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    SET_NAVIGATION_BAR_CLEAR
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.videosView dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    NSMutableArray *URLs = [NSMutableArray arrayWithArray:self.model.URLs];
    NSArray *downloadURLs = [UserDefaultManager shareUserDefaultManager].downloadVieos;
    for (NSInteger i = 0; i < URLs.count; ++i) {
        VideoURLModel *model = URLs[i];
        if ([downloadURLs containsObject:model]) {
            NSInteger index = [downloadURLs indexOfObject:model];
            URLs[i] = downloadURLs[index];
        }
    }
    
    self.model.URLs = URLs;
    
    if (_model.hid.length) {
        self.title = [@"h" stringByAppendingString:_model.hid];
    }
    
    [self.headImgView yy_setImageWithURL:_model.thumb placeholder:nil options:YYWEBIMAGE_DEFAULT_OPTION completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        
        YYAnimatedImageView *view = (YYAnimatedImageView *)[self.headImgView viewWithTag:100];
        view.image = [[image yy_imageByResizeToSize:self.headImgView.size contentMode:UIViewContentModeScaleAspectFill] applyBlurWithRadius:5 tintColor:RGBACOLOR(0, 0, 0, 0.6) saturationDeltaFactor:1.0 maskImage:nil];
    }];
    
    [self.view addSubview:self.headImgView];
    
    [self.playControlButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(HEAD_VIEW_HEGHT - 70);
        make.right.mas_offset(-20);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    [self.view addSubview:self.playerView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self.view addSubview:self.headBGView];
}

- (BOOL)prefersStatusBarHidden {
    return _isFullScreen;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 || indexPath.row == 2) {
        VideoInfoTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VideoInfoTextTableViewCell" forIndexPath:indexPath];
        
        if (indexPath.row == 0) {
            cell.titleLabel.textColor = [UIColor blackColor];
            cell.titleLabel.font = [UIFont systemFontOfSize:14];
            cell.titleLabel.text = _model.title;
        }
        else if (indexPath.row == 2) {
            cell.titleLabel.textColor = [UIColor lightGrayColor];
            cell.titleLabel.font = [UIFont systemFontOfSize:13];
            cell.titleLabel.text = _model.desc;
        }
        return cell;
    }
    else if (indexPath.row == 1) {
        VideoInfoNumberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VideoInfoNumberTableViewCell" forIndexPath:indexPath];
        cell.playCountLabel.text = _model.play;
        cell.danmakuCountLabel.text = _model.mukio;
        return cell;
    }
    else if (indexPath.row == 3) {
        VideoInfoButtonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VideoInfoButtonTableViewCell" forIndexPath:indexPath];
        @weakify(self)
        [cell setTouchDownloadButtonCallBack:^{
            @strongify(self)
            if (!self) return;
            [self.videosView show];
        }];
        
        [cell setTouchFavouriteButtonCallBack:^{
            @strongify(self)
            if (!self) return;
            
            if ([[UserDefaultManager shareUserDefaultManager].mineCollectionVideos containsObject:self->_model]) {
                [MBProgressHUD showOnlyText:@"你已经收藏过了!"];
            }
            else {
                [[UserDefaultManager shareUserDefaultManager] addMineCollectionVideo:self->_model];
                [MBProgressHUD showOnlyText:@"收藏成功!"];
            }
        }];
        return cell;
    }
    else if (indexPath.row == 4) {
        VideoInfoUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VideoInfoUserTableViewCell" forIndexPath:indexPath];
        cell.timeLabel.text = _model.create;
        cell.userNameLabel.text = _model.user;
        return cell;
    }
    else if (indexPath.row == 5) {
        VideoInfoEpisodeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VideoInfoEpisodeTableViewCell" forIndexPath:indexPath];
        _episodesCellHeight = [cell cellHeightWithModels:_model.URLs];
        return cell;
    }
    return nil;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    float percent = scrollView.contentOffset.y / HEAD_VIEW_HEGHT;
    if (percent < 0) percent = 0;
    if (percent > 1) percent = 1;
    
    self.headBGView.alpha = percent;
    [self.headImgView viewWithTag:100].alpha = percent + HEAD_IMG_VIEW_MIN_ALPHA;
    self.headImgView.top = -percent * 50;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 || indexPath.row == 2) {
        return [tableView fd_heightForCellWithIdentifier:@"VideoInfoTextTableViewCell" cacheByIndexPath:indexPath configuration:^(VideoInfoTextTableViewCell *cell) {
            if (indexPath.row == 0) {
                cell.titleLabel.font = [UIFont systemFontOfSize:14];
                cell.titleLabel.text = _model.title;
            }
            else if (indexPath.row == 2) {
                cell.titleLabel.font = [UIFont systemFontOfSize:13];
                cell.titleLabel.text = _model.desc;
            }
        }];
    }
    else if (indexPath.row == 1) {
        return 30;
    }
    else if (indexPath.row == 3) {
        return 80;
    }
    else if (indexPath.row == 4) {
        return [tableView fd_heightForCellWithIdentifier:@"VideoInfoUserTableViewCell" cacheByIndexPath:indexPath configuration:^(VideoInfoUserTableViewCell *cell) {
            cell.timeLabel.text = _model.create;
            cell.userNameLabel.text = _model.user;
        }];
    }
    else if (indexPath.row == 5) {
        return _episodesCellHeight;
    }
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 4) {
        UserInfoWebViewController *vc = [[UserInfoWebViewController alloc] init];
        vc.userId = _model.userId;
        vc.user = _model.user;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - 私有方法
- (void)touchPlayButton:(UIButton *)sender {
    self.playerView.videoModel = _model;
    [UIView animateWithDuration:TRANSFORM_TIME animations:^{
        self.playerView.alpha = 1;
    }];
}

#pragma mark - 懒加载

- (HeadHitDisableTableView *)tableView {
    if(_tableView == nil) {
        _tableView = [[HeadHitDisableTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[VideoInfoTextTableViewCell class] forCellReuseIdentifier:@"VideoInfoTextTableViewCell"];
        [_tableView registerClass:[VideoInfoButtonTableViewCell class] forCellReuseIdentifier:@"VideoInfoButtonTableViewCell"];
        [_tableView registerClass:[VideoInfoNumberTableViewCell class] forCellReuseIdentifier:@"VideoInfoNumberTableViewCell"];
        [_tableView registerClass:[VideoInfoEpisodeTableViewCell class] forCellReuseIdentifier:@"VideoInfoEpisodeTableViewCell"];
        [_tableView registerClass:[VideoInfoUserTableViewCell class] forCellReuseIdentifier:@"VideoInfoUserTableViewCell"];
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEAD_VIEW_HEGHT)];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (YYAnimatedImageView *)headImgView {
    if(_headImgView == nil) {
        _headImgView = [[YYAnimatedImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEAD_VIEW_HEGHT)];
        _headImgView.contentMode = UIViewContentModeScaleAspectFill;
        YYAnimatedImageView *blurImageView = [[YYAnimatedImageView alloc] initWithFrame:CGRectZero];
        blurImageView.tag = 100;
        blurImageView.alpha = HEAD_IMG_VIEW_MIN_ALPHA;
        [_headImgView addSubview:blurImageView];
        [blurImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        _headImgView.clipsToBounds = YES;
        _headImgView.userInteractionEnabled = YES;
        
    }
    return _headImgView;
}

- (UIButton *)playControlButton {
    if(_playControlButton == nil) {
        _playControlButton = [[UIButton alloc] initWithFrame:CGRectZero];
        _playControlButton.alpha = 0.7;
        [_playControlButton setImage:[UIImage imageNamed:@"player_play"] forState:UIControlStateSelected];
        [_playControlButton setImage:[UIImage imageNamed:@"player_pause"] forState:UIControlStateNormal];
        [_playControlButton addTarget:self action:@selector(touchPlayButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_playControlButton];
    }
    return _playControlButton;
}

- (PlayerView *)playerView {
    if(_playerView == nil) {
        _playerView = [[PlayerView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, HEAD_VIEW_HEGHT)];
        @weakify(self)
        [_playerView setTouchFullScreenCallBack:^(BOOL isFullScreen){
            @strongify(self)
            if (!self) return;
            
            self->_isFullScreen = isFullScreen;
            [self setNeedsStatusBarAppearanceUpdate];
            [self.navigationController setNavigationBarHidden:isFullScreen animated:YES];
            self.fd_interactivePopDisabled = isFullScreen;
            if (isFullScreen) {
                [self.view bringSubviewToFront:self.playerView];
                [UIView animateWithDuration:TRANSFORM_TIME animations:^{
                    self.playerView.transform = CGAffineTransformMakeRotation(M_PI / 2);
                    self.playerView.frame = self.view.bounds;
                }];
            }
            else {
                [UIView animateWithDuration:TRANSFORM_TIME animations:^{
                    self.playerView.transform = CGAffineTransformIdentity;
                    self.playerView.frame = CGRectMake(0, 0, self.view.width, HEAD_VIEW_HEGHT);
                } completion:^(BOOL finished) {
                    [self.view insertSubview:self.playerView belowSubview:self.tableView];
                }];
            }
        }];
        _playerView.alpha = 0;
    }
    return _playerView;
}

- (UIView *)headBGView {
	if(_headBGView == nil) {
		_headBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, CGRectGetMaxY(self.navigationController.navigationBar.frame))];
        _headBGView.backgroundColor = MAIN_COLOR;
        _headBGView.alpha = 0;
	}
	return _headBGView;
}

- (VideoInfoDownloadSheetView *)videosView {
	if(_videosView == nil) {
		_videosView = [[VideoInfoDownloadSheetView alloc] init];
        _videosView.model = _model;
        @weakify(self)
        [_videosView setTouchJumpToDownloadViewControllerButtonCallBack:^{
            @strongify(self)
            if (!self) return;
            DownloadViewController *vc = [[DownloadViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }];
        
        [_videosView setTouchTableViewWithModel:^(VideoURLModel *model) {
            @strongify(self)
            if (!self) return;
            
            if (model.status == VideoURLModelStatusDownloded) {
                NSURL *url = self.model.URLs.firstObject.playURLs.firstObject;
                url = [NSURL fileURLWithPath:[[UserDefaultManager shareUserDefaultManager].downloadPath stringByAppendingPathComponent:url.path]];
                self.model.URLs.firstObject.playURLs = @[url];
                [self touchPlayButton:nil];
                [self.videosView dismiss];
            }
        }];
	}
	return _videosView;
}

@end
