//
//  ReaderDataMannager.h
//  ios reader
//
//  Created by 张李成 on 15-2-1.
//  Copyright (c) 2015年 com.ftxbird. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IRCategoryModel.h"
#import "IRArticleModel.h"

@interface IRDataMannager : NSObject


+ (IRDataMannager *)sharedManager;


/**
 *  初始化用户首页数据
 */
+ (NSMutableArray *)initUserData;

/**
 *  初始化用户收藏数据
 */
+ (NSMutableArray *)initUserFavouriteData;


/**
 *  从本地加载缓存程序分类数据
 *
 *  @param type    分类类型
 *  @param success 成功回调 categoryArray 加载得到的分类模型数组
 *  @param failure 失败回调 errorStr      错误字符串,用于提示用户
 */
- (void)fetchLocalCategoryType:(IRCategoryType)type WithSuccess:(void (^)(NSMutableArray *categoryArray))success failure:(void (^)(NSString *errorStr))failure;

/**
 *  从网络加载缓存程序分类数据
 *
 *  @param type    分类类型
 *  @param success 成功回调 categoryArray 加载得到的分类模型数组
 *  @param failure 失败回调 errorStr      错误字符串,用于提示用户
 */
- (void)fetchNetworkCategoryType:(IRCategoryType)type WithSuccess:(void (^)(NSMutableArray *categoryArray))success failure:(void (^)(NSString *errorStr))failure;

/**
 *  从本地加载用户添加到主页分类数据
 *
 *  @param type    分类类型
 *  @param success 成功回调 categoryArray 加载得到的分类模型数组
 *  @param failure 失败回调 errorStr      错误字符串,用于提示用户
 */
- (void)fetchUserLocalCategoryType:(IRCategoryType)type WithSuccess:(void (^)(NSMutableArray *categoryArray))success failure:(void (^)(NSString *errorStr))failure;

/**
 *  从网络加载用户添加到主页分类数据
 *
 *  @param type    分类类型
 *  @param success 成功回调 categoryArray 加载得到的分类模型数组
 *  @param failure 失败回调 errorStr      错误字符串,用于提示用户
 */
- (void)fetchUserNetworkCategoryType:(IRCategoryType)type WithSuccess:(void (^)(NSMutableArray *categoryArray))success failure:(void (^)(NSString *errorStr))failure;

/**
 *  批量保存用户常用分类数据到本地
 *
 *  @param categoryArray 待保存分类数组
 *  @param type          分类枚举类型
 *  @param success       成功回调
 *  @param failure       失败回调
 *
 */
- (void)savaUserCategoryData:(NSArray *)categoryArray categoryType:(IRCategoryType)type WithSuccess:(void (^)(NSString *successStr))success failure:(void (^)(NSString *errorStr))failure;

/**
 *  单个保存用户添加 常用分类数据到本地
 *
 *  @param category      待保存分类模型
 *  @param success       成功回调
 *  @param failure       失败回调
 *
 */
- (void)savaUserCategoryData:(IRCategoryModel *)category  WithSuccess:(void (^)(NSString *successStr))success failure:(void (^)(NSString *errorStr))failure;

/**
 *  单个保存用户添加 文章链接 到本地
 *
 *  @param article      待保存分类模型
 *  @param success       成功回调
 *  @param failure       失败回调
 *
 */
- (void)saveUserFavouriteData:(IRArticleModel *)article  WithSuccess:(void (^)(NSString *successStr))success failure:(void (^)(NSString *errorStr))failure;

/**
 *  保存用户喜欢的文章链接
 *
 *  @param title 标题
 *  @param url   链接
 */
- (void)saveUserFavouriteArticleTitle:(NSString *)title ArticleUrl:(NSString *)url WithSuccess:(void (^)(NSString *successStr,IRArticleModel *article))success failure:(void (^)(NSString *errorStr))failure;



/**
 *  删除单个用户分类数据
 *
 *  @param category      待删除分类模型
 *  @param success       成功回调
 *  @param failure       失败回调
 *
 */
- (void)deleteUserCategoryData:(IRCategoryModel *)category  WithSuccess:(void (^)(NSString *successStr))success failure:(void (^)(NSString *errorStr))failure;


/**
 *  根据不同分类 获取不同标题
 */
+ (NSString *)fetchCategoryTitle:(IRCategoryType)categoryDataType;

/**
 *  根据分类模型,获取头像图片
 */
+ (UIImage *)fetchCategoryAvatar:(IRCategoryModel *)category;

@end
