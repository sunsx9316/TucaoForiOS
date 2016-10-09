//
//  VIdeoInfoDownloadSheetView.m
//  TucaoForiOS
//
//  Created by Jim_Huang on 16/9/30.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "VideoInfoDownloadSheetView.h"
#import "VideoInfoDownloadSheetTableViewCell.h"

#import "VideoNetManager.h"
#import "DanmakuNetManager.h"

#import "MBProgressHUD+Tools.h"
#import "NSObject+Tools.h"

@interface VideoInfoDownloadSheetView ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UIView *holdView;
@property (strong, nonatomic) UIView *bgView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton *downloadAllVideoButton;
@property (strong, nonatomic) UIButton *jumpToDownloadViewControllerButton;
@end

@implementation VideoInfoDownloadSheetView

- (instancetype)init {
    return [self initWithFrame:[UIScreen mainScreen].bounds];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.bgView];
        [self addSubview:self.holdView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateProgress:) name:@"UPDATE_PROGRESS" object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)show {
    if (self.superview == nil) {
        [[UIApplication sharedApplication].windows.firstObject addSubview:self];
    }
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:15 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.bgView.alpha = 1;
        self.holdView.bottom = self.height - 10;
    } completion:nil];
}

- (void)dismiss {
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.bgView.alpha = 0;
        self.holdView.top = self.height + 10;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];

}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.model.URLs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoInfoDownloadSheetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VideoInfoDownloadSheetTableViewCell" forIndexPath:indexPath];
    VideoURLModel *model = self.model.URLs[indexPath.row];
    [cell setWithModel:model];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    VideoURLModel *model = self.model.URLs[indexPath.row];
    if (self.touchTableViewWithModel) {
        self.touchTableViewWithModel(model);
    }
    
    if (model.status == VideoURLModelStatusDownloded) return;
    [VideoNetManager videoPlayURLWithType:model.type vid:model.vid completionHandler:^(NSArray *URLs, TucaoErrorModel *error) {
        model.playURLs = URLs;
        [self downloadVideo:self.model URLModel:model];
    }];
}

#pragma mark - 私有方法
- (void)touchJumpToDownloadViewControllerButton:(UIButton *)button {
    if (self.touchJumpToDownloadViewControllerButtonCallBack) {
        self.touchJumpToDownloadViewControllerButtonCallBack();
    }
}

- (void)touchDownloadAllVideoButton:(UIButton *)button {
    [VideoNetManager batchGETVideoPlayURLWithModels:self.model.URLs progressBlock:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations) {
        if (numberOfFinishedOperations < self.model.URLs.count) {
            [self downloadVideo:self.model URLModel:self.model.URLs[numberOfFinishedOperations]];
        }
    } completionBlock:nil];
}

- (void)updateProgress:(NSNotification *)aNotification {
    dispatch_async(dispatch_get_main_queue(), ^{
        VideoURLModel *model = aNotification.object;
        if ([self.model.URLs containsObject:model]) {
            NSInteger index = [self.model.URLs indexOfObject:model];
            VideoInfoDownloadSheetTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
            [cell setWithModel:model];
        }
    });
}

- (void)downloadVideo:(VideoModel *)model URLModel:(VideoURLModel *)URLModel {
    [URLModel addWeakAssociation:model key:@"videoModel"];
    NSURLSessionDownloadTask *task = [VideoNetManager downloadVideoWithModel:URLModel progress:^(NSProgress *downloadProgress) {
        URLModel.progress = downloadProgress.fractionCompleted;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATE_PROGRESS" object:URLModel];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, TucaoErrorModel *error) {
        if (filePath) {
            URLModel.playURLs = @[[NSURL URLWithString:filePath.lastPathComponent]];
        }
        URLModel.status = VideoURLModelStatusDownloded;
        [[UserDefaultManager shareUserDefaultManager] addDownloadVideo:URLModel];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATE_PROGRESS" object:URLModel];
    }];
    
    if (task) {
        objc_setAssociatedObject(model, "task", task, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

#pragma mark - 懒加载
- (UITableView *)tableView {
	if(_tableView == nil) {
		_tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 50;
        _tableView.tableFooterView = [[UIView alloc] init];
        [_tableView registerClass:[VideoInfoDownloadSheetTableViewCell class] forCellReuseIdentifier:@"VideoInfoDownloadSheetTableViewCell"];
	}
	return _tableView;
}

- (UIButton *)jumpToDownloadViewControllerButton {
	if(_jumpToDownloadViewControllerButton == nil) {
		_jumpToDownloadViewControllerButton = [[UIButton alloc] init];
        _jumpToDownloadViewControllerButton.backgroundColor = [UIColor whiteColor];
        [_jumpToDownloadViewControllerButton setTitle:@"管理缓存" forState:UIControlStateNormal];
        [_jumpToDownloadViewControllerButton setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
        _jumpToDownloadViewControllerButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_jumpToDownloadViewControllerButton addTarget:self action:@selector(touchJumpToDownloadViewControllerButton:) forControlEvents:UIControlEventTouchUpInside];
	}
	return _jumpToDownloadViewControllerButton;
}

- (UIButton *)downloadAllVideoButton {
	if(_downloadAllVideoButton == nil) {
		_downloadAllVideoButton = [[UIButton alloc] init];
        _downloadAllVideoButton.backgroundColor = [UIColor whiteColor];
        [_downloadAllVideoButton setTitle:@"缓存全部" forState:UIControlStateNormal];
        [_downloadAllVideoButton setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
         _downloadAllVideoButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_downloadAllVideoButton addTarget:self action:@selector(touchDownloadAllVideoButton:) forControlEvents:UIControlEventTouchUpInside];
	}
	return _downloadAllVideoButton;
}

- (UIView *)bgView {
	if(_bgView == nil) {
		_bgView = [[UIView alloc] initWithFrame:self.bounds];
        _bgView.backgroundColor = RGBACOLOR(0, 0, 0, 0.7);
        _bgView.alpha = 0;
        @weakify(self)
        [_bgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            @strongify(self)
            if (!self) return;
            [self dismiss];
        }]];
	}
	return _bgView;
}

- (UIView *)holdView {
	if(_holdView == nil) {
		_holdView = [[UIView alloc] initWithFrame:CGRectMake(10, self.height, self.width - 20, self.height * 0.5)];
        [self addSubview:_holdView];
        [_holdView addSubview:self.tableView];
        [_holdView addSubview:self.downloadAllVideoButton];
        [_holdView addSubview:self.jumpToDownloadViewControllerButton];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0);
        }];
        
        [_downloadAllVideoButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_tableView.mas_bottom);
            make.left.bottom.mas_equalTo(0);
            make.height.mas_equalTo(50);
        }];
        
        [_jumpToDownloadViewControllerButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_downloadAllVideoButton.mas_right);
            make.bottom.right.mas_equalTo(0);
            make.size.equalTo(_downloadAllVideoButton);
        }];

	}
	return _holdView;
}

@end
