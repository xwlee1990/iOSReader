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

@interface IRSettingViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *title_array;

@end

@implementation IRSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViewInfo];
    [self setupTableView];
    
}

- (void)setupViewInfo
{
    [self.view setBackgroundColor:IRGlobalBg];
    
    NSNumber *imageDownloadSwitchNum = [NSNumber numberWithBool:[UserDefaults boolForKey:@"imageDownloadSwitch"]];
    NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES)objectAtIndex:0];
    
    float cacheSize = [self folderSizeAtPath:cachPath];
    NSString *cacheString = [NSString stringWithFormat:@"%0.1f MB", cacheSize];
    self.title_array = @[
                         @[@{@"title":@"推送设置", @"type":@"Arrow", @"subtype":@""}],
                         @[
                             @{@"title":@"离线设置", @"type":@"Arrow", @"subtype":@"0"},
                             @{@"title":@"仅Wi-Fi网络下载图片", @"type":@"Switch", @"subtype":imageDownloadSwitchNum},
                             @{@"title":@"清理缓存", @"type":@"Label", @"subtype":cacheString}
                             ],
                         @[
                             @{@"title":@"意见反馈", @"type":@"Arrow", @"subtype":@"0"},
                             @{@"title":@"为iOSReader评分", @"type":@"Arrow", @"subtype":@"0"},
                             @{@"title":@"关于", @"type":@"Arrow", @"subtype":@"0"}
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
    
    JHSettingTableViewCell *cell = [JHSettingTableViewCell settingTableViewCellWithTableView:tableView];
    [cell.textLabel setTextColor:IRTextFontColor666];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.cell_type = dictionary[@"type"];
    
    if ([dictionary[@"type"] isEqualToString:@"Label"]) {
        cell.label_text = dictionary[@"subtype"];
    }
    [cell.textLabel setText:dictionary[@"title"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {     //  推送设置
        
        JHSendSettingViewController *sendSettingViewController = [[JHSendSettingViewController alloc] init];
        [self.navigationController pushViewController:sendSettingViewController animated:YES];
        
    }else if (indexPath.section == 1 && indexPath.row == 0){    //  离线阅读设置
        
        JHOfflineBrowsingSettingViewController *offlineBrowsingSettingViewController = [[JHOfflineBrowsingSettingViewController alloc] init];
        [self.navigationController pushViewController:offlineBrowsingSettingViewController animated:YES];
        
    }else if (indexPath.section == 1 && indexPath.row == 2){    //  清理缓存
        
        [self clearInternalStorage];
        
    }else if (indexPath.section == 2 && indexPath.row == 0){    //  意见反馈
        
        JHFeedBackViewController *feedBackViewController = [[JHFeedBackViewController alloc] init];
        [self.navigationController pushViewController:feedBackViewController animated:YES];
        
    }else if (indexPath.section == 2 && indexPath.row == 1){    //  为iOSReader评分
        
    }else if (indexPath.section == 2 && indexPath.row == 2){    //  关于我们
        
        JHAboutMeViewController *aboutMeViewController = [[JHAboutMeViewController alloc] init];
        [self.navigationController pushViewController:aboutMeViewController animated:YES];
        
    }else{
        
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

#pragma mark - ------------------------------缓存清理相关-----------------------
- (void)clearInternalStorage
{
    dispatch_async(
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0)
                   , ^{
                       NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES)objectAtIndex:0];
                       NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
                       NSLog(@"files :%lu",(unsigned long)[files count]);
                       for (NSString *p in files) {
                           NSError *error;
                           NSString *path = [cachPath stringByAppendingPathComponent:p];
                           if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                               [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                           }
                       }
                       [self performSelectorOnMainThread:@selector(clearCacheSuccess)withObject:nil waitUntilDone:YES];});
}

-(void)clearCacheSuccess
{
    [self setupViewInfo];
    [self.tableView reloadData];
    
    
}

//遍历文件夹获得文件夹大小，返回多少M
- (float ) folderSizeAtPath:(NSString*) folderPath{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if (![manager fileExistsAtPath:folderPath]) return 0;
    
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    
    NSString* fileName;
    
    long long folderSize = 0;
    
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
        
    }
    
    return folderSize/(1024.0*1024.0);
    
}

- (long long) fileSizeAtPath:(NSString*) filePath{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:filePath]){
        
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
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
