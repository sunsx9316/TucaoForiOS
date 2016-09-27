//
//  HeadHitDisableTableView.m
//  TucaoForiOS
//
//  Created by Jim_Huang on 16/9/27.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "HeadHitDisableTableView.h"

@implementation HeadHitDisableTableView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (CGRectContainsPoint(self.tableHeaderView.frame, [self convertPoint:point toView:self.tableHeaderView])) {
        return nil;
    }
    return [super hitTest:point withEvent:event];
}

@end
