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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addFavourite:) name:@"IRAddFavouriteNoti" object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"IRAddFavouriteNoti" object:nil];
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
    [self.tableView registerNib:[UINib nibWithNibName:@"IRArticleCell" bundle:nil]
         forCellReuseIdentifier:@"ArticleCell"];
}



- (void)addFavourite:(NSNotification *)notification
{
    IRArticleModel *article = (IRArticleModel *)notification.object;
    if (article) {
        [self.favouriteArray addObject:article];
//        [self.tableView beginUpdates];
//        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
//        [self.tableView endUpdates];
//        [self.tableView scrollToRowAtIndexPath:newIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        
    }

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
    //不显示收藏按钮
    webBrowser.showLikeButton =NO;
    [self.navigationController pushViewController:webBrowser animated:YES];
    
    if (article.articleUrl) {
        [webBrowser loadURLString:article.articleUrl];
    }
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath

{
    //删除
    weakify(self);
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
    {
        strongify(self);
        IRArticleModel *article = [self.favouriteArray objectAtIndex:indexPath.row];
        [self.favouriteArray removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationLeft];
        
        [[IRDataMannager sharedManager] deleteUserFavouriteArticle:article WithSuccess:^(NSString *successStr) {
            [SVProgressHUD showSuccessWithStatus:successStr];
        } failure:^(NSString *errorStr) {
            
        }];
        
    }];
    
    //分享
    UITableViewRowAction *moreRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"分享" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
    {
        NSLog(@"分享");
    }];
    
    moreRowAction.backgroundEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    
    return @[deleteRowAction,moreRowAction];
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
