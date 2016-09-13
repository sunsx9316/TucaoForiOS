//
//  ToolsManager.h
//  TucaoForiOS
//
//  Created by Jim_Huang on 16/9/13.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToolsManager : NSObject
+ (instancetype)shareToolsManager;
@property (strong, nonatomic) NSMutableArray *historySearchKeys;
@end
