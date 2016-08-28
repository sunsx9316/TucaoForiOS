//
//  VideoInfoContentTableViewCell.m
//  TucaoForiOS
//
//  Created by JimHuang on 16/8/28.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "VideoInfoContentTableViewCell.h"
#import <iCarousel/iCarousel.h>
#import "VideoInfoBriefView.h"
#import "VideoInfoReplayWebView.h"

@interface VideoInfoContentTableViewCell ()<iCarouselDelegate, iCarouselDataSource>
@property (strong, nonatomic) iCarousel *pageView;
@property (strong, nonatomic) NSArray *contentViewArr;
@end

@implementation VideoInfoContentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.pageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    return self;
}

- (void)setModel:(VideoModel *)model {
    _model = model;
    self.contentViewArr = nil;
    [self.pageView reloadData];
}

#pragma mark - iCarouselDelegate
- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value {
    if (option == iCarouselOptionWrap) {
        return YES;
    }
    return value;
}

- (void)carouselDidScroll:(iCarousel *)carousel {
    if (self.carouselDidScrollWithPrgress) {
        self.carouselDidScrollWithPrgress(carousel.scrollOffset);
    }
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

#pragma mark - 懒加载
- (iCarousel *)pageView {
    if(_pageView == nil) {
        _pageView = [[iCarousel alloc] initWithFrame:self.contentView.bounds];
        _pageView.backgroundColor = BACK_GROUND_COLOR;
        _pageView.type = iCarouselTypeLinear;
        _pageView.delegate = self;
        _pageView.dataSource = self;
        _pageView.pagingEnabled = YES;
        _pageView.decelerationRate = 0;
        _pageView.clipsToBounds = YES;
        [self.contentView addSubview:_pageView];
        //        [self.view addSubview:_pageView];
    }
    return _pageView;
}

- (NSArray *)contentViewArr {
    if(_contentViewArr == nil) {
        VideoInfoBriefView *briefTableView = [[VideoInfoBriefView alloc] initWithFrame:self.bounds model:_model];
        VideoInfoReplayWebView *replayWebTableView = [[VideoInfoReplayWebView alloc] initWithFrame:self.bounds typeId:_model.typeId videoId:_model.hid];
        _contentViewArr = @[briefTableView, replayWebTableView];
    }
    return _contentViewArr;
}


@end
