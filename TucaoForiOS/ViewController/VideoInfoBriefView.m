//
//  VideoInfoBriefView.m
//  TucaoForiOS
//
//  Created by JimHuang on 16/8/28.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "VideoInfoBriefView.h"
#import "VideoInfoNumberTableViewCell.h"
#import "VideoInfoButtonTableViewCell.h"
#import "VideoInfoEpisodeTableViewCell.h"
#import "VideoInfoUserTableViewCell.h"
#import "VideoInfoTextTableViewCell.h"

#import <UITableView+FDTemplateLayoutCell.h>
#import "MBProgressHUD+Tools.h"

@interface VideoInfoBriefView()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@end

@implementation VideoInfoBriefView
{
    CGFloat _episodesCellHeight;
    VideoModel *_model;
}

- (instancetype)initWithFrame:(CGRect)frame model:(VideoModel *)model {
    if (self = [super initWithFrame:frame]) {
        _model = model;
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.tableView.contentSize.height < _topHeight) {
        float height = _topHeight - self.tableView.contentSize.height;
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, height)];
    }
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
            
        }];
        
        [cell setTouchFavouriteButtonCallBack:^{
            @strongify(self)
            if (!self || !_model) return;
            if ([[ToolsManager shareToolsManager].mineCollectionVideos containsObject:_model]) {
                [MBProgressHUD showOnlyText:@"你已经收藏过了!"]; 
            }
            else {
                [[ToolsManager shareToolsManager] addMineCollectionVideo:_model];
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SCROLL_VIEW_DID_SCROLL" object:@(scrollView.contentOffset.y)];
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
        if (self.touchUserRowCallBack) {
            self.touchUserRowCallBack(_model.user, _model.userId);
        }
    }
}

#pragma mark - 懒加载
- (UITableView *)tableView {
    if(_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = BACK_GROUND_COLOR;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[VideoInfoTextTableViewCell class] forCellReuseIdentifier:@"VideoInfoTextTableViewCell"];
        [_tableView registerClass:[VideoInfoButtonTableViewCell class] forCellReuseIdentifier:@"VideoInfoButtonTableViewCell"];
        [_tableView registerClass:[VideoInfoNumberTableViewCell class] forCellReuseIdentifier:@"VideoInfoNumberTableViewCell"];
        [_tableView registerClass:[VideoInfoEpisodeTableViewCell class] forCellReuseIdentifier:@"VideoInfoEpisodeTableViewCell"];
        [_tableView registerClass:[VideoInfoUserTableViewCell class] forCellReuseIdentifier:@"VideoInfoUserTableViewCell"];
        
        [self addSubview:_tableView];
    }
    return _tableView;
}

@end
