//
//  VideoInfoReplayWebViewController.m
//  TucaoForiOS
//
//  Created by JimHuang on 16/8/26.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "VideoInfoReplayWebViewController.h"

@interface VideoInfoReplayWebViewController ()

@end

@implementation VideoInfoReplayWebViewController

- (void)viewDidLoad {
    //http://www.tucao.tv/index.php?m=comment&c=index&a=init&commentid=content_27-4067552-1&hot=0&iframe=1
    self.URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.tucao.tv/index.php?m=comment&c=index&a=init&commentid=content_%@-%@-1&hot=0&iframe=1", _typeId, _videoId]];
    [super viewDidLoad];
}

@end
