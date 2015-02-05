//
//  categoryTableViewController.h
//  ios reader
//
//  Created by 张李成 on 15-1-29.
//  Copyright (c) 2015年 com.ftxbird. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IRCategoryModel;
/**
 *  该控制器是由 首页三个button 点击进来的 通过传不同的数组 进行显示.
 */
typedef void (^AddToMainBlock)(IRCategoryModel *addModel);
@interface IRCategoryTableViewController : UITableViewController

/**
 *  首页传过来的数组
 */
@property (nonatomic, strong) NSArray *categoryArray;
@property (nonatomic, copy)AddToMainBlock addToMainBlock;
@property (nonatomic, assign)NSInteger categoryType;

@end
