//
//  collectionViewController.m
//  ios reader
//
//  Created by 张李成 on 15-1-28.
//  Copyright (c) 2015年 com.ftxbird. All rights reserved.
//

#import "IRCollectionViewController.h"
#import "IRDefineHeader.h"
#import "IRArticleModel.h"
#import "KINWebBrowserViewController.h"
#import "IRArticleCell.h"
#import "IRDataMannager.h"
#import "IRDefineHeader.h"
#import "SVProgressHUD.h"
@interface IRCollectionViewController ()<UISearchResultsUpdating, UISearchBarDelegate,KINWebBrowserDelegate>
@property (nonatomic, strong) UISearchController *searchController; // 搜索控制器
@property (nonatomic, strong) NSMutableArray *searchResults;        // 搜索结果数组
@end

@implementation IRCollectionViewController


#pragma mark - 控制器初始化

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSearchController];
}


- (void)setupSearchController
{
    self.searchResults = [NSMutableArray arrayWithCapacity:[self.favouriteArray count]];
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    
    self.searchController.searchResultsUpdater = self;
    
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    
    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
    
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    self.definesPresentationContext = YES;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"IRArticleCell" bundle:nil]
         forCellReuseIdentifier:@"ArticleCell"];
}


#pragma mark - 获取本地数据
/**
 *  加载用户收藏数据
 */
- (NSMutableArray *)favouriteArray
{
    if (!_favouriteArray) {
        
        _favouriteArray = [NSMutableArray array];
        _favouriteArray = [IRDataMannager initUserFavouriteData];
    }
    
    return _favouriteArray;
    
}
#pragma mark - TableView数据源和代理方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.searchController.active) {
        return [self.searchResults count];
    } else {
        return [self.favouriteArray count];
    }
}

/**
 *  根据indexpath 取模型
 *
 *  @param indexPath indexpath
 *
 *  @return IRArticleModel
 */
- (IRArticleModel *)currentIndexModel:(NSIndexPath*)indexPath
{
    IRArticleModel *article;
    return article= self.searchController.active?[self.searchResults objectAtIndex:indexPath.row]:[self.favouriteArray objectAtIndex:indexPath.row];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier  = @"ArticleCell";
    IRArticleCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    IRArticleModel *article = [self currentIndexModel:indexPath];
    cell.titleLabel.text = article.articleTitle;
    cell.urlLabel.text = article.articleUrl;
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    IRArticleModel * article = [self currentIndexModel:indexPath];
    
    KINWebBrowserViewController *webBrowser = [KINWebBrowserViewController webBrowser];
    [webBrowser setDelegate:self];
    webBrowser.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:webBrowser animated:YES];
    
    if (article.articleUrl) {
        [webBrowser loadURLString:article.articleUrl];
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
    
    // 遍历favouriteArray匹配搜索字符串,添加匹配项到数组中.
    for (IRArticleModel *article in self.favouriteArray) {
        
        NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
        NSRange categoryNameRange = NSMakeRange(0, article.articleTitle.length);
        NSRange foundRange = [article.articleTitle rangeOfString:articleName options:searchOptions range:categoryNameRange];
        if (foundRange.length > 0) {
            [self.searchResults addObject:article];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
