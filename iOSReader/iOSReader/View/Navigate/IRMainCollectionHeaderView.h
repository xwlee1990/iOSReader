//
//  mainCollectionHeaderView.h
//  ios reader
//
//  Created by 张李成 on 15-1-31.
//  Copyright (c) 2015年 com.ftxbird. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^OpenCategoryBlock)();
@interface IRMainCollectionHeaderView : UICollectionReusableView

/**
 *  header 背景图
 */
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
/**
 *  文字
 */
@property (weak, nonatomic) IBOutlet UILabel *title;
/**
 *  打开分类控制器回调
 */
@property (copy,nonatomic) OpenCategoryBlock openCaregoryBlock;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *roundLabel;
@end
