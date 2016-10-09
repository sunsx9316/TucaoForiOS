//
//  NSObject+Tools.m
//  TucaoForiOS
//
//  Created by Jim_Huang on 2016/10/9.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "NSObject+Tools.h"

@implementation NSObject (Tools)
- (void)addWeakAssociation:(id)obj key:(NSString *)key {
    __weak id weakObj = obj;
    objc_setAssociatedObject(self, (const void *)key.hash, ^{
        return weakObj;
    }, OBJC_ASSOCIATION_COPY);
}

- (id)weakAssociationWithKey:(NSString *)key {
    id (^block)(void) = objc_getAssociatedObject(self, (const void *)key.hash);
    if (block) {
        return block();
    }
    return nil;
}

- (BOOL)jh_isEqual:(id)object blacklist:(NSArray <NSString *>*)blacklist {
    if (self == object) return YES;
    if (![object isMemberOfClass:self.class]) return NO;
    
    YYClassInfo *info = [YYClassInfo classInfoWithClass:self.class];
    NSMutableArray *arr = [NSMutableArray arrayWithArray:info.propertyInfos.allKeys];
    [arr removeObjectsInArray:blacklist];
    [arr removeObjectsInArray:@[@"hash", @"debugDescription", @"description"]];
    return [self jh_isEqual:object keys:arr];
}

- (BOOL)jh_isEqual:(id)object whitelist:(NSArray <NSString *>*)whitelist {
    if (self == object) return YES;
    if (![object isMemberOfClass:self.class]) return NO;
    
    return [self jh_isEqual:object keys:whitelist];
}

- (NSUInteger)jh_hashWithBlacklist:(NSArray <NSString *>*)blacklist {
    YYClassInfo *info = [YYClassInfo classInfoWithClass:self.class];
    NSMutableArray *arr = [NSMutableArray arrayWithArray:info.propertyInfos.allKeys];
    [arr removeObjectsInArray:blacklist];
    [arr removeObjectsInArray:@[@"hash", @"debugDescription", @"description"]];
    return [self jh_hashKeys:arr];
}

- (NSUInteger)jh_hashWithWhitelist:(NSArray <NSString *>*)whitelist {
    return [self jh_hashKeys:whitelist];
}

#pragma mark - 私有方法
- (BOOL)jh_isEqual:(id)object keys:(NSArray <NSString *>*)keys {
    YYClassInfo *info = [YYClassInfo classInfoWithClass:self.class];
    for (NSString *key in keys) {
        YYClassPropertyInfo *propertyInfo = info.propertyInfos[key];
        id this = [self valueForKey:NSStringFromSelector(propertyInfo.getter)];
        id that = [object valueForKey:NSStringFromSelector(propertyInfo.getter)];
        if (this == that) continue;
        if (this == nil || that == nil) return NO;
        if (![this isEqual:that]) return NO;
    }
    return YES;
}

- (NSUInteger)jh_hashKeys:(NSArray <NSString *>*)keys {
    if (self == (id)kCFNull) return [self hash];
    YYClassInfo *info = [YYClassInfo classInfoWithClass:self.class];
    
    NSUInteger value = 0;
    NSUInteger count = 0;
    for (NSString *key in keys) {
        YYClassPropertyInfo *propertyInfo = info.propertyInfos[key];
        value ^= [[self valueForKey:NSStringFromSelector(propertyInfo.getter)] hash];
        count++;
    }
    if (count == 0) value = (long)((__bridge void *)self);
    return value;
}

@end
