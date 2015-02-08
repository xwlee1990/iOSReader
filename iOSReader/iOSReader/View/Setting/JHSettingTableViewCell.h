//
//  JHSettingTableViewCell.h
//  ios reader
//
//  Created by 李江辉 on 15-2-4.
//  Copyright (c) 2015年 com.ftxbird. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JHSettingTableViewCell;

@protocol JHSettingTableViewCellDelegate <NSObject>

@optional
- (void)settingTableViewCell:(JHSettingTableViewCell *)settingTableViewCell switchTypeChange:(UISwitch *)sender;

@end

@interface JHSettingTableViewCell : UITableViewCell

@property (nonatomic, strong) NSString *cell_type;
@property (nonatomic, strong) NSString *label_text;
@property (nonatomic, strong) NSString *button_text;
@property (nonatomic, assign) BOOL isOpen;

@property (nonatomic, weak) id <JHSettingTableViewCellDelegate>delegate;

+ (instancetype)settingTableViewCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
- (instancetype)initWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

@end
