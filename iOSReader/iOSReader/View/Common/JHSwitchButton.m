//
//  JHSwitchButton.m
//  ios reader
//
//  Created by 李江辉 on 15-1-29.
//  Copyright (c) 2015年 com.ftxbird. All rights reserved.
//

#import "JHSwitchButton.h"

@implementation JHSwitchButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 图标居中
        self.imageView.contentMode = UIViewContentModeCenter;
        // 文字居中
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return self;
}

// 重写去掉高亮状态
- (void)setHighlighted:(BOOL)highlighted {}

// 内部图片的frame
//- (CGRect)imageRectForContentRect:(CGRect)contentRect
//{
//}

// 内部文字的frame
//- (CGRect)titleRectForContentRect:(CGRect)contentRect
//{
//}


@end
