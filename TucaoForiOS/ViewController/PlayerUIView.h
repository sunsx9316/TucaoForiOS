//
//  PlayerUIView.h
//  TucaoForiOS
//
//  Created by JimHuang on 16/9/2.
//  Copyright © 2016年 jimHuang. All rights reserved.
//
#import <UIKit/UIKit.h>
/**
 *  播放器的UI界面
 */
@interface PlayerUIView : UIView
/**
 *  返回按钮
 */
@property (strong, nonatomic) UIButton *backButton;
/**
 *  播放按钮
 */
@property (strong, nonatomic) UIButton *playButton;
/**
 *  弹幕设置按钮
 */
@property (strong, nonatomic) UIButton *danmakuConfigButton;
/**
 *  弹幕显示/隐藏按钮
 */
@property (strong, nonatomic) UIButton *danmakuHideButton;
/**
 *  播放源选择按钮
 */
@property (strong, nonatomic) UIButton *playSourseButton;
/**
 *  分集选择按钮
 */
@property (strong, nonatomic) UIButton *episodeButton;
/**
 *  全屏按钮
 */
@property (strong, nonatomic) UIButton *fullScreenButton;
/**
 *  进度
 */
@property (strong, nonatomic) UISlider *playerProgressSlider;
/**
 *  视频标题
 */
@property (strong, nonatomic) UILabel *titleLabel;
/**
 *  当前时间
 */
@property (strong, nonatomic) UILabel *currentTimeLabel;
/**
 *  视频长度
 */
@property (strong, nonatomic) UILabel *videolengthLabel;

@property (strong, nonatomic) UIView *bottomView;

@property (strong, nonatomic) UIView *topView;

- (void)show;
- (void)dismiss;
@property (assign, nonatomic, readonly) BOOL isShowing;
@end
