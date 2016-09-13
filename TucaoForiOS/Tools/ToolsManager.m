//
//  ToolsManager.m
//  TucaoForiOS
//
//  Created by Jim_Huang on 16/9/13.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "ToolsManager.h"

@interface ToolsManager ()
//@property (strong, nonatomic) NSMutableArray *historySearchKey;
@end

@implementation ToolsManager
{
    NSMutableArray *_historySearchKeys;
}

+ (instancetype)shareToolsManager {
    static dispatch_once_t onceToken;
    static ToolsManager *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [[ToolsManager alloc] init];
    });
    return manager;
}

- (void)setHistorySearchKeys:(NSMutableArray *)historySearchKeys {
    _historySearchKeys = historySearchKeys;
    [[NSUserDefaults standardUserDefaults] setObject:historySearchKeys forKey:@"history_search_key"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - 懒加载
- (NSArray<NSString *> *)historySearchKeys {
    if (_historySearchKeys == nil) {
        _historySearchKeys = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:@"history_search_key"]];
    }
    return _historySearchKeys;
}
@end
