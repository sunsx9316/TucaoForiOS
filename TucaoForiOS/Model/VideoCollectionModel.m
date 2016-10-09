//
//  VideoCollectionModel.m
//  TucaoForiOS
//
//  Created by JimHuang on 16/8/23.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "VideoCollectionModel.h"
#import "NSString+Tools.h"
#import "NSObject+Tools.h"

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

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    NSString *play = dic[@"play"];
    _play = [NSString stringWithFormatNum:play.integerValue];
    
    NSString *mukio = dic[@"mukio"];
    _mukio = [NSString stringWithFormatNum:mukio.integerValue];
    
    NSString *creat = dic[@"create"];
    _create = [NSString stringWithCreatTime:creat];
    return YES;
}

- (BOOL)isEqual:(id)object {
    return [self jh_isEqual:object blacklist:@[@"URLs"]];
}

- (NSUInteger)hash {
    return [self jh_hashWithBlacklist:@[@"URLs"]];
}

@end

@implementation VideoURLModel
- (BOOL)isEqual:(id)object {
    return [self jh_isEqual:object whitelist:@[@"title", @"type", @"vid"]];
}

- (NSUInteger)hash {
    return [self jh_hashWithWhitelist:@[@"title", @"type", @"vid"]];
}
@end