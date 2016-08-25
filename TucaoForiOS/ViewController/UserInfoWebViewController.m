//
//  UserInfoWebViewController.m
//  TucaoForiOS
//
//  Created by JimHuang on 16/8/25.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "UserInfoWebViewController.h"

@interface UserInfoWebViewController ()

@end

@implementation UserInfoWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setUserId:(NSString *)userId {
   // http://www.tucao.tv/play/u11721/
    _userId = userId;
    self.URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.tucao.tv/play/u%@/", _userId]];
}

@end
