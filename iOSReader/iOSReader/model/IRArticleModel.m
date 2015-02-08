//
//  articleModel.m
//  ios reader
//
//  Created by 张李成 on 15-1-26.
//  Copyright (c) 2015年 com.ftxbird. All rights reserved.
//

#import "IRArticleModel.h"

@implementation IRArticleModel

@dynamic articleTitle,articleUrl,articleIndex,articleSubContent,articleImageUrl;

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.articleIndex forKey:@"articleIndex"];
    [aCoder encodeObject:self.articleUrl   forKey:@"articleUrl"];
    [aCoder encodeObject:self.articleTitle forKey:@"articleTitle"];
    [aCoder encodeObject:self.articleSubContent forKey:@"articleSubContent"];
    [aCoder encodeObject:self.articleImageUrl forKey:@"articleImageUrl"];
    
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        self.articleIndex =  [aDecoder decodeObjectForKey:@"articleIndex"];
        self.articleTitle =  [aDecoder decodeObjectForKey:@"articleTitle"];
        self.articleUrl   =  [aDecoder decodeObjectForKey:@"articleUrl"];
        self.articleSubContent   =  [aDecoder decodeObjectForKey:@"articleSubContent"];
        self.articleImageUrl   =  [aDecoder decodeObjectForKey:@"articleImageUrl"];
    }
    return self;
}
@end
