//
//  WebViewController.m
//  BiliBili
//
//  Created by apple-jd44 on 15/10/28.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import "WebViewController.h"


@interface WebViewController ()
@property (strong, nonatomic) WKWebView *webView;
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.URL]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
}

#pragma mark - WKNavigationDelegate

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: YES];
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
}

#pragma mark - 懒加载
- (WKWebView *)webView {
	if(_webView == nil) {
		_webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
        _webView.scrollView.delegate = self;
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        [self.view addSubview:_webView];
	}
	return _webView;
}

@end
