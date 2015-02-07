//
//  JHSettingTableViewCell.h
//  ios reader
//
//  Created by 李江辉 on 15-2-4.
//  Copyright (c) 2015年 com.ftxbird. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHSettingTableViewCell : UITableViewCell

@property (nonatomic, strong) NSString *cell_type;
@property (nonatomic, strong) NSString *label_text;
@property (nonatomic, strong) NSString *button_text;

+ (instancetype)settingTableViewCellWithTableView:(UITableView *)tableView;
- (instancetype)initWithTableView:(UITableView *)tableView;

+ (instancetype)settingTableViewCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
- (instancetype)initWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

@end
