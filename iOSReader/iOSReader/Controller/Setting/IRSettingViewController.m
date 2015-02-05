//
//  settingViewController.m
//  ios reader
//
//  Created by 张李成   on 15-1-28.
//  Copyright (c) 2015年 com.ftxbird. All rights reserved.
//

#import "IRSettingViewController.h"
#import "IRDefineHeader.h"


@interface IRSettingViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *title_array;

@end

@implementation IRSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViewInfoFunction];
    [self setupTableView];
    
}

- (void)setupViewInfoFunction
{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.title_array = @[
                         @[@{@"title":@"推送设置", @"type":@"Arrow"}],
                         @[
                             @{@"title":@"离线设置", @"type":@"Arrow"},
                             @{@"title":@"仅Wi-Fi网络下载图片", @"type":@"Switch"},
                             @{@"title":@"清理缓存", @"type":@"Label"}
                             ],
                         @[
                             @{@"title":@"帮助与反馈", @"type":@"Arrow"},
                             @{@"title":@"为iOSReader评分", @"type":@"Arrow"},
                             @{@"title":@"关于", @"type":@"Arrow"}
                             ]
                         ];
}

- (void)setupTableView
{
    CGRect tableViewFrame = CGRectMake(0, 0, IRScreenW, IRScreenH);
    UITableView *tableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStyleGrouped];
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
    static NSString * cellIdentify = @"settingCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    
    NSArray *sub_title_array = self.title_array[indexPath.section];
    NSDictionary *dictionary = sub_title_array[indexPath.row];
    
    if ([dictionary[@"type"] isEqualToString:@"Default"]) { // Cell默认格式
        
    }else if ([dictionary[@"type"] isEqualToString:@"Arrow"]){ // 箭头
        
    }else if ([dictionary[@"type"] isEqualToString:@"Switch"]){ // 开关
        
    }else if ([dictionary[@"type"] isEqualToString:@"Label"]){ // 标签
        
    }else{
        
    }
    
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
