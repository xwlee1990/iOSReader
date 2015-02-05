//
//  mainCollectionHeaderView.m
//  ios reader
//
//  Created by 张李成 on 15-1-31.
//  Copyright (c) 2015年 com.ftxbird. All rights reserved.
//

#import "IRMainCollectionHeaderView.h"

@interface IRMainCollectionHeaderView ()

@end

@implementation IRMainCollectionHeaderView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (IBAction)OpenCategoryVC:(id)sender {

    if (self.openCaregoryBlock) {
        self.openCaregoryBlock();
    }
    
}


@end
