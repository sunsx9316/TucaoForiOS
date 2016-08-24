//
//  JHDanmakuEngine+Tools.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/24.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <JHDanmakuEngine.h>
#import "DanmakuModel.h"

@interface JHDanmakuEngine (Tools)
+ (ParentDanmaku *)DanmakuWithText:(NSString*)text color:(NSInteger)color spiritStyle:(NSInteger)spiritStyle shadowStyle:(danmakuShadowStyle)shadowStyle fontSize:(CGFloat)fontSize font:(UIFont *)font;
+ (ParentDanmaku *)DanmakuWithModel:(DanmakuModel *)model shadowStyle:(danmakuShadowStyle)shadowStyle fontSize:(CGFloat)fontSize font:(UIFont *)font;
@end
