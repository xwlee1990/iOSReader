//
//  JHPlaceHolderTextView.h
//  ios reader
//
//  Created by 李江辉 on 15-2-5.
//  Copyright (c) 2015年 com.ftxbird. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHPlaceHolderTextView : UITextView

/** 提示信息 */
@property (nonatomic, strong) NSString *placeholder;

/** 提示信息颜色 */
@property (nonatomic, strong) UIColor *placeholderColor;

@end
