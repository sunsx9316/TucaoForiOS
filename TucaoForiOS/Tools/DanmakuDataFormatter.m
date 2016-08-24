//
//  DanmakuDataFormatter.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/1/27.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "DanmakuDataFormatter.h"
#import "DanmakuModel.h"
#import "NSString+Tools.h"
#import "ScrollDanmaku.h"
#import "FloatDanmaku.h"
#import "JHDanmakuEngine+Tools.h"
#import <GDataXMLNode.h>

typedef void(^callBackBlock)(DanmakuModel *model);
@implementation DanmakuDataFormatter
+ (NSMutableDictionary *)dicWithObj:(id)obj {
    NSMutableDictionary <NSNumber *,NSMutableArray <ParentDanmaku *> *> *dic = [NSMutableDictionary dictionary];
    if (obj) {
        UIFont *font = [UIFont systemFontOfSize:15];
        [self danmakuWithBilibiliData:obj block:^(DanmakuModel *model) {
            NSInteger time = model.time;
            if (!dic[@(time)]) dic[@(time)] = [NSMutableArray array];
            ParentDanmaku *danmaku = [JHDanmakuEngine DanmakuWithText:model.message color:model.color spiritStyle:model.mode shadowStyle:danmakuShadowStyleGlow fontSize: font.pointSize font:font];
            danmaku.appearTime = model.time;
            danmaku.filter = model.isFilter;
            [dic[@(time)] addObject: danmaku];
        }];
    }
    return dic;
}

+ (NSMutableArray *)arrWithObj:(id)obj {
    NSMutableArray *arr = [NSMutableArray array];
    if (obj) {
        UIFont *font = [UIFont systemFontOfSize:15];
        [self danmakuWithBilibiliData:obj block:^(DanmakuModel *model) {
            ParentDanmaku *danmaku = [JHDanmakuEngine DanmakuWithText:model.message color:model.color spiritStyle:model.mode shadowStyle:danmakuShadowStyleGlow fontSize:font.pointSize font:font];
            danmaku.appearTime = model.time;
            danmaku.filter = model.isFilter;
            [arr addObject: danmaku];
        }];
    }
    return arr;
}

#pragma mark - 私有方法
//b站解析方式
+ (void)danmakuWithBilibiliData:(NSData*)data block:(callBackBlock)block {
    GDataXMLDocument *document=[[GDataXMLDocument alloc] initWithData:data error:nil];
    GDataXMLElement *rootElement = document.rootElement;
    NSArray *array = [rootElement elementsForName:@"d"];
    for (GDataXMLElement *ele in array) {
            NSArray* strArr = [[[ele attributeForName:@"p"] stringValue] componentsSeparatedByString:@","];
            DanmakuModel *model = [[DanmakuModel alloc] init];
            model.time = [strArr[0] floatValue];
            model.mode = [strArr[1] intValue];
            model.color = [strArr[3] intValue];
            model.message = [ele stringValue];
            if (block) block(model);
    }
}
@end

