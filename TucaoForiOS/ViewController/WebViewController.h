//
//  WebViewController.h
//  BiliBili
//
//  Created by apple-jd44 on 15/10/28.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface WebViewController : UIViewController<WKNavigationDelegate, WKUIDelegate, UIScrollViewDelegate>
@property (strong, nonatomic) NSURL *URL;
@end
