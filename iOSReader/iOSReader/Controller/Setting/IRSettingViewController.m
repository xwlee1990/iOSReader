//
//  settingViewController.m
//  ios reader
//
//  Created by 张李成   on 15-1-28.
//  Copyright (c) 2015年 com.ftxbird. All rights reserved.
//

#import "IRSettingViewController.h"
#import "IRDefineHeader.h"
#import "JHSettingTableViewCell.h"
#import "JHSendSettingViewController.h"
#import "JHOfflineBrowsingSettingViewController.h"
#import "JHFeedBackViewController.h"
#import "JHAboutMeViewController.h"
#import "IRClearCache.h"
#import "SVProgressHUD.h"
/**
 *  定义设置类型枚举
 */
typedef NS_ENUM(NSInteger, IRSettingType){
    /** 推送设置 */
    IRSettingTypePush = 1,
    /** 仅WIFI下载图片 */
    IRSettingTypeDownload,
    /** 清除缓存 */
    IRSettingTypeClearCache,
    /** 意见反馈 */
    IRSettingTypeFeedback,
    /** 评分 */
    IRSettingTypeRate,
    /** 关于 */
    IRSettingTypeAbout
};
@interface IRSettingViewController ()<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate,JHSettingTableViewCellDelegate, IRClearCacheDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *title_array;

@end

@implementation IRSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViewInfo];
    [self setupTableView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupViewInfo];
    [self.tableView reloadData];
    
}

- (void)setupViewInfo
{
    [self.view setBackgroundColor:IRGlobalBg];
    
    NSNumber *imageDownloadSwitchNum = [NSNumber numberWithBool:[UserDefaults boolForKey:@"imageDownloadSwitch"]];
    
    // 显示缓存
    NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES)objectAtIndex:0];
    CGFloat cacheSize = [IRClearCache folderSizeAtPath:cachPath];
    NSString *cacheString = [NSString stringWithFormat:@"%0.1f MB", cacheSize];
    
    self.title_array = @[
                         @[
                             @{@"title":@"推送设置",
                               @"type":@"Arrow",
                               @"subtype":@"",
                               @"done":@(IRSettingTypePush)}],
                         
                         @[
                             @{@"title":@"仅Wi-Fi网络下载图片",
                               @"type":@"Switch",
                               @"subtype":imageDownloadSwitchNum,
                               @"done":@(IRSettingTypeDownload)},
                           
                             @{@"title":@"清理缓存",
                               @"type":@"Label",
                               @"subtype":cacheString,
                               @"done":@(IRSettingTypeClearCache)}],
                         
                         @[
                             @{@"title":@"意见反馈",
                               @"type":@"Arrow",
                               @"subtype":@"0",
                               @"done":@(IRSettingTypeFeedback)},
                             
                             @{@"title":@"为iOSReader评分",
                               @"type":@"Arrow",
                               @"subtype":@"0",
                               @"done":@(IRSettingTypeRate)},
                             
                             @{@"title":@"关于",
                               @"type":@"Arrow",
                               @"subtype":@"0",
                               @"done":@(IRSettingTypeAbout)}
                             ]
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
    return self.title_array.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *sub_title_array = self.title_array[section];
    return sub_title_array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *sub_title_array = self.title_array[indexPath.section];
    NSDictionary *dictionary = sub_title_array[indexPath.row];
    
    JHSettingTableViewCell *cell = [JHSettingTableViewCell settingTableViewCellWithTableView:tableView indexPath:indexPath];
    [cell.textLabel setTextColor:IRTextFontColor666];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.cell_type = dictionary[@"type"];
    [cell.textLabel setText:dictionary[@"title"]];
    
    if ([dictionary[@"type"] isEqualToString:@"Label"]) {
        cell.label_text = dictionary[@"subtype"];
    }else if ([dictionary[@"type"] isEqualToString:@"Switch"]){
        cell.isOpen = [dictionary[@"subtype"] boolValue];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSArray *sub_title_array = self.title_array[indexPath.section];
    NSDictionary *dictionary = sub_title_array[indexPath.row];
    NSInteger SettingType = [dictionary[@"done"] integerValue];
    
    
    switch (SettingType) {
            
        case IRSettingTypePush:   //推送
        {
            JHSendSettingViewController *sendSettingViewController = [[JHSendSettingViewController alloc] init];
            [self.navigationController pushViewController:sendSettingViewController animated:YES];
        }
            break;
            
        case IRSettingTypeDownload: //下载
        {
            JHOfflineBrowsingSettingViewController *offlineBrowsingSettingViewController = [[JHOfflineBrowsingSettingViewController alloc] init];
            [self.navigationController pushViewController:offlineBrowsingSettingViewController animated:YES];
        }
            break;
            
        case IRSettingTypeClearCache: //清理缓存
        {
            UIActionSheet *actionSheet =
            [[UIActionSheet alloc] initWithTitle:nil delegate:self
            cancelButtonTitle:@"取消"  destructiveButtonTitle:@"清理"
             otherButtonTitles:nil, nil];
            [actionSheet showInView:self.view];
        }
            break;
            
        case IRSettingTypeFeedback: //意见反馈
        {
            JHFeedBackViewController *feedBackViewController = [[JHFeedBackViewController alloc] init];
            [self.navigationController pushViewController:feedBackViewController animated:YES];
        
        }
            break;
        case IRSettingTypeRate:  //评分
        {

        }
            break;
            
        case IRSettingTypeAbout: //关于
        {
            JHAboutMeViewController *aboutMeViewController = [[JHAboutMeViewController alloc] init];
            [self.navigationController pushViewController:aboutMeViewController animated:YES];
        }
            break;
        default:
            break;
    }

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

#pragma mark - ------------------------------其他代理方法-----------------------
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        // 清除缓存
        IRClearCache *clearCache = [[IRClearCache alloc] init];
        clearCache.delegate = self;
        [clearCache clearCache];
    }
}

- (void)settingTableViewCell:(JHSettingTableViewCell *)settingTableViewCell switchTypeChange:(UISwitch *)sender
{
    [UserDefaults setBool:sender.isOn forKey:@"imageDownloadSwitch"];
}

- (void)clearCache:(IRClearCache *)clearCache didClearCacheInfo:(NSString *)info
{
    [self setupViewInfo];
    
    [self.tableView reloadData];
    [SVProgressHUD showSuccessWithStatus:@"清理成功"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
