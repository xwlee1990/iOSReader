//
//  UIColor+JH.h
//  ios reader
//
//  Created by 李江辉 on 15-1-29.
//  Copyright (c) 2015年 com.ftxbird. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (JH)

/**
 *  颜色转换 IOS中十六进制的颜色转换为UIColor
 *
 *  @param color 颜色十六进制字符串
 *
 *  @return UIColor
 */
+ (UIColor *) colorWithHexString: (NSString *)color;

@end
