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
                [urls addObject:[NSURL URLWithString:urlNode.stringValue]];
            }
        }
        complete(urls, error);
    }];
}

+ (void)batchGETVideoPlayURLWithModels:(NSArray <VideoURLModel *>*)models
                        progressBlock:(void(^)(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations))progressBlock
                      completionBlock:(void(^)())completionBlock {
    
    NSMutableArray *paths = [NSMutableArray array];
    for (VideoURLModel *aModel in models) {
        [paths addObject:[[NSString alloc] initWithFormat:@"http://api.tucao.tv/api/playurl?type=%@&vid=%@&key=tucao3dd75b92.cc&r=%u", aModel.type, aModel.vid, arc4random()]];
    }
    
    [self batchGETDataWithPaths:paths progressBlock:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations, __autoreleasing id *responseObj) {

        GDataXMLDocument *document=[[GDataXMLDocument alloc] initWithData:*responseObj error:nil];
        GDataXMLElement *rootElement = document.rootElement;
        GDataXMLElement *durlNode = [rootElement elementsForName:@"durl"].firstObject;
        NSMutableArray *urls = [NSMutableArray array];
        for (GDataXMLElement *urlNode in [durlNode elementsForName:@"url"]) {
            NSString *url = urlNode.stringValue;
            if (url.length) {
                [urls addObject:[NSURL URLWithString:urlNode.stringValue]];
            }
        }
        
        if (numberOfFinishedOperations < models.count) {
            models[numberOfFinishedOperations].playURLs = urls;
        }
        if (progressBlock) {
            progressBlock(numberOfFinishedOperations, totalNumberOfOperations);
        }
    } completionBlock:^(NSArray *responseObjects, NSArray<NSURLSessionTask *> *tasks) {
        if (completionBlock) {
            completionBlock();
        }
    }];
}
@end
