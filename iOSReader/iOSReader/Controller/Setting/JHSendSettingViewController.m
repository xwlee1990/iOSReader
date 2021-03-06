//
//  JHSendSettingViewController.m
//  ios reader
//
//  Created by 李江辉 on 15-2-4.
//  Copyright (c) 2015年 com.ftxbird. All rights reserved.
//

#import "JHSendSettingViewController.h"
#import "IRDefineHeader.h"

#import "JHSettingTableViewCell.h"

@interface JHSendSettingViewController ()<UITableViewDataSource, UITableViewDelegate, JHSettingTableViewCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *title_array;
@end

@implementation JHSendSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViewInfo];
    
    [self setupTableView];
    
}

- (void)setupViewInfo
{
    [self.view setBackgroundColor:IRGlobalBg];
    [self.navigationItem setTitle:@"推送设置"];
    
    NSNumber *blogSendSwitchNum = [NSNumber numberWithBool:[UserDefaults boolForKey:@"blogSendSwitch"]];
    //    NSNumber *webSendSwitchNum = [NSNumber numberWithBool:[UserDefaults boolForKey:@"webSendSwitch"]];
    //    NSNumber *openSendSwitchNum = [NSNumber numberWithBool:[UserDefaults boolForKey:@"openSendSwitch"]];
    
    self.title_array = @[
                         /*
                          @{@"title":@"博客推送", @"type":@"Switch", @"subtype":blogSendSwitchNum},
                          @{@"title":@"网站推送", @"type":@"Switch", @"subtype":webSendSwitchNum},
                          @{@"title":@"开源推送", @"type":@"Switch", @"subtype":openSendSwitchNum}
                          */
                         @{@"title":@"消息推送", @"type":@"Switch", @"subtype":blogSendSwitchNum}
                         ];
    
}

- (void)setupTableView
{
    CGRect tableViewFrame = CGRectMake(0, 0, IRScreenW, IRScreenH);
    UITableView *tableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStyleGrouped];
    [tableView setBackgroundColor:IRGlobalBg];
    self.tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
}

#pragma mark - --------------UITableViewDelegate---------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.title_array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dictionary = self.title_array[indexPath.row];
    
    JHSettingTableViewCell *cell = [JHSettingTableViewCell settingTableViewCellWithTableView:tableView indexPath:indexPath];
    cell.delegate = self;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.cell_type = dictionary[@"type"];
    cell.isOpen = [dictionary[@"subtype"] boolValue];
    [cell.textLabel setText:dictionary[@"title"]];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return FLT_MIN;
}

- (void)settingTableViewCell:(JHSettingTableViewCell *)settingTableViewCell switchTypeChange:(UISwitch *)sender
{
    if (sender.tag == 0) {  // 微博推送
        [UserDefaults setBool:sender.isOn forKey:@"blogSendSwitch"];
        
    }else if (sender.tag == 1){ // 网站推送
        [UserDefaults setBool:sender.isOn forKey:@"webSendSwitch"];
        
    }else{  // 开源推送
        [UserDefaults setBool:sender.isOn forKey:@"openSendSwitch"];
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
