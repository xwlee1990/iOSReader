//
//  IRDataHelper.m
//  ios reader
//
//  Created by 张李成 on 15-1-31.
//  Copyright (c) 2015年 com.ftxbird. All rights reserved.
//

#import "IRAVOSHelper.h"
#import <objc/runtime.h>
@implementation IRAVOSHelper


/**
 *  保存单个模型到AVCloud
 */
+ (void)saveModel:(AVObject *)object
{
//    unsigned int outCount, i;
//    objc_property_t *properties = class_copyPropertyList([object class], &outCount);
//    AVObject *av=[AVObject objectWithClassName:NSStringFromClass([object class])];
//    for (i = 0; i<outCount; i++)
//    {
//        objc_property_t property = properties[i];
//        const char* char_f =property_getName(property);
//        NSString *propertyName = [NSString stringWithUTF8String:char_f];
//        id propertyValue = [object valueForKey:(NSString *)propertyName];
//        [av setObject:propertyValue forKey:propertyName];
//    }

    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        NSString *msg=nil;
        if (succeeded) {
            msg=[NSString stringWithFormat:@"创建成功: %@",[object description]];
            
        }else{
            msg=[NSString stringWithFormat:@"创建失败: %@",[error description]];
        }
        NSLog(@"%@",msg);
    }];

}

/**
 *  更新单个模型到AVCloud
 */
+ (void)updateModel:(AVObject *)object
{


}
@end
