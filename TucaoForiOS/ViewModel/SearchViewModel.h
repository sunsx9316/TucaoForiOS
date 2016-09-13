//
//  SearchViewModel.h
//  TucaoForiOS
//
//  Created by JimHuang on 16/9/13.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "BaseViewModel.h"
#import "VideoListProtocol.h"

@interface SearchViewModel : BaseViewModel<VideoListProtocol>
@property (copy, nonatomic) NSString *keyword;
@property (copy, nonatomic) NSString *tid;
@end
