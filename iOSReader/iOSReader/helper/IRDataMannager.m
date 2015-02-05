//
//  ReaderDataMannager.m
//  ios reader
//
//  Created by 张李成 on 15-2-1.
//  Copyright (c) 2015年 com.ftxbird. All rights reserved.
//

#import "IRDataMannager.h"
#import <TMCache.h>
@implementation IRDataMannager



+ (IRDataMannager *)sharedManager
{
    static IRDataMannager *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}

/**
 *  初始化用户数据
 */
+ (NSMutableArray *)initUserData
{
    NSMutableArray *userBlogArray = [[TMCache sharedCache] objectForKey:@"userBlog"];
    if (!userBlogArray) {
        userBlogArray = [NSMutableArray array];
        [[TMCache sharedCache] setObject:userBlogArray forKey:@"userBlog"];
    }
    NSMutableArray *userWebArray = [[TMCache sharedCache] objectForKey:@"userWeb"];
    if (!userWebArray) {
        userWebArray = [NSMutableArray array];
        [[TMCache sharedCache] setObject:userBlogArray forKey:@"userWeb"];
    }
    NSMutableArray *userGithubArray = [[TMCache sharedCache] objectForKey:@"userGithub"];
    if (!userGithubArray) {
        userGithubArray = [NSMutableArray array];
        [[TMCache sharedCache] setObject:userBlogArray forKey:@"userGithub"];
    }
    
     return [[NSMutableArray arrayWithObjects:userBlogArray,userWebArray,userGithubArray, nil] mutableCopy];
}
#pragma mark - 从本地加载

/**
 *  从本地加载缓存程序分类数据
 *
 *  @param type    分类类型
 *  @param success 成功回调 categoryArray 加载得到的分类模型数组
 *  @param failure 失败回调 errorStr      错误字符串,用于提示用户
 */
- (void)fetchLocalCategoryType:(IRCategoryType)type WithSuccess:(void (^)(NSMutableArray *categoryArray))success failure:(void (^)(NSString *errorStr))failure
{
    //从本地
    NSString *fileName;
    switch (type) {
        case IRCategoryTypeBlog:
            fileName = @"CategoryBlogModel";
            break;
        case IRCategoryTypeWeb:
            fileName = @"CategoryWebsiteModel";
            break;
        case IRCategoryTypeGitHub:
            fileName = @"CategoryGithubModel";
            break;
        default:
            break;
    }
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
    
    NSArray *data = [[NSArray alloc] initWithContentsOfFile:plistPath];
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in data) {
        IRCategoryModel * category = [IRCategoryModel new];
        category.categoryTitle = dic[@"categoryTitle"];
        category.categoryUrl= dic[@"categoryUrl"];
        category.categoryType = [dic[@"categoryType"] integerValue];
        category.categoryIndex = dic[@"categoryIndex"];
        [tempArray addObject:category];
    }
    if (tempArray.count) {
        success([tempArray copy]);
    }else
        failure(@"加载本地数据失败");
}


/**
 *  从网络加载缓存程序分类数据
 *
 *  @param type    分类类型
 *  @param success 成功回调 categoryArray 加载得到的分类模型数组
 *  @param failure 失败回调 errorStr      错误字符串,用于提示用户
 */
- (void)fetchNetworkCategoryType:(IRCategoryType)type WithSuccess:(void (^)(NSMutableArray *categoryArray))success failure:(void (^)(NSString *errorStr))failure
{

}

/**
 *  从本地加载用户添加到主页分类数据
 *
 *  @param type    分类类型
 *  @param success 成功回调 categoryArray 加载得到的分类模型数组
 *  @param failure 失败回调 errorStr      错误字符串,用于提示用户
 */
- (void)fetchUserLocalCategoryType:(IRCategoryType)type WithSuccess:(void (^)(NSMutableArray *categoryArray))success failure:(void (^)(NSString *errorStr))failure
{


}

/**
 *  从网络加载用户添加到主页分类数据
 *
 *  @param type    分类类型
 *  @param success 成功回调 categoryArray 加载得到的分类模型数组
 *  @param failure 失败回调 errorStr      错误字符串,用于提示用户
 */
- (void)fetchUserNetworkCategoryType:(IRCategoryType)type WithSuccess:(void (^)(NSMutableArray *categoryArray))success failure:(void (^)(NSString *errorStr))failure
{


}

/**
 *  批量保存用户常用分类数据到本地
 *
 *  @param categoryArray 待保存分类数组
 *  @param type          分类枚举类型
 *  @param success       成功回调
 *  @param failure       失败回调
 *
 */
- (void)savaUserCategoryData:(NSArray *)categoryArray categoryType:(IRCategoryType)type WithSuccess:(void (^)(NSString *successStr))success failure:(void (^)(NSString *errorStr))failure
{

}

/**
 *  单个保存用户添加 常用分类数据到本地
 *
 *  @param category      待保存分类模型
 *  @param success       成功回调
 *  @param failure       失败回调
 *
 */
- (void)savaUserCategoryData:(IRCategoryModel *)category  WithSuccess:(void (^)(NSString *successStr))success failure:(void (^)(NSString *errorStr))failure
{
    NSString *key =nil;
    switch (category.categoryType) {
        case IRCategoryTypeBlog:
            key = @"userBlog";
            break;
        case IRCategoryTypeWeb:
            key = @"userWeb";
            break;
        case IRCategoryTypeGitHub:
            key = @"userGithub";
            break;
        default:
            break;
    }
    __block BOOL contains = NO;
    TMCache *cache = [TMCache sharedCache];
    NSMutableArray *tempArray = [cache objectForKey:key];
    
    [tempArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        IRCategoryModel *cate = obj;
        if ([cate.categoryIndex isEqualToString:category.categoryIndex]) {
            contains = YES;
            *stop=YES;
            failure(@"已添加该对象");
            
            
        }
        
    }];
    if (!contains) {
        [tempArray addObject:category];
        [cache setObject:tempArray forKey:key];
        success(@"保存成功");
    }
    

}

/**
 *  根据不同分类 获取不同标题
 */
+ (NSString *)fetchCategoryTitle:(IRCategoryType)categoryDataType
{
    NSString *CategoryTitle;
    switch (categoryDataType) {
        case IRCategoryTypeBlog:
            CategoryTitle = @"博客";
            break;
        case IRCategoryTypeWeb:
            CategoryTitle = @"网站";
            break;
        case IRCategoryTypeGitHub:
            CategoryTitle = @"开源库";
            break;
        default:
            break;
    }
    return CategoryTitle;
}


/**
 *  根据分类模型,获取头像图片
 */
+ (UIImage *)fetchCategoryAvatar:(IRCategoryModel *)category
{
    UIImage * avatarImage=[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:category.categoryIndex ofType:@"jpg"]];
    return avatarImage==nil?[UIImage imageNamed:@"IRdefaultAvatar"]:avatarImage;
}
@end
