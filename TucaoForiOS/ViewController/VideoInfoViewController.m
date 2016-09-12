//
//  VideoInfoViewController.m
//  TucaoForiOS
//
//  Created by JimHuang on 16/8/27.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "VideoInfoViewController.h"
#import "UserInfoWebViewController.h"
#import "iCarousel.h"
#import "PlayerView.h"

#import <WMPageController/WMMenuView.h>
#import "VideoInfoBriefView.h"
#import "VideoInfoReplayWebView.h"

#define MENU_HEIGHT 50
#define HEAD_VIEW_HEGHT 180
#define TRANSFORM_TIME 0.3

@interface VideoInfoViewController ()<iCarouselDelegate, iCarouselDataSource, WMMenuViewDataSource, WMMenuViewDelegate>
@property (strong, nonatomic) YYAnimatedImageView *headImgView;
@property (strong, nonatomic) UIButton *playControlButton;
@property (strong, nonatomic) WMMenuView *menuView;
@property (strong, nonatomic) NSArray *contentViewArr;
@property (strong, nonatomic) iCarousel *pageView;
@property (strong, nonatomic) UIView *holdView;
@property (strong, nonatomic) PlayerView *playerView;
@end

@implementation VideoInfoViewController
{
    BOOL _isFullScreen;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    SET_NAVIGATION_BAR_CLEAR
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollViewScroll:) name:@"SCROLL_VIEW_DID_SCROLL" object:nil];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    if (_model.hid.length) {
        self.title = [@"h" stringByAppendingString:_model.hid];
    }
    
    [self.headImgView yy_setImageWithURL:_model.thumb options:YYWEBIMAGE_DEFAULT_OPTION];
    self.headImgView.frame = CGRectMake(0, 0, WIDTH, HEAD_VIEW_HEGHT);
    
    [self.playControlButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(HEAD_VIEW_HEGHT - 70);
        make.right.mas_offset(-20);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    [self.view addSubview:self.holdView];
    [self.view addSubview:self.playerView];
    
}

- (BOOL)prefersStatusBarHidden {
    return _isFullScreen;
}


#pragma mark - WMMenuViewDataSource
- (NSInteger)numbersOfTitlesInMenuView:(WMMenuView *)menu {
    return self.contentViewArr.count;
}

- (NSString *)menuView:(WMMenuView *)menu titleAtIndex:(NSInteger)index {
    return index == 0 ? @"简介" : @"评论";
}

#pragma mark - WMMenuViewDelegate
- (void)menuView:(WMMenuView *)menu didSelesctedIndex:(NSInteger)index currentIndex:(NSInteger)currentIndex {
    objc_setAssociatedObject(self.pageView, @"_isAnimate".UTF8String, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self.pageView scrollToItemAtIndex:index animated:YES];
}

- (CGFloat)menuView:(WMMenuView *)menu titleSizeForState:(WMMenuItemState)state {
    return 15;
}

- (UIColor *)menuView:(WMMenuView *)menu titleColorForState:(WMMenuItemState)state {
    return state == WMMenuItemStateSelected ? MAIN_COLOR : [UIColor lightGrayColor];
}

#pragma mark - iCarouselDelegate

- (void)carouselDidScroll:(iCarousel *)carousel {
    if ([objc_getAssociatedObject(self.pageView, @"_isAnimate".UTF8String) boolValue] == YES) return;
    [self.menuView slideMenuAtProgress:carousel.scrollOffset];
}

