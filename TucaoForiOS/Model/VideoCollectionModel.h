//
//  VideoCollectionModel.h
//  TucaoForiOS
//
//  Created by JimHuang on 16/8/23.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "BaseModel.h"
@class VideoModel, VideoURLModel;
@interface VideoCollectionModel : BaseModel
@property (strong, nonatomic) NSArray <VideoModel *>*videos;
@end

typedef NS_ENUM(NSUInteger, VideoURLModelStatus) {
    VideoURLModelStatusNone,
    VideoURLModelStatusDownloding,
    VideoURLModelStatusDownloded,
};

@interface VideoModel : BaseModel
/**
 *  发布时间
 */
@property (copy, nonatomic) NSString *create;
/**
 *  介绍
 */
@property (copy, nonatomic) NSString *desc;
/**
 *  视频 id
 */
@property (copy, nonatomic) NSString *hid;
/**
 *  关键词
 */
@property (copy, nonatomic) NSString *keyWords;
/**
 *  视频名称
 */
@property (copy, nonatomic) NSString *title;
/**
 *  分类 id
 */
@property (copy, nonatomic) NSString *typeId;
/**
 *  分类名称
 */
@property (copy, nonatomic) NSString *typeName;
/**
 *  发布人
 */
@property (copy, nonatomic) NSString *user;
/**
 *  发布人 id
 */
@property (copy, nonatomic) NSString *userId;
/**
 *  弹幕数
 */
@property (copy, nonatomic) NSString *mukio;
/**
 *  分 p 数量
 */
@property (assign, nonatomic) NSUInteger part;
/**
 *  播放数
 */
@property (copy, nonatomic) NSString *play;
/**
 *  缩略图
 */
@property (strong, nonatomic) NSURL *thumb;
/**
 *  路径集合
 */
@property (strong, nonatomic) NSMutableArray <VideoURLModel *>*URLs;
@end

@interface VideoURLModel : BaseModel
/**
 *  视频名称
 */
@property (strong, nonatomic) NSString *title;
/**
 *  视频源类型
 */
@property (copy, nonatomic) NSString *type;
/**
 *  视频 id
 */
@property (copy, nonatomic) NSString *vid;
/**
 *  播放地址
 */
@property (strong, nonatomic) NSArray <NSURL *>*playURLs;
/**
 *  视频状态
 */
@property (assign, nonatomic) VideoURLModelStatus status;
/**
 *  下载进度
 */
@property (assign, nonatomic) float progress;
/**
 *  断点下载数据
 */
@property (strong, nonatomic) NSData *resumeData;
@end