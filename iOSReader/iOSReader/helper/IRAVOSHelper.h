//
//  IRDataHelper.h
//  iOSReader
//
//  Created by 张李成 on 15-1-31.
//  Copyright (c) 2015年 com.ftxbird. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud.h>
//暂时用不到
@interface IRAVOSHelper : NSObject

/**
 *  添加单个模型到AVCloud
 */
+ (void)saveModel:(AVObject *)object;

/**
 *  更新单个模型到AVCloud
 */
+ (void)updateModel:(AVObject *)object;

/**
 *  删除单个模型到AVCloud
 */
//+ (void)deleteModel:(AVObject *)object;

/**
 *  批量获取模型数据从AVCloud
 */
//+ (NSArray *)fetchModels:(AVObject *)object;


/**
 *  批量删除模型数据从AVCloud
 */
//+ (void)deleteModels:(NSArray *)objectArray modelName:(NSString *)modelName;

@end