- (void)carouselWillBeginDragging:(iCarousel *)carousel {
    objc_setAssociatedObject(self.pageView, @"_isAnimate".UTF8String, @(NO), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value {
    if (option == iCarouselOptionWrap) {
        return YES;
    }
    return value;
}

#pragma mark - iCarouselDataSource
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return self.contentViewArr.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(nullable UIView *)view {
    if (view == nil) {
        view = self.contentViewArr[index];
    }
    view.frame = carousel.bounds;
    return view;
}

#pragma mark - 私有方法
- (void)touchPlayButton:(UIButton *)sender {
    sender.selected = !sender.isSelected;
//    self.playerView.hidden = NO;
    _isFullScreen = YES;
    [self setNeedsStatusBarAppearanceUpdate];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [UIView animateWithDuration:TRANSFORM_TIME animations:^{
        self.playerView.transform = CGAffineTransformMakeRotation(M_PI / 2);
        self.playerView.frame = self.view.bounds;
        self.playerView.alpha = 1;
    }];
}

- (void)scrollViewScroll:(NSNotification *)sender {
    float offsetY = [sender.object floatValue];
    
    if (offsetY > HEAD_VIEW_HEGHT - CGRectGetMaxY(self.navigationController.navigationBar.frame)) {
        offsetY = HEAD_VIEW_HEGHT - CGRectGetMaxY(self.navigationController.navigationBar.frame);
    }
    
    if (offsetY < 0) {
        offsetY = 0;
    }
    
    CGRect frame = self.holdView.frame;
    frame.origin.y = HEAD_VIEW_HEGHT - offsetY;
    self.holdView.frame = frame;
}

#pragma mark - 懒加载
- (YYAnimatedImageView *)headImgView {
    if(_headImgView == nil) {
        _headImgView = [[YYAnimatedImageView alloc] initWithFrame:CGRectZero];
        _headImgView.contentMode = UIViewContentModeScaleAspectFill;
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        [_headImgView addSubview:effectView];
        [effectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        _headImgView.clipsToBounds = YES;
        _headImgView.userInteractionEnabled = YES;
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
        [self.view addSubview:_playControlButton];
    }
    return _playControlButton;
}

- (WMMenuView *)menuView {
    if(_menuView == nil) {
        _menuView = [[WMMenuView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, MENU_HEIGHT)];
        _menuView.style = WMMenuViewStyleDefault;
        _menuView.backgroundColor = [UIColor whiteColor];
        _menuView.delegate = self;
        _menuView.dataSource = self;
    }
    return _menuView;
}

- (iCarousel *)pageView {
    if(_pageView == nil) {
        _pageView = [[iCarousel alloc] initWithFrame:CGRectMake(0, self.menuView.height, self.view.width, self.view.height - self.menuView.height - CGRectGetMaxY(self.navigationController.navigationBar.frame))];
        _pageView.type = iCarouselTypeLinear;
        _pageView.delegate = self;
        _pageView.dataSource = self;
        _pageView.pagingEnabled = YES;
        _pageView.decelerationRate = 0;
        _pageView.clipsToBounds = YES;
    }
    return _pageView;
}

- (NSArray *)contentViewArr {
    if(_contentViewArr == nil) {
        VideoInfoBriefView *briefTableView = [[VideoInfoBriefView alloc] initWithFrame:self.view.bounds model:_model];
        @weakify(self)
        [briefTableView setTouchUserRowCallBack:^(NSString *userName, NSString *userId) {
            @strongify(self)
            if (!self) return;
            
            UserInfoWebViewController *vc = [[UserInfoWebViewController alloc] init];
            vc.userId = userId;
            [self.navigationController pushViewController:vc animated:YES];
        }];
        briefTableView.topHeight = HEAD_VIEW_HEGHT + MENU_HEIGHT;
        
        VideoInfoReplayWebView *replayWebTableView = [[VideoInfoReplayWebView alloc] initWithFrame:self.view.bounds typeId:_model.typeId videoId:_model.hid];
        _contentViewArr = @[briefTableView, replayWebTableView];
    }
    return _contentViewArr;
}

- (UIView *)holdView {
    if(_holdView == nil) {
        _holdView = [[UIView alloc] initWithFrame:CGRectZero];
        [_holdView addSubview:self.menuView];
        [_holdView addSubview:self.pageView];
        _holdView.frame = CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame), self.view.width, self.pageView.height + self.menuView.height);
    }
    return _holdView;
}

- (PlayerView *)playerView {
    if(_playerView == nil) {
        _playerView = [[PlayerView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, HEAD_VIEW_HEGHT)];
        @weakify(self)
        [_playerView setTouchFullScreenCallBack:^{
            @strongify(self)
            if (!self) return;
            self->_isFullScreen = NO;
            [self setNeedsStatusBarAppearanceUpdate];
            [self.navigationController setNavigationBarHidden:NO animated:YES];
            [UIView animateWithDuration:TRANSFORM_TIME animations:^{
                self.playerView.transform = CGAffineTransformIdentity;
                self.playerView.frame = CGRectMake(0, 0, self.view.width, HEAD_VIEW_HEGHT);
                self.playerView.alpha = 0;
            }];
            
        }];
        _playerView.alpha = 0;
        
    }
    return _playerView;
}

@end
