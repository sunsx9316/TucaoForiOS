//
//  DanMuModel.h
//  DanWanPlayer
//
//  Created by JimHuang on 15/12/24.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import "BaseModel.h"
/**
 *  弹幕模型
 */
@class DanmakuModel;
@interface DanmakuCollectionModel : BaseModel
@property (nonatomic, strong)NSArray<DanmakuModel*>* comments;
@end

@interface DanmakuModel : BaseModel
/**
 *  Time: 浮点数形式的弹幕时间，单位为秒。
 */
@property (nonatomic, assign) CGFloat time;
/**
 *  Mode: 弹幕模式，1普通弹幕，4底部弹幕，5顶部弹幕。
 */
@property (nonatomic, assign) NSInteger mode;
/**
 *  Color: 32位整形数的弹幕颜色，算法为 R*256*256 + G*256 + B。
 */
@property (nonatomic, assign) NSInteger color;
/**
 *  Message: 弹幕内容文字。\r和\n不会作为换行转义符。
 */
@property (nonatomic, strong) NSString *message;
/**
 *  是否被过滤
 */
@property (assign, nonatomic, getter=isFilter) BOOL filter;
@end