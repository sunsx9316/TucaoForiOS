//
//  VideoNetManager.m
//  TucaoForiOS
//
//  Created by JimHuang on 16/8/24.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "VideoNetManager.h"
#import "GDataXMLNode.h"

@implementation VideoNetManager
+ (NSURLSessionDataTask *)videoPlayURLWithType:(NSString *)type vid:(NSString *)vid completionHandler:(void(^)(NSArray *URLs, TucaoErrorModel *error))complete {
    //http://api.tucao.tv/api/playurl?type=189&vid=415431969342618&key=tucao3dd75b92.cc&r=1471935325
    NSString *path = [[NSString alloc] initWithFormat:@"http://api.tucao.tv/api/playurl?type=%@&vid=%@&key=tucao3dd75b92.cc&r=%u", type, vid, arc4random()];
    return [self GETDataWithPath:path parameters:nil completionHandler:^(NSData *responseObj, TucaoErrorModel *error) {
        GDataXMLDocument *document=[[GDataXMLDocument alloc] initWithData:responseObj error:&error];
        GDataXMLElement *rootElement = document.rootElement;
        GDataXMLElement *durlNode = [rootElement elementsForName:@"durl"].firstObject;
        NSMutableArray *urls = [NSMutableArray array];
        for (GDataXMLElement *urlNode in [durlNode elementsForName:@"url"]) {
            NSString *url = urlNode.stringValue;
            if (url.length) {
                [urls addObject:urlNode.stringValue];
            }
        }
        complete(urls, error);
    }];
}
@end
