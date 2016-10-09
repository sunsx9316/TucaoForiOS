//
//  NSObject+Tools.h
//  TucaoForiOS
//
//  Created by Jim_Huang on 2016/10/9.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Tools)
- (void)addWeakAssociation:(id)obj key:(NSString *)key;
- (id)weakAssociationWithKey:(NSString *)key;
- (BOOL)jh_isEqual:(id)object blacklist:(NSArray <NSString *>*)blacklist;
- (BOOL)jh_isEqual:(id)object whitelist:(NSArray <NSString *>*)whitelist;
- (NSUInteger)jh_hashWithBlacklist:(NSArray <NSString *>*)blacklist;
- (NSUInteger)jh_hashWithWhitelist:(NSArray <NSString *>*)whitelist;
@end
