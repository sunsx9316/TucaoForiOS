//
//  MBProgressHUD+Tools.m
//  Fumuzhihui
//
//  Created by JimHuang on 16/5/11.
//  Copyright © 2016年 aiitec. All rights reserved.
//

#import "MBProgressHUD+Tools.h"
__weak static UIView *_superView = nil;

@implementation MBProgressHUD (Tools)
+ (void)showOnlyText:(NSString *)text {
    UIView *parentView = [UIApplication sharedApplication].windows.firstObject;
    if (!parentView) return;
    [self showOnlyText:text parentView:parentView];
}

+ (void)showOnlyText:(NSString *)text parentView:(UIView *)parentView {
    if (!parentView) return;
    
    [MBProgressHUD hideHUDForView:parentView animated:YES];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:parentView animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = text;
    [hud hideAnimated:YES afterDelay:1];
}

+ (void)showIndeterminateHUDWithView:(UIView *)view text:(NSString *)text{
    if (!text.length) text = @"加载中...";
    
    _superView = view ? view : [UIApplication sharedApplication].windows.firstObject;
    
    MBProgressHUD *progress = [MBProgressHUD showHUDAddedTo:_superView animated:YES];
    progress.mode = MBProgressHUDModeIndeterminate;
    progress.label.text = text;
    
}

+ (void)hideIndeterminateHUD {
    if (_superView) {
        [MBProgressHUD hideHUDForView:_superView animated:YES];
        _superView = nil;        
    }
}
@end
