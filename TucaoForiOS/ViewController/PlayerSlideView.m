//
//  PlayerSlideView.m
//  test
//
//  Created by JimHuang on 16/2/2.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "PlayerSlideView.h"

@interface PlayerSlideView()
@property (strong, nonatomic) UIImageView *progressSliderImgView;
@property (strong, nonatomic) UIImageView *bufferSliderImgView;
@end

@implementation PlayerSlideView
{
    UIColor *_backGroundColor;
    UIColor *_progressSliderColor;
    UIColor *_bufferSliderColor;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = self.backGroundColor;
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = self.backGroundColor;
}

- (void)setCurrentProgress:(float)currentProgress {
    if (isnan(currentProgress)) currentProgress = 0;
    _currentProgress = currentProgress;
    self.progressSliderImgView.image = [self drawProgressImgWithProgressValue:_currentProgress color:self.progressSliderColor];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.bufferSliderImgView.frame = self.bounds;
    self.progressSliderImgView.frame = self.bounds;
    self.currentProgress = _currentProgress;
    self.bufferProgress = _bufferProgress;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGFloat value = [self progressValueWithPoint:[touches.anyObject locationInView:self]];
    if (value >= 0 && value <= 1){
        self.currentProgress = value;
        if ([self.delegate respondsToSelector:@selector(playerSliderDraggedEnd:playerSliderView:)]) {
            [self.delegate playerSliderDraggedEnd:value playerSliderView:self];
        }
        
        if (self.playerSliderDraggedEndCallBackBlock) {
            self.playerSliderDraggedEndCallBackBlock(value);
        }
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGFloat value = [self progressValueWithPoint:[touches.anyObject locationInView:self]];
    if (value >= 0 && value <= 1){
        self.currentProgress = value;
        if ([self.delegate respondsToSelector:@selector(playerSliderTouchEnd:playerSliderView:)]) {
            [self.delegate playerSliderTouchEnd:value playerSliderView:self];
        }
        
        if (self.playerSliderTouchEndCallBackBlock) {
            self.playerSliderTouchEndCallBackBlock(value);
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([self.delegate respondsToSelector:@selector(playerSliderTouchBeginWithPlayerSliderView:)]) {
        [self.delegate playerSliderTouchBeginWithPlayerSliderView:self];
    }
    
    if (self.playerSliderTouchBeginCallBackBlock) {
        self.playerSliderTouchBeginCallBackBlock();
    }
}

- (void)setBufferProgress:(float)bufferProgress {
    if (isnan(bufferProgress)) bufferProgress = 0;
    _bufferProgress = bufferProgress;
    self.bufferSliderImgView.image = [self drawProgressImgWithProgressValue:_bufferProgress color:self.bufferSliderColor];
}

- (void)setBackGroundColor:(UIColor *)backGroundColor{
    _backGroundColor = backGroundColor;
    self.backgroundColor = backGroundColor;
}

#pragma mark - 私有方法
- (CGFloat)progressValueWithPoint:(CGPoint)point {
    return point.x / self.frame.size.width;
}

- (UIImage *)drawProgressImgWithProgressValue:(float)value color:(UIColor *)color{
    CGSize size = self.bounds.size;
    float progressValue = size.width * value;
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [color setFill];
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(progressValue - size.height, 0, size.height, size.height)];
    [path fill];
    //进度大于半圆 绘制后面的直线
    if (progressValue - size.height / 2 > 0) {
        [[UIBezierPath bezierPathWithRect:CGRectMake(0, 0, progressValue - size.height / 2, size.height)] fill];
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - 懒加载
- (UIColor *)progressSliderColor {
    if(_progressSliderColor == nil) {
        _progressSliderColor = [UIColor blueColor];
    }
    return _progressSliderColor;
}

- (UIColor *)backGroundColor{
    if (_backGroundColor == nil) {
        _backGroundColor = [UIColor lightGrayColor];
    }
    return _backGroundColor;
}

- (UIColor *)bufferSliderColor {
    if(_bufferSliderColor == nil) {
        _bufferSliderColor = [UIColor grayColor];
    }
    return _bufferSliderColor;
}

- (UIImageView *)progressSliderImgView {
    if(_progressSliderImgView == nil) {
        _progressSliderImgView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:_progressSliderImgView];
    }
    return _progressSliderImgView;
}

- (UIImageView *)bufferSliderImgView {
    if(_bufferSliderImgView == nil) {
        _bufferSliderImgView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:_bufferSliderImgView];
    }
    return _bufferSliderImgView;
}

@end
