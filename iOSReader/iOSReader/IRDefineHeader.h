//
//  IRDefineHeader.h
//  ios reader
//
//  Created by 张李成 on 15-1-26.
//  Copyright (c) 2015年 com.ftxbird. All rights reserved.
//


//设备
#define IRScreenH  [[UIScreen mainScreen] bounds].size.height
#define IRScreenW  [[UIScreen mainScreen] bounds].size.width

//  默认数据库
#define UserDefaults [NSUserDefaults standardUserDefaults]

//  版本号
#define AppVersion [[NSBundle mainBundle] objectForInfoDictionaryKey:CFBridgingRelease(kCFBundleVersionKey)]

//颜色
#define IRColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]  //  获得RGB颜色
#define IRGlobalBg IRColor(245, 245, 245)   //  全局视图背景色
#define IRBorderColor IRColor(204, 204, 204) // 边框颜色
#define IRTextFontColor333 IRColor(51, 51, 51)
#define IRTextFontColor666 IRColor(102, 102, 102)
#define IRTextFontColor999 IRColor(153, 153, 153)

//字体

//log
#define NSLogRect(rect) NSLog(@"%s x:%.4f, y:%.4f, w:%.4f, h:%.4f", #rect, rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)
#define NSLogSize(size) NSLog(@"%s w:%.4f, h:%.4f", #size, size.width, size.height)
#define NSLogPoint(point) NSLog(@"%s x:%.4f, y:%.4f", #point, point.x, point.y)

#ifndef weakify

#define weakify(o) __typeof__(o) __weak o##__weak_ = o;
#define strongify(o) __typeof__(o##__weak_) __strong o = o##__weak_;

#endif


