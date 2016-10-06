//
//  JHSearchBar.m
//  TucaoForiOS
//
//  Created by JimHuang on 16/10/5.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "JHSearchBar.h"

@interface JHSearchBar ()<UITextFieldDelegate>
@property (strong, nonatomic) UIView *holdView;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UIImageView *searchIconImgView;
@end

@implementation JHSearchBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.holdView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.mas_equalTo(0);
            make.right.equalTo(self.cancelButton.mas_left).mas_offset(-10);
        }];
        
        [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
            make.height.mas_equalTo(30);
            make.centerY.mas_equalTo(0);
            make.right.mas_offset(10);
        }];
    }
    return self;
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(searchBar:animateStatus:animateType:)]) {
        [self.delegate searchBar:self animateStatus:JHSearchBarAnimateStatusDismiss animateType:JHSearchBarAnimateTypeWillBegin];
    }
    
    [self.cancelButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(0);
        make.right.mas_offset(10);
    }];
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
        [self.delegate searchBar:self animateStatus:JHSearchBarAnimateStatusDismiss animateType:JHSearchBarAnimateTypePlaying];
    } completion:^(BOOL finished) {
        [self.delegate searchBar:self animateStatus:JHSearchBarAnimateStatusDismiss animateType:JHSearchBarAnimateTypeWillEnd];
    }];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(searchBar:animateStatus:animateType:)]) {
        [self.delegate searchBar:self animateStatus:JHSearchBarAnimateStatusShow animateType:JHSearchBarAnimateTypeWillBegin];
    }
    
    
    [self.cancelButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(60);
        make.right.mas_equalTo(0);
    }];
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
        [self.delegate searchBar:self animateStatus:JHSearchBarAnimateStatusShow animateType:JHSearchBarAnimateTypePlaying];
    }completion:^(BOOL finished) {
        [self.delegate searchBar:self animateStatus:JHSearchBarAnimateStatusShow animateType:JHSearchBarAnimateTypeWillEnd];
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(searchBarDidEndEditing)]) {
        [self.delegate searchBarDidEndEditing];
    }
    [self touchCancelButton];
    return YES;
}

#pragma mark - 私有方法
- (void)touchCancelButton {
    [self.searchTextField resignFirstResponder];
}

#pragma mark - 懒加载
- (UIView *)holdView {
	if(_holdView == nil) {
		_holdView = [[UIView alloc] init];
        _holdView.backgroundColor = [UIColor whiteColor];
        _holdView.layer.masksToBounds = YES;
        _holdView.layer.cornerRadius = 5;
        [self addSubview:_holdView];
        
        [_holdView addSubview:self.searchTextField];
        [_holdView addSubview:self.searchIconImgView];
        
        [_searchIconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.mas_offset(10);
            make.width.priorityHigh();
        }];
        
        [_searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_searchIconImgView.mas_right).mas_offset(10);
            make.top.mas_offset(5);
            make.bottom.mas_offset(-5);
            make.right.equalTo(self.cancelButton.mas_left);
        }];
	}
	return _holdView;
}

- (UIButton *)cancelButton {
	if(_cancelButton == nil) {
		_cancelButton = [[UIButton alloc] init];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [_cancelButton addTarget:self action:@selector(touchCancelButton) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cancelButton];
	}
	return _cancelButton;
}

- (UITextField *)searchTextField {
	if(_searchTextField == nil) {
		_searchTextField = [[UITextField alloc] init];
        _searchTextField.placeholder = @"搜索关键词、视频id";
        _searchTextField.font = [UIFont systemFontOfSize:13];
        _searchTextField.tintColor = MAIN_COLOR;
        _searchTextField.delegate = self;
        _searchTextField.returnKeyType = UIReturnKeySearch;
	}
	return _searchTextField;
}

- (UIImageView *)searchIconImgView {
	if(_searchIconImgView == nil) {
		_searchIconImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search_prompt_icon"]];
        _searchIconImgView.contentMode = UIViewContentModeScaleAspectFit;
	}
	return _searchIconImgView;
}

@end
