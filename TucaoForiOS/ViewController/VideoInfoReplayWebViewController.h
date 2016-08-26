//
//  VideoInfoReplayWebViewController.h
//  TucaoForiOS
//
//  Created by JimHuang on 16/8/26.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "WebViewController.h"
/**
 *  视频回复内容
 */
@interface VideoInfoReplayWebViewController : WebViewController
@property (strong, nonatomic) NSString *typeId;
@property (strong, nonatomic) NSString *videoId;
@end
