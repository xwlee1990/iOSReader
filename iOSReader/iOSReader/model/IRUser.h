//
//  IRUser.h
//  iOSReader
//
//  Created by ftxbird on 15-2-10.
//  Copyright (c) 2015年 ftxbird. All rights reserved.
//
#import <AVOSCloud/AVOSCloud.h>
#import <Foundation/Foundation.h>

@interface IRUser : AVObject<AVSubclassing>

/**
 *  用户id
 */
@property (nonatomic, copy) NSString *userId;

/**
 *  用户昵称
 */
@property (nonatomic ,copy) NSString * userName;

@end
