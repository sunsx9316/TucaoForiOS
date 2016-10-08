//
//  VideoCollectionModel.m
//  TucaoForiOS
//
//  Created by JimHuang on 16/8/23.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "VideoCollectionModel.h"
#import "NSString+Tools.h"

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
    return [self yy_modelIsEqual:object];
}

- (NSUInteger)hash {
    return self.yy_modelHash;
}

@end

@implementation VideoURLModel
- (BOOL)isEqual:(VideoURLModel *)object {
    if (self == object) return YES;
    if (![object isMemberOfClass:self.class]) return NO;
    if ([self hash] != [object hash]) return NO;
    return [self.title isEqualToString:object.title] && [self.type isEqualToString:object.type] && [self.vid isEqualToString:object.vid];
}

- (NSUInteger)hash {
    return self.title.hash | self.type.hash | self.vid.hash;
}
@end