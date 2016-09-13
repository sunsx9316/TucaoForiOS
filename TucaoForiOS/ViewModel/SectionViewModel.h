//
//  SectionViewModel.h
//  TucaoForiOS
//
//  Created by JimHuang on 16/9/13.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "BaseViewModel.h"
#import "VideoListProtocol.h"

@interface SectionViewModel : BaseViewModel<VideoListProtocol>
- (instancetype)initWithSection:(NSString *)section;
@end
