//
//  CategoryCell.h
//  ios reader
//
//  Created by 张李成 on 15-1-31.
//  Copyright (c) 2015年 com.ftxbird. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SWTableViewCell.h>
@class IRCategoryModel;


@interface IRCategoryCell : SWTableViewCell
@property (nonatomic,strong)IRCategoryModel *category;

+ (CGFloat)heightForCellWithCategory:(IRCategoryModel *)category;
@end
