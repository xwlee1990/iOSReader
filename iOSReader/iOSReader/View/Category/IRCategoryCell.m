//
//  CategoryCell.m
//  ios reader
//
//  Created by 张李成 on 15-1-31.
//  Copyright (c) 2015年 com.ftxbird. All rights reserved.
//

#import "IRCategoryCell.h"
#import "IRCategoryModel.h"
#import "UIView+Positioning.h"
#import "IRDataMannager.h"
#define kCategoryCellLeftPading 20
#define kCategoryCellTopPading  10
#define kCategoryCellHeadViewWidth 50
#define kCategoryCellHeadViewHeight 50
@interface UIColor (RandomColor)
+(UIColor *) randomColor;
@end

@implementation UIColor (RandomColor)

+(UIColor *) randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 ); //0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5; // 0.5 to 1.0,away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5; //0.5 to 1.0,away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}
@end
    
    
@interface IRCategoryCell ()

@property (nonatomic,strong)UIImageView *categoryHeadView;
@property (nonatomic,strong)UILabel *categoryNameLabel;
@end

@implementation IRCategoryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.detailTextLabel.hidden = YES;
        self.textLabel.hidden = YES;
        
        //添加头像
        self.categoryHeadView = [[UIImageView alloc] init];
        [self.contentView addSubview:_categoryHeadView];
        self.categoryHeadView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(categoryHeadViewClick)];
        tapGesture1.numberOfTapsRequired = 1;
        tapGesture1.numberOfTouchesRequired = 1;
        [self.categoryHeadView addGestureRecognizer:tapGesture1];
        
        //添加标题
        self.categoryNameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        self.categoryNameLabel.backgroundColor = [UIColor clearColor];
        //self.categoryNameLabel.textColor = kCategoryCellcategoryNameColor;
        //self.categoryNameLabel.font = kCategoryCellcategoryNameFont;
        [self.contentView addSubview:_categoryNameLabel];
        
        

    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
   self.categoryHeadView.frame =CGRectMake(kCategoryCellLeftPading, kCategoryCellTopPading, kCategoryCellHeadViewWidth, kCategoryCellHeadViewHeight);
    //self.categoryHeadView.layer.masksToBounds = YES;
   // self.categoryHeadView.layer.cornerRadius = kCategoryCellHeadViewWidth/ 2.0f;
    self.categoryHeadView.image = [IRDataMannager fetchCategoryAvatar:self.category];
    self.categoryNameLabel.text = self.category.categoryTitle;
    [self.categoryNameLabel sizeToFit];
    self.categoryNameLabel.left = self.categoryHeadView.right + 20;
    self.categoryNameLabel.top = kCategoryCellHeadViewWidth/2;
}

+ (CGFloat)heightForCellWithCategory:(IRCategoryModel *)category
{
    return kCategoryCellHeadViewHeight + kCategoryCellTopPading*2;
}

- (void)categoryHeadViewClick
{
    NSLog(@"头像点击");
}

@end
