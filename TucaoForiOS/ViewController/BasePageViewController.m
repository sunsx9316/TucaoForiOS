//
//  BasePageViewController.m
//  TucaoForiOS
//
//  Created by JimHuang on 16/9/1.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "BasePageViewController.h"
#import "BaseSectionViewController.h"
#import "NSString+Tools.h"

@interface BasePageViewController ()<WMPageControllerDelegate, WMPageControllerDataSource>
@property (strong, nonatomic) NSArray *viewControllers;
@end

@implementation BasePageViewController

- (instancetype)init {
    if (self = [super init]) {
        self.pageAnimatable = YES;
        self.menuBGColor = MAIN_COLOR;
        self.menuViewStyle = WMMenuViewStyleLine;
        self.progressColor = [UIColor whiteColor];
        self.titleSizeNormal = 15;
        self.titleSizeSelected = 15;
        self.titleColorNormal = RGBCOLOR(230, 230, 230);
        self.titleColorSelected = [UIColor whiteColor];
        self.menuHeight = 50;
        self.itemMargin = 10;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configLeftItem];
}

- (void)dealloc {
    NSLog(@"ViewController dealloc");
}

#pragma mark - WMPageControllerDataSource
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.viewControllers.count;
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    return self.viewControllers[index];
}


- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return index < self.sections.count ? self.sections[index].sectionName : nil;
}


#pragma mark - 私有方法
- (void)configLeftItem {
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [backButton addTarget:self action:@selector(touchLeftItem:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[[[UIImage imageNamed:@"common_rightArrowShadow"] imageByRotate180] imageByTintColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)touchLeftItem:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 懒加载
- (NSArray *)viewControllers {
	if(_viewControllers == nil) {
        NSMutableArray *vcArr = [NSMutableArray array];
        for (NSString *section in _sections) {
            BaseSectionViewController *vc = [[BaseSectionViewController alloc] initWithSection:section];
            [vcArr addObject:vc];
        }
		_viewControllers = vcArr;
	}
	return _viewControllers;
}

@end
