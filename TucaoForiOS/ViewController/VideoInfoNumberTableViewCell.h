//
//  VideoInfoNumberTableViewCell.h
//  TucaoForiOS
//
//  Created by JimHuang on 16/8/25.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  显示播放数量和弹幕数量的 cell
 */
@interface VideoInfoNumberTableViewCell : UITableViewCell
@property (strong, nonatomic) UILabel *playCountLabel;
@property (strong, nonatomic) UILabel *danmakuCountLabel;
@end
