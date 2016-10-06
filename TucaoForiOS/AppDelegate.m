//
//  AppDelegate.m
//  TucaoForiOS
//
//  Created by JimHuang on 16/8/23.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "VideoInfoViewController.h"
#import "SectionViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    MainViewController *vc = [[MainViewController alloc] init];
    _window.rootViewController = vc;
    [_window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    dispatch_group_t group = dispatch_group_create();
    
    NSArray *arr = [UserDefaultManager shareUserDefaultManager].downloadVideos;
    for (NSInteger i = arr.count - 1; i >= 0; --i) {
        VideoURLModel *model = arr[i];
        NSURLSessionDownloadTask *task = objc_getAssociatedObject(model, "task");
        dispatch_group_enter(group);
        dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
            [task cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
                model.resumeData = resumeData;
                [[UserDefaultManager shareUserDefaultManager] addDownloadVideo:model];
                dispatch_group_leave(group);
            }];
        });
    }
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
}

@end
