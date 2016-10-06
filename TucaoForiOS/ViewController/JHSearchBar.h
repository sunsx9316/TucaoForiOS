//
//  JHSearchBar.h
//  TucaoForiOS
//
//  Created by JimHuang on 16/10/5.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JHSearchBar;
/**
 *  动画状态
 */
typedef NS_ENUM(NSUInteger, JHSearchBarAnimateStatus) {
    JHSearchBarAnimateStatusShow,
    JHSearchBarAnimateStatusDismiss
};
/**
 *  动画类型
 */
typedef NS_ENUM(NSUInteger, JHSearchBarAnimateType) {
    JHSearchBarAnimateTypeWillBegin,
    JHSearchBarAnimateTypePlaying,
    JHSearchBarAnimateTypeWillEnd,
};

@protocol JHSearchBarDelegate <NSObject>
@optional
- (void)searchBar:(JHSearchBar *)searchBar animateStatus:(JHSearchBarAnimateStatus)animateStatus animateType:(JHSearchBarAnimateType)animateType;
- (void)searchBarDidEndEditing;
@end

@interface JHSearchBar : UIView
@property (weak, nonatomic) id<JHSearchBarDelegate>delegate;
@property (strong, nonatomic) UITextField *searchTextField;
@end
