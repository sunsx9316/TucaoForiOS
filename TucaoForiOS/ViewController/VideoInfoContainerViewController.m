//
//  VideoInfoViewController.m
//  TucaoForiOS
//
//  Created by JimHuang on 16/8/25.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "VideoInfoContainerViewController.h"
#import "VideoInfoBriefViewController.h"
#import "VideoInfoReplayWebViewController.h"

//#import "UserInfoWebViewController.h"

//#import "VideoInfoContainerTableViewCell.h"
//#import "VideoInfoNumberTableViewCell.h"
//#import "VideoInfoButtonTableViewCell.h"
//#import "VideoInfoEpisodeTableViewCell.h"
//#import "VideoInfoUserTableViewCell.h"

@interface VideoInfoContainerViewController ()<WMPageControllerDataSource>
//@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIImageView *headImgView;
@property (strong, nonatomic) UIButton *playControlButton;
@property (strong, nonatomic) NSArray *VCArr;

@end

@implementation VideoInfoContainerViewController
//{
//    CGFloat _cellHeight;
//    CGFloat _episodesCellHeight;
//    UIImage *_originalImage;
//}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    SET_NAVIGATION_BAR_CLEAR
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = [@"h" stringByAppendingString:_model.hid];
//    [self.headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.mas_equalTo(0);
//        make.height.mas_equalTo(180);
//    }];
//    
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.headImgView.mas_bottom);
//    }];
}

#pragma mark - WMPageControllerDataSource
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.VCArr.count;
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    return self.VCArr[index];
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return index == 0 ? @"简介" : @"评论";
}

//#pragma mark - UITableViewDataSource
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 6;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row == 0 || indexPath.row == 2) {
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
//        if (cell == nil) {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        }
//        
//        if (indexPath.row == 0) {
//            cell.textLabel.textColor = [UIColor blackColor];
//            cell.textLabel.font = [UIFont systemFontOfSize:14];
//            cell.textLabel.numberOfLines = 1;
//            cell.textLabel.text = _model.title;
//        }
//        else if (indexPath.row == 2) {
//            cell.textLabel.textColor = [UIColor lightGrayColor];
//            cell.textLabel.font = [UIFont systemFontOfSize:13];
//            cell.textLabel.numberOfLines = 0;
//            cell.textLabel.text = _model.desc;
//        }
//        return cell;
//    }
//    else if (indexPath.row == 1) {
//        VideoInfoNumberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VideoInfoNumberTableViewCell" forIndexPath:indexPath];
//        cell.playCountLabel.text = _model.play;
//        cell.danmakuCountLabel.text = _model.mukio;
//        return cell;
//    }
//    else if (indexPath.row == 3) {
//        VideoInfoButtonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VideoInfoButtonTableViewCell" forIndexPath:indexPath];
//        return cell;
//    }
//    else if (indexPath.row == 4) {
//        VideoInfoUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VideoInfoUserTableViewCell" forIndexPath:indexPath];
//        cell.userNameLabel.text = _model.user;
//        cell.timeLabel.text = _model.create;
//        return cell;
//    }
//    else if (indexPath.row == 5) {
//        VideoInfoEpisodeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VideoInfoEpisodeTableViewCell" forIndexPath:indexPath];
//        _episodesCellHeight = [cell cellHeightWithModels:_model.URLs];
//        return cell;
//    }
//    return nil;
//}
//
//#pragma mark - UITableViewDelegate
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row == 2 || indexPath.row == 0 || indexPath.row == 4) {
//        return UITableViewAutomaticDimension;
//    }
//    else if (indexPath.row == 1) {
//        return 30;
//    }
//    else if (indexPath.row == 3) {
//        return 80;
//    }
//    else if (indexPath.row == 5) {
//        return _episodesCellHeight;
//    }
//    return 0.1;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (indexPath.row == 4) {
//        UserInfoWebViewController *vc = [[UserInfoWebViewController alloc] init];
//        vc.userId = _model.user;
//        vc.title = _model.userId;
//        [self.navigationController pushViewController:vc animated:YES];
//    }
//}
//
#pragma mark - 私有方法
- (void)touchPlayButton:(UIButton *)sender {
    sender.selected = !sender.isSelected;
}
//
//
//#pragma mark - 懒加载
//- (UITableView *)tableView {
//    if(_tableView == nil) {
//        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
//        _tableView.delegate = self;
//        _tableView.dataSource = self;
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.estimatedRowHeight = 50;
//        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:self.headImgView.bounds];
//        _tableView.tableHeaderView.userInteractionEnabled = NO;
//        _tableView.tableFooterView = [[UIView alloc] init];
//        _tableView.backgroundColor = [UIColor clearColor];
//        [_tableView registerClass:[VideoInfoButtonTableViewCell class] forCellReuseIdentifier:@"VideoInfoButtonTableViewCell"];
//        [_tableView registerClass:[VideoInfoNumberTableViewCell class] forCellReuseIdentifier:@"VideoInfoNumberTableViewCell"];
//        [_tableView registerClass:[VideoInfoEpisodeTableViewCell class] forCellReuseIdentifier:@"VideoInfoEpisodeTableViewCell"];
//        [_tableView registerClass:[VideoInfoUserTableViewCell class] forCellReuseIdentifier:@"VideoInfoUserTableViewCell"];
//        [self.view addSubview:_tableView];
//    }
//    return _tableView;
//}

- (UIImageView *)headImgView {
    if(_headImgView == nil) {
        _headImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _headImgView.contentMode = UIViewContentModeScaleAspectFill;
        _headImgView.clipsToBounds = YES;
        _headImgView.userInteractionEnabled = YES;
        [_headImgView addSubview:self.playControlButton];
        [self.view addSubview:_headImgView];
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
	}
	return _playControlButton;
}

- (NSArray *)VCArr {
	if(_VCArr == nil) {
        VideoInfoBriefViewController *briefVC = [[VideoInfoBriefViewController alloc] init];
        briefVC.model = _model;
        
        VideoInfoReplayWebViewController *replayVC = [[VideoInfoReplayWebViewController alloc] init];
        replayVC.typeId = _model.typeId;
        replayVC.videoId = _model.hid;
		_VCArr = @[briefVC, replayVC];
	}
	return _VCArr;
}

@end
