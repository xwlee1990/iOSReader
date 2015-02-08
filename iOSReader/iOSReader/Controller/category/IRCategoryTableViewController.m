//
//  categoryTableViewController.m
//  ios reader
//
//  Created by 张李成 on 15-1-29.
//  Copyright (c) 2015年 com.ftxbird. All rights reserved.
//

#import "IRCategoryTableViewController.h"
#import "IRCategoryModel.h"
#import "KINWebBrowserViewController.h"
#import "IRCategoryCell.h"
#import <SWTableViewCell.h>
#import "IRDataMannager.h"
#import "IRDefineHeader.h"

@interface IRCategoryTableViewController ()<SWTableViewCellDelegate
,UISearchResultsUpdating, UISearchBarDelegate,KINWebBrowserDelegate>

@property (nonatomic, strong) UISearchController *searchController; // 搜索控制器
@property (nonatomic, strong) NSMutableArray *searchResults;        // 搜索结果数组

@end


@implementation IRCategoryTableViewController

#pragma mark - 控制器初始化

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSearchController];
}


- (void)setupSearchController
{
    self.searchResults = [NSMutableArray arrayWithCapacity:[self.categoryArray count]];
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    
    self.searchController.searchResultsUpdater = self;
    
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    
    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
    
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    self.definesPresentationContext = YES;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}


#pragma mark - 获取本地数据
/**
 *  根据首页不同分组 加载不同数据
 */
- (NSArray *)categoryArray
{
    if (!_categoryArray) {
        
        weakify(self);
       [[IRDataMannager sharedManager] fetchLocalCategoryType:self.categoryType WithSuccess:^(NSMutableArray *categoryArray) {
           strongify(self);
           self.categoryArray = categoryArray;
       } failure:^(NSString *errorStr) {
           NSLog(@"%@",errorStr);
       }];
    }
    
    return _categoryArray;
    
}
#pragma mark - TableView数据源和代理方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.searchController.active) {
        return [self.searchResults count];
    } else {
        return [self.categoryArray count];
    }
}

/**
 *  根据indexpath 取模型
 *
 *  @param indexPath indexpath
 *
 *  @return CategoryModel * 模型
 */
- (IRCategoryModel *)currentIndexModel:(NSIndexPath*)indexPath
{
    IRCategoryModel *category;
    
    if (self.searchController.active) {
        category = [self.searchResults objectAtIndex:indexPath.row];
    } else {
        category = [self.categoryArray objectAtIndex:indexPath.row];
    }

    return category;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IRCategoryModel *category = [self currentIndexModel:indexPath];
    return [IRCategoryCell heightForCellWithCategory:category];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    static NSString *CellIdentifier  = @"identyCategoryCell";
    IRCategoryCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
       cell = [[IRCategoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
       cell.leftUtilityButtons = [self leftButtons];
       cell.rightUtilityButtons =[self rightButtons];
       cell.delegate = self;
    }
    IRCategoryModel *category = [self currentIndexModel:indexPath];
    cell.category = category;
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    IRCategoryModel * category = [self currentIndexModel:indexPath];
    
    KINWebBrowserViewController *webBrowser = [KINWebBrowserViewController webBrowser];
    [webBrowser setDelegate:self];
    webBrowser.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:webBrowser animated:YES];
    
    if (category.categoryUrl) {
        [webBrowser loadURLString:category.categoryUrl];
    }
    
}

#pragma mark - UISearchResultsUpdating

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    NSString *searchString = [self.searchController.searchBar text];

    [self updateFilteredContentForArticleName:searchString];
    
    [self.tableView reloadData];
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    [self updateSearchResultsForSearchController:self.searchController];
}


#pragma mark - Content Filtering

- (void)updateFilteredContentForArticleName:(NSString *)articleName{
    
    // 根据搜索字符串更新结果集
    if ((articleName == nil) || [articleName length] == 0) {

        return;
    }
    // 清空之前的数组
    [self.searchResults removeAllObjects];
    
    // 遍历categoryArray匹配搜索字符串,添加匹配项到数组中.
    for (IRCategoryModel *category in self.categoryArray) {
       
            NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
            NSRange categoryNameRange = NSMakeRange(0, category.categoryTitle.length);
            NSRange foundRange = [category.categoryTitle rangeOfString:articleName options:searchOptions range:categoryNameRange];
            if (foundRange.length > 0) {
                [self.searchResults addObject:category];
            }
    }
}

#pragma mark - SWTableViewDelegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index
{
    IRCategoryCell *cateCell = (IRCategoryCell *)cell;
    switch (index) {
        //添加操作
        case 0:
           // if (self.addToMainBlock)
        {
                //关闭按钮
                [cateCell hideUtilityButtonsAnimated:YES];
                
                [[IRDataMannager sharedManager] savaUserCategoryData:cateCell.category WithSuccess:^(NSString *successStr) {
                    NSLog(@"%@",successStr);
                    self.addToMainBlock(cateCell.category);
                } failure:^(NSString *errorStr) {
                    NSLog(@"%@",errorStr);
                }];
                //添加到首页
                
                //保存数据到本地
                
            }
            break;
        default:
            break;
    }
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    switch (index) {
        //删除操作
        case 0:
        {
            break;
        }
        default:
            break;
    }
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    // allow just one cell's utility button to be open at once
    return YES;
}

- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state
{
    switch (state) {
        case 1:
            // set to NO to disable all left utility buttons appearing
            return YES;
            break;
        case 2:
            // set to NO to disable all right utility buttons appearing
            return YES;
            break;
        default:
            break;
    }
    
    return YES;
}

#pragma mark - 左右滑按钮设置
- (NSArray *)leftButtons
{
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.07 green:0.75f blue:0.16f alpha:1.0]
                                               title:@"添加"];
    return leftUtilityButtons;
}

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"删除"];
    return rightUtilityButtons;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
