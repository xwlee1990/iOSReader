//
//  articleModel.h
//  ios reader
//
//  Created by 张李成 on 15-1-26.
//  Copyright (c) 2015年 com.ftxbird. All rights reserved.
//
#import <AVOSCloud/AVOSCloud.h>
#import <Foundation/Foundation.h>

@interface IRArticleModel : AVObject<AVSubclassing>
/**
 *  索引
 */
@property (nonatomic,copy) NSString * articleIndex;

/**
 *  Url
 */
@property (nonatomic,copy) NSString * articleUrl;

/**
 *  标题
 */
@property (nonatomic,copy) NSString * articleTitle;

/**
 *  简介
 */
@property (nonatomic,copy) NSString * articleSubContent;

/**
 *  图片地址
 */
@property (nonatomic,copy) NSString *articleImageUrl;

@end
