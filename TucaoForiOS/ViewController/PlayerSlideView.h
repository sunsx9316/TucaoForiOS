//
//  PlayerSlideView.h
//  test
//
//  Created by JimHuang on 16/2/2.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PlayerSlideView;

@protocol PlayerSlideViewDelegate<NSObject>
@optional
/**
 *  开始点击控制条
 *
 *  @param endValue         点击位置占总长度的百分比
 *  @param PlayerSliderView PlayerSliderView
 */
- (void)playerSliderTouchBeginWithPlayerSliderView:(PlayerSlideView*)playerSliderView;
/**
 *  点击控制条事件
 *
 *  @param endValue         点击位置占总长度的百分比
 *  @param PlayerSliderView PlayerSliderView
 */
- (void)playerSliderTouchEnd:(CGFloat)endValue playerSliderView:(PlayerSlideView*)playerSliderView;
/**
 *  拖拽控制条事件
 *
 *  @param endValue         拖拽位置占总长度的百分比
 *  @param PlayerSliderView PlayerSliderView
 */
- (void)playerSliderDraggedEnd:(CGFloat)endValue playerSliderView:(PlayerSlideView*)playerSliderView;
@end

@interface PlayerSlideView : UIView
@property (weak, nonatomic) id<PlayerSlideViewDelegate> delegate;
@property (strong, nonatomic) UIColor *backGroundColor;
@property (strong, nonatomic) UIColor *progressSliderColor;
@property (strong, nonatomic) UIColor *bufferSliderColor;
@property (assign, nonatomic) float currentProgress;
@property (assign, nonatomic) float bufferProgress;
@property (copy, nonatomic) void(^playerSliderDraggedEndCallBackBlock)(CGFloat endValue);
@property (copy, nonatomic) void(^playerSliderTouchEndCallBackBlock)(CGFloat endValue);
@property (copy, nonatomic) void(^playerSliderTouchBeginCallBackBlock)();
@end
