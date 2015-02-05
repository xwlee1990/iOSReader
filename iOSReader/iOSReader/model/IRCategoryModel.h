//
//  CategoryModel.h
//  ios reader
//
//  Created by 张李成 on 15-1-31.
//  Copyright (c) 2015年 com.ftxbird. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>
#import <Foundation/Foundation.h>

/**
 *  定义分类枚举
 */
typedef NS_ENUM(NSInteger, IRCategoryType){
    /**
     *  博客
     */
    IRCategoryTypeBlog = 0,
    /**
     *  网站
     */
    IRCategoryTypeWeb,
    /**
     *  github源码
     */
    IRCategoryTypeGitHub,
};
@interface IRCategoryModel : AVObject<AVSubclassing,NSCoding>
/**
 *  索引
 */
@property (nonatomic,copy) NSString * categoryIndex;
/**
 *  Url
 */
@property (nonatomic,copy) NSString * categoryUrl;
/**
 *  标题
 */
@property (nonatomic,copy) NSString * categoryTitle;
/**
 *  分类类型
 */
@property (nonatomic)IRCategoryType categoryType;


@end
