//
//  VideoInfoButtonTableViewCell.m
//  TucaoForiOS
//
//  Created by JimHuang on 16/8/25.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "VideoInfoButtonTableViewCell.h"
@interface VideoInfoButtonTableViewCell()
@property (strong, nonatomic) UIButton *downloadButton;
@property (strong, nonatomic) UIButton *favouriteButton;
@end

@implementation VideoInfoButtonTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.downloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.top.equalTo(self.favouriteButton);
            make.left.equalTo(self.favouriteButton.mas_right).mas_offset(20);
        }];
        
        [self.favouriteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_offset(10);
            make.bottom.mas_offset(-10);
        }];
    }
    return self;
}

#pragma mark - 私有方法
- (UIButton *)buttonWithName:(NSString *)name image:(UIImage *)image {
    UIButton *button = [[UIButton alloc] init];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor darkGrayColor];
    label.userInteractionEnabled = NO;
    label.text = name;
    
    [button addSubview:imgView];
    [button addSubview:label];
    
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.equalTo(imgView.mas_width);
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgView.mas_bottom).mas_offset(5);
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    return button;
}

#pragma mark - 懒加载
- (UIButton *)favouriteButton {
	if(_favouriteButton == nil) {
        _favouriteButton = [self buttonWithName:@"收藏" image:[UIImage imageNamed:@"mine_favourite"]];
        [self.contentView addSubview:_favouriteButton];
	}
	return _favouriteButton;
}

- (UIButton *)downloadButton {
	if(_downloadButton == nil) {
		_downloadButton = [self buttonWithName:@"缓存" image:[UIImage imageNamed:@"mine_download"]];
        [self.contentView addSubview:_downloadButton];
	}
	return _downloadButton;
}

@end
