//
//  VideoInfoReplayWebView.m
//  TucaoForiOS
//
//  Created by JimHuang on 16/8/28.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "VideoInfoReplayWebView.h"
#import <WebKit/WebKit.h>

@interface VideoInfoReplayWebView ()<WKUIDelegate, WKNavigationDelegate>
@property (strong, nonatomic) WKWebView *webView;
@end

@implementation VideoInfoReplayWebView

- (instancetype)initWithFrame:(CGRect)frame typeId:(NSString *)typeId videoId:(NSString *)videoId {
    if (self = [super initWithFrame:frame]) {
        NSString *path = [NSString stringWithFormat:@"http://www.tucao.tv/index.php?m=comment&c=index&a=init&commentid=content_%@-%@-1&hot=0&iframe=1", typeId, videoId];
        NSLog(@"%@", path);
//        [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.mas_equalTo(0);
//        }];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:path]]];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.webView.frame = self.bounds;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    NSValue *value = change[@"new"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SCROLL_VIEW_DID_SCROLL" object:@(value.CGPointValue.y)];
}

- (void)dealloc {
    [self.webView.scrollView removeObserver:self forKeyPath:@"contentOffset"];
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

- (WKWebView *)webView {
	if(_webView == nil) {
		_webView = [[WKWebView alloc] initWithFrame:self.bounds];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        [_webView.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        [self addSubview:_webView];
	}
	return _webView;
}

@end
