//
//  mainCollectionViewCell.h
//  ios reader
//
//  Created by 张李成 on 15-1-31.
//  Copyright (c) 2015年 com.ftxbird. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IRCategoryModel;
typedef void (^cellLongPressHandle)();
@interface IRMainCollectionViewCell : UICollectionViewCell
/**
 *  标题
 */
@property (nonatomic, weak) IBOutlet UILabel *itemTitle;
/**
 *  头像
 */
@property (nonatomic, weak) IBOutlet UIImageView *itemImageView;

@property (weak, nonatomic) IBOutlet UIButton *deleteIcon;

@property (nonatomic, strong)IRCategoryModel *category;

@property (nonatomic, copy)cellLongPressHandle cellLongPressHandel;

@end
