//
//  VideoCollectionModel.m
//  TucaoForiOS
//
//  Created by JimHuang on 16/8/23.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "VideoCollectionModel.h"

@implementation VideoCollectionModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"videos":[VideoModel class]};
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"videos":@"result"};
}
@end

@implementation VideoModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"URLs":[VideoURLModel class]};
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"desc":@"description", @"keyWords":@"keywords", @"typeId":@"typeid", @"typeName":@"typename", @"userId": @"userid", @"URLs": @"video"};
}
@end

@implementation VideoURLModel

@end