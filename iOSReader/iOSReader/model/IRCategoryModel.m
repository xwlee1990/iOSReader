//
//  CategoryModel.m
//  ios reader
//
//  Created by 张李成 on 15-1-31.
//  Copyright (c) 2015年 com.ftxbird. All rights reserved.
//

#import "IRCategoryModel.h"

@implementation IRCategoryModel

@dynamic categoryIndex,categoryUrl,categoryTitle,categoryType;

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.categoryIndex forKey:@"categoryIndex"];
    [aCoder encodeObject:self.categoryUrl   forKey:@"categoryUrl"];
    [aCoder encodeObject:self.categoryTitle forKey:@"categoryTitle"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
      self.categoryIndex =  [aDecoder decodeObjectForKey:@"categoryIndex"];
      self.categoryTitle =  [aDecoder decodeObjectForKey:@"categoryTitle"];
      self.categoryUrl   =  [aDecoder decodeObjectForKey:@"categoryUrl"];
    }
    return self;
}
@end
