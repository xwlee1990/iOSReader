//
//  JHOfflineBrowsingSettingViewController.m
//  ios reader
//
//  Created by 李江辉 on 15-2-5.
//  Copyright (c) 2015年 com.ftxbird. All rights reserved.
//

#import "JHOfflineBrowsingSettingViewController.h"
#import "IRDefineHeader.h"

#import "JHSettingTableViewCell.h"
#import "JHOfflineBrowsingSettingViewController.h"

@interface JHOfflineBrowsingSettingViewController ()<UITableViewDataSource, UITableViewDelegate, JHSettingTableViewCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *title_array;

@end

@implementation JHOfflineBrowsingSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViewInfo];
    
    [self setupTableView];
}

- (void)setupViewInfo
{
    [self.view setBackgroundColor:IRGlobalBg];
    [self.navigationItem setTitle:@"离线设置"];
    
    NSNumber *blogDownloadSwitchNum = [NSNumber numberWithBool:[UserDefaults boolForKey:@"blogDownloadSwitch"]];
    NSNumber *webDownloadSwitchNum = [NSNumber numberWithBool:[UserDefaults boolForKey:@"webDownloadSwitch"]];
    NSNumber *openDownloadSwitchNum = [NSNumber numberWithBool:[UserDefaults boolForKey:@"openDownloadSwitch"]];
    
    self.title_array = @[
                         @{@"title":@"博客离线阅读", @"type":@"Switch", @"subtype":blogDownloadSwitchNum},
                         @{@"title":@"网站离线阅读", @"type":@"Switch", @"subtype":webDownloadSwitchNum},
                         @{@"title":@"开源离线阅读", @"type":@"Switch", @"subtype":openDownloadSwitchNum}
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
        [UserDefaults setBool:sender.isOn forKey:@"blogDownloadSwitch"];
        
    }else if (sender.tag == 1){ // 网站推送
        [UserDefaults setBool:sender.isOn forKey:@"webDownloadSwitch"];
        
    }else{  // 开源推送
        [UserDefaults setBool:sender.isOn forKey:@"openDownloadSwitch"];
        
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
