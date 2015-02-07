//
//  JHSettingTableViewCell.m
//  ios reader
//
//  Created by 李江辉 on 15-2-4.
//  Copyright (c) 2015年 com.ftxbird. All rights reserved.
//

#import "JHSettingTableViewCell.h"
#import "IRDefineHeader.h"
@interface JHSettingTableViewCell ()

@property (nonatomic, strong) UILabel *myLabel;
@property (nonatomic, strong) UIButton *myButton;
@property (nonatomic, strong) UISwitch *mySwitch;

@property (nonatomic, strong) NSIndexPath *indexPath;

@end

@implementation JHSettingTableViewCell

+ (instancetype)settingTableViewCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    return [[JHSettingTableViewCell alloc] initWithTableView:tableView indexPath:indexPath];
}

- (instancetype)initWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    self = [[JHSettingTableViewCell alloc] init];
    
    self.indexPath = indexPath;
    
    return self;
}

+ (instancetype)settingTableViewCellWithTableView:(UITableView *)tableView
{
    return [[JHSettingTableViewCell alloc] initWithTableView:tableView];
}

- (instancetype)initWithTableView:(UITableView *)tableView
{
    self = [[JHSettingTableViewCell alloc] init];
    
    return self;
}

- (void)setupContentWithType:(NSString *)type
{
    if ([type isEqualToString:@"Arrow"]) {              // 箭头
        
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        
    }else if ([type isEqualToString:@"Switch"]){    // 开关
        UISwitch *mySwitch = [[UISwitch alloc] init];
        self.mySwitch = mySwitch;
        [mySwitch setOn:YES animated:NO];//设置初始为ON的一边
        [mySwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        [self.contentView addSubview:mySwitch];
        
    }else if ([type isEqualToString:@"Label"]){     // 标签
        
        UILabel *label =[[UILabel alloc] init];
        [label setTextAlignment:NSTextAlignmentRight];
        [label setTextColor:IRTextFontColor666];
        self.myLabel = label;
        [label setText:@"标签"];
        [self.contentView addSubview:label];
        
    }else if ([type isEqualToString:@"Button"]){    // 按钮
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        self.myButton = button;
        [button setTitle:@"按钮" forState:UIControlStateNormal];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
        [button addTarget:self action:@selector(buttonClickedToAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
        
    }else{      // 空白
        
        [self setAccessoryType:UITableViewCellAccessoryNone];
        
    }
    
}

- (void)buttonClickedToAction
{
    NSLog(@"-------------------------------");
}

- (void)switchAction:(UISwitch *)sender
{
    NSLog(@"----------%d---------", sender.on);
}

// 设置Cell的类型
- (void)setCell_type:(NSString *)cell_type
{
    _cell_type = cell_type;
    // 初始化内容
    [self setupContentWithType:cell_type];
}

// 设置标签内容
- (void)setLabel_text:(NSString *)label_text
{
    _label_text = label_text;
    [self.myLabel setText:label_text];
    
}

// 设置按钮标题
-(void)setButton_text:(NSString *)button_text
{
    _button_text = button_text;
    [self.myButton setTitle:button_text forState:UIControlStateNormal];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.myLabel setFrame:CGRectMake(self.contentView.frame.size.width - 110, 0, 100, self.contentView.frame.size.height)];
    [self.myButton setFrame:CGRectMake(self.contentView.frame.size.width - 60, 0, 50, self.contentView.frame.size.height)];
    [self.mySwitch setFrame:CGRectMake(self.contentView.frame.size.width - 61, 6.5f, 0, 0)];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
