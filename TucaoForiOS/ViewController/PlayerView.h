//
//  PlayerView.h
//  TucaoForiOS
//
//  Created by JimHuang on 16/9/2.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  播放器view
 */
@interface PlayerView : UIView
@property (copy, nonatomic) void(^touchFullScreenCallBack)();
@end
