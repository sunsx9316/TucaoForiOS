//
//  VideoInfoViewController.m
//  TucaoForiOS
//
//  Created by JimHuang on 16/8/27.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "VideoInfoViewController.h"
#import "iCarousel.h"

#import <WMPageController/WMMenuView.h>
#import "VideoInfoBriefView.h"
#import "VideoInfoReplayWebView.h"

#define MENU_HEIGHT 50
#define HEAD_VIEW_HEGHT 180

@interface VideoInfoViewController ()<iCarouselDelegate, iCarouselDataSource, WMMenuViewDataSource, WMMenuViewDelegate>
@property (strong, nonatomic) UIImageView *headImgView;
@property (strong, nonatomic) UIButton *playControlButton;
@property (strong, nonatomic) WMMenuView *menuView;
@property (strong, nonatomic) NSArray *contentViewArr;
@property (strong, nonatomic) iCarousel *pageView;
@end

@implementation VideoInfoViewController
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
    
    [self.headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(HEAD_VIEW_HEGHT);
    }];
    
    [self.playControlButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(HEAD_VIEW_HEGHT - 70);
        make.right.mas_offset(-20);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    [self.view addSubview:self.pageView];
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
    [self.pageView scrollToItemAtIndex:index animated:YES];
//    [self.pageViewController setViewControllers:@[self.VCArr[index]] direction:index < currentIndex animated:YES completion:nil];
}

- (CGFloat)menuView:(WMMenuView *)menu titleSizeForState:(WMMenuItemState)state {
    return 15;
}

- (UIColor *)menuView:(WMMenuView *)menu titleColorForState:(WMMenuItemState)state {
    return state == WMMenuItemStateSelected ? MAIN_COLOR : [UIColor lightGrayColor];
}

//#pragma mark - UIPageViewControllerDataSource
//- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
//    NSInteger index = [self.VCArr indexOfObject:viewController];
//    if (index == 0) {
//        return self.VCArr.lastObject;
//    }
//    return self.VCArr[index - 1];
//}
//
//- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
//    NSInteger index = [self.VCArr indexOfObject:viewController];
//    if (index == self.VCArr.count - 1) {
//        return self.VCArr.firstObject;
//    }
//    return self.VCArr[index + 1];
//}
//
//#pragma mark - UIPageViewControllerDelegate
//- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
//        NSInteger index = [self.VCArr indexOfObject:previousViewControllers.firstObject];
//    NSLog(@"%ld", index);
////        [self.menuView selectItemAtIndex:index];
//}
#pragma mark - iCarouselDelegate
- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value {
    if (option == iCarouselOptionWrap) {
        return YES;
    }
    return value;
}

- (void)carouselDidScroll:(iCarousel *)carousel {
//    NSLog(@"%f", carousel.scrollOffset);
//    [self.menuView slideMenuAtProgress:carousel.scrollOffset];
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
}

- (void)scrollViewScroll:(NSNotification *)sender {
    float offsetY = [sender.object floatValue];
    
    if (offsetY > HEAD_VIEW_HEGHT - CGRectGetMaxY(self.navigationController.navigationBar.frame)) {
        offsetY = HEAD_VIEW_HEGHT - CGRectGetMaxY(self.navigationController.navigationBar.frame);
    }
    
    if (offsetY < 0) {
        offsetY = 0;
    }
    
    NSLog(@"%f", HEAD_VIEW_HEGHT - offsetY);

    CGRect frame = self.menuView.frame;
    frame.origin.y = HEAD_VIEW_HEGHT - offsetY;
    self.menuView.frame = frame;
    
    frame.size = self.pageView.size;
    frame.origin.y += self.menuView.height;
    self.pageView.frame = frame;
//    [self.pageView layoutIfNeeded];
}

#pragma mark - 懒加载
- (UIImageView *)headImgView {
    if(_headImgView == nil) {
        _headImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _headImgView.contentMode = UIViewContentModeScaleAspectFill;
        _headImgView.clipsToBounds = YES;
        _headImgView.userInteractionEnabled = YES;
//        [_headImgView addSubview:self.playControlButton];
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
		_menuView = [[WMMenuView alloc] initWithFrame:CGRectMake(0, HEAD_VIEW_HEGHT, self.view.width, MENU_HEIGHT)];
        _menuView.style = WMMenuViewStyleLine;
        _menuView.backgroundColor = BACK_GROUND_COLOR;
        _menuView.delegate = self;
        _menuView.dataSource = self;
        [self.view addSubview:_menuView];
	}
	return _menuView;
}

- (iCarousel *)pageView {
	if(_pageView == nil) {
		_pageView = [[iCarousel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.menuView.frame), self.view.width, self.view.height +  CGRectGetMaxY(self.navigationController.navigationBar.frame) - CGRectGetMaxY(self.menuView.frame))];
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
//        VideoInfoReplayWebView *replayWebTableView = [[VideoInfoReplayWebView alloc] initWithFrame:self.view.bounds typeId:_model.typeId videoId:_model.hid];
		_contentViewArr = @[briefTableView];
	}
	return _contentViewArr;
}

//- (UIView *)holdView {
//	if(_holdView == nil) {
//		_holdView = [[UIView alloc] initWithFrame:CGRectZero];
//        [_holdView addSubview:self.menuView];
//        [_holdView addSubview:self.pageView];
//        [self.menuView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.left.right.mas_equalTo(0);
//            make.height.mas_equalTo(MENU_HEIGHT);
//        }];
//        [self.pageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.menuView.mas_bottom);
//            make.left.right.bottom.mas_equalTo(0);
//        }];
//        [self.view addSubview:_holdView];
//	}
//	return _holdView;
//}

@end
