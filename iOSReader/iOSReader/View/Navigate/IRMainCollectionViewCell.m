//
//  mainCollectionViewCell.m
//  ios reader
//
//  Created by 张李成 on 15-1-31.
//  Copyright (c) 2015年 com.ftxbird. All rights reserved.
//

#import "IRMainCollectionViewCell.h"
#import "IRCategoryModel.h"
#import "IRDataMannager.h"
@implementation IRMainCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.deleteIcon.hidden = YES;

}


- (void)layoutSubviews
{
    [super layoutSubviews];
    self.itemTitle.text = self.category.categoryTitle;
    self.itemImageView.image = [IRDataMannager fetchCategoryAvatar:self.category];

}

- (IBAction)deleteAction:(id)sender {
    
    if (self.cellLongPressHandel) {
        self.cellLongPressHandel();
        self.deleteIcon.hidden = YES;
    }
    
}


@end
