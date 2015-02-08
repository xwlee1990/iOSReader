//
//  IRClearCache.h
//  iOSReader
//
//  Created by 李江辉 on 15-2-8.
//  Copyright (c) 2015年 ftxbird. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IRClearCache;

@protocol IRClearCacheDelegate <NSObject>

@optional
- (void)clearCache:(IRClearCache *)clearCache didClearCacheInfo:(NSString *)info;

@end

@interface IRClearCache : NSObject

@property (nonatomic, weak) id <IRClearCacheDelegate>delegate;

/**
 *  获取单个文件大小
 *
 *  @param filePath 单个文件路径
 *
 *  @return 字节
 */
+ (long long) fileSizeAtPath:(NSString*) filePath;

/**
 *  获得文件夹大小
 *
 *  @param folderPath 文件夹路径
 *
 *  @return MB
 */
+ (float ) folderSizeAtPath:(NSString*) folderPath;

/**
 *  清理缓存
 */
- (void)clearCache;

@end
