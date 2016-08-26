//
//  VideoInfoContainerTableViewCell.m
//  TucaoForiOS
//
//  Created by JimHuang on 16/8/25.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "VideoInfoContainerTableViewCell.h"
#import "VideoInfoNumberTableViewCell.h"
#import "VideoInfoButtonTableViewCell.h"
#import "VideoInfoEpisodeTableViewCell.h"
#import "VideoInfoUserTableViewCell.h"

@interface VideoInfoContainerTableViewCell ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
@property (strong, nonatomic) UITableView *tableView;
@end

@implementation VideoInfoContainerTableViewCell
{
    CGFloat _episodesCellHeight;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    return self;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 || indexPath.row == 2) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if (indexPath.row == 0) {
            cell.textLabel.textColor = [UIColor blackColor];
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.numberOfLines = 1;
            cell.textLabel.text = _model.title;
        }
        else if (indexPath.row == 2) {
            cell.textLabel.textColor = [UIColor lightGrayColor];
            cell.textLabel.font = [UIFont systemFontOfSize:13];
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.text = _model.desc;
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
        return cell;
    }
    else if (indexPath.row == 4) {
        VideoInfoUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VideoInfoUserTableViewCell" forIndexPath:indexPath];
        cell.userNameLabel.text = _model.user;
        cell.timeLabel.text = _model.create;
        return cell;
    }
    else if (indexPath.row == 5) {
        VideoInfoEpisodeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VideoInfoEpisodeTableViewCell" forIndexPath:indexPath];
        _episodesCellHeight = [cell cellHeightWithModels:_model.URLs];
        return cell;
    }
    return nil;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2 || indexPath.row == 0 || indexPath.row == 4) {
        return UITableViewAutomaticDimension;
    }
    else if (indexPath.row == 1) {
        return 30;
    }
    else if (indexPath.row == 3) {
        return 80;
    }
    else if (indexPath.row == 5) {
        return _episodesCellHeight;
    }
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 4) {
        if (self.touchUserRow) {
            self.touchUserRow(_model.user, _model.userId);
        }
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.tableViewDidScroll) {
        self.tableViewDidScroll(scrollView.contentOffset.y);
    }
}


#pragma mark - 懒加载
- (UITableView *)tableView {
	if(_tableView == nil) {
		_tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 50;
        [_tableView registerClass:[VideoInfoButtonTableViewCell class] forCellReuseIdentifier:@"VideoInfoButtonTableViewCell"];
        [_tableView registerClass:[VideoInfoNumberTableViewCell class] forCellReuseIdentifier:@"VideoInfoNumberTableViewCell"];
        [_tableView registerClass:[VideoInfoEpisodeTableViewCell class] forCellReuseIdentifier:@"VideoInfoEpisodeTableViewCell"];
        [_tableView registerClass:[VideoInfoUserTableViewCell class] forCellReuseIdentifier:@"VideoInfoUserTableViewCell"];
        [self.contentView addSubview:_tableView];
	}
	return _tableView;
}

@end
