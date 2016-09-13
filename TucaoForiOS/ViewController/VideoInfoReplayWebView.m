//
//  VideoInfoReplayWebView.m
//  TucaoForiOS
//
//  Created by JimHuang on 16/8/28.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "VideoInfoReplayWebView.h"
#import <WebKit/WebKit.h>
#import <MBProgressHUD.h>

@interface VideoInfoReplayWebView ()<UIWebViewDelegate>
@property (strong, nonatomic) UIWebView *webView;
@end

@implementation VideoInfoReplayWebView
{
    NSUInteger _currentPage;
    NSString *_typeId;
    NSString *_videoId;
}

- (instancetype)initWithFrame:(CGRect)frame typeId:(NSString *)typeId videoId:(NSString *)videoId {
    if (self = [super initWithFrame:frame]) {
        _currentPage = 1;
        _typeId = typeId;
        _videoId = videoId;
        [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        [self.webView loadRequest:[self requestWithPage:_currentPage]];
        
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        NSValue *value = change[@"new"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SCROLL_VIEW_DID_SCROLL" object:@(value.CGPointValue.y)];
    }
}

- (void)dealloc {
    [self.webView.scrollView removeObserver:self forKeyPath:@"contentOffset"];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
}

#pragma mark - 私有方法
/**
 *  根据page转换请求
 *
 *  @param page 页数
 *
 *  @return 请求
 */
- (NSURLRequest *)requestWithPage:(NSUInteger)page {
    NSString *path = [NSString stringWithFormat:@"http://www.tucao.tv/index.php?m=comment&c=index&a=init&commentid=content_%@-%@-1&hot=0&iframe=1&page=%lu", _typeId, _videoId, page];
    NSLog(@"网页 %@", path);
    return [NSURLRequest requestWithURL:[NSURL URLWithString:path]];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [webView.scrollView.mj_header endRefreshing];
    [webView.scrollView.mj_footer endRefreshing];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [webView.scrollView.mj_header endRefreshing];
    [webView.scrollView.mj_footer endRefreshing];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
}

- (UIWebView *)webView {
	if(_webView == nil) {
		_webView = [[UIWebView alloc] initWithFrame:self.bounds];
        [_webView.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        _webView.scalesPageToFit = YES;
        _webView.delegate = self;
        _webView.backgroundColor = BACK_GROUND_COLOR;
        @weakify(self)
        _webView.scrollView.mj_header = [MJRefreshNormalHeader headerWithDefaultRefreshingBlock:^{
            @strongify(self)
            if (!self) return;
            if (self->_currentPage >= 2) {
                --self->_currentPage;
            }
            [self.webView loadRequest:[self requestWithPage:self->_currentPage]];
        }];
        
        _webView.scrollView.mj_footer = [MJRefreshAutoNormalFooter footerWithhDefaultRefreshingBlock:^{
            @strongify(self)
            if (!self) return;
            [self.webView loadRequest:[self requestWithPage:++self->_currentPage]];
        }];
        
        [self addSubview:_webView];
	}
	return _webView;
}

@end
