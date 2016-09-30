//
//  VideoInfoDownloadSheetTableViewCell.m
//  TucaoForiOS
//
//  Created by Jim_Huang on 16/9/30.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "VideoInfoDownloadSheetTableViewCell.h"

@interface VideoInfoDownloadSheetTableViewCell ()
@property (strong, nonatomic) UIImageView *downloadCompleteImageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIProgressView *progressView;
@end

@implementation VideoInfoDownloadSheetTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.mas_offset(10);
//            make.width.priorityLow();
            make.right.equalTo(self.downloadCompleteImageView.mas_left).mas_offset(-10);
        }];
        
        [self.downloadCompleteImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.titleLabel.mas_right);
            make.centerY.mas_equalTo(0);
            make.right.mas_offset(-10);
            make.size.mas_equalTo(CGSizeMake(20, 20));
//            make.width.priorityHigh();
        }];
        
        [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
        }];
    }
    return self;
}

- (void)setWithModel:(VideoURLModel *)model {
    self.titleLabel.text = model.title;
    self.downloadCompleteImageView.hidden = model.status != VideoURLModelStatusDownloded;
    self.progressView.hidden = model.status != VideoURLModelStatusDownloding;
    self.progressView.progress = model.progress;
}

#pragma mark - 懒加载
- (UIImageView *)downloadCompleteImageView {
    if(_downloadCompleteImageView == nil) {
        _downloadCompleteImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"download_complete"] imageByTintColor:MAIN_COLOR]];
        _downloadCompleteImageView.hidden = YES;
        [self addSubview:_downloadCompleteImageView];
    }
    return _downloadCompleteImageView;
}

- (UILabel *)titleLabel {
    if(_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor darkGrayColor];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UIProgressView *)progressView {
    if(_progressView == nil) {
        _progressView = [[UIProgressView alloc] init];
        _progressView.trackTintColor = [UIColor clearColor];
        _progressView.progressTintColor = MAIN_COLOR;
        [self addSubview:_progressView];
    }
    return _progressView;
}

@end
