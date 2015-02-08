//
//  mainViewController.m
//  ios reader
//
//  Created by 张李成 on 15-1-19.
//  Copyright (c) 2015年 com.ftxbird. All rights reserved.
//
#import "IRMainViewController.h"
#import "KINWebBrowserViewController.h"
#import "IRCategoryTableViewController.h"
#import "IRMainCollectionHeaderView.h"
#import "IRMainCollectionViewCell.h"
#import "IRCategoryModel.h"
#import "IRDefineHeader.h"
#import "IRDataMannager.h"
#import "SVProgressHUD.h"
@interface IRMainViewController ()<UICollectionViewDataSource, UICollectionViewDelegate,KINWebBrowserDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *mainCollectionView;
@property (nonatomic,strong) NSMutableArray *collectionArray;
@end

@implementation IRMainViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.mainCollectionView.delegate = self;
    self.mainCollectionView.dataSource = self;
    [self.mainCollectionView setBackgroundColor:IRGlobalBg];
    
    UILongPressGestureRecognizer *longPressReger = [[UILongPressGestureRecognizer alloc]
                                                    initWithTarget:self action:@selector(handleLongPress:)];
    longPressReger.minimumPressDuration = 1.0;
    [self.mainCollectionView addGestureRecognizer:longPressReger];
}


#pragma mark - 处理头像长按手势
- (void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    CGPoint point = [gestureRecognizer locationInView:self.mainCollectionView];
    NSIndexPath *indexPath = [self.mainCollectionView indexPathForItemAtPoint:point];
    
    if (indexPath)
    {
        IRMainCollectionViewCell *cell = (IRMainCollectionViewCell *)[self.mainCollectionView cellForItemAtIndexPath:indexPath];
        
        [self addShakeAnimationForView:cell.itemImageView withDuration:0.5];
        cell.deleteIcon.hidden = NO;
        
        weakify(self);
        cell.cellLongPressHandel= ^{
            strongify(self);
            __block  IRCategoryModel * category = self.collectionArray[indexPath.section][indexPath.row];
            NSString *tipMsg = [NSString stringWithFormat:@"是否将%@从首页移除",category.categoryTitle];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                           message:tipMsg
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                       style:UIAlertActionStyleDestructive
                     handler:^(UIAlertAction *action)
            {
                strongify(self);
                [self.collectionArray[indexPath.section] removeObjectAtIndex:indexPath.item];
                [self.mainCollectionView performBatchUpdates:^{
                [self.mainCollectionView deleteItemsAtIndexPaths:@[indexPath]];
            } completion:^(BOOL finished){
                if (finished)
               {
                    [[IRDataMannager sharedManager] deleteUserCategoryData:category WithSuccess:^(NSString *successStr) {
                        [SVProgressHUD showSuccessWithStatus:successStr];
                    } failure:^(NSString *errorStr) {
                        [SVProgressHUD showInfoWithStatus:errorStr];
                    }];
               }
            }];}]];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                                      style:UIAlertActionStyleCancel
                                                    handler:nil]];
          
            
            [self presentViewController:alert animated:YES completion:nil];
        };
    }
}

- (void)addShakeAnimationForView:(UIView *)view withDuration:(NSTimeInterval)duration {
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.delegate = self;
    animation.duration = duration;
    animation.values = @[ @(0.0 * M_PI_4), @(0.4 * M_PI_4), @(-0.4 * M_PI_4), @(0.4 *M_PI_4), @(-0.4 *M_PI_4), @(0.0 * M_PI_4) ];
    animation.keyTimes = @[ @(0), @(0.225), @(0.425), @(0.6), @(0.75), @(1) ];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [view.layer addAnimation:animation forKey:@"ShakerAnimationKey"];
}

#pragma mark - 获取collection数据
- (NSMutableArray *)collectionArray
{
    if(!_collectionArray)
    {
        self.collectionArray = [IRDataMannager initUserData];
    }

    return _collectionArray;
}


#pragma mark - collection 代理方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self.collectionArray count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [[self.collectionArray objectAtIndex:section] count];
}

/**
 *  定义main头部view 和底部view
 */
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    //头部view
    if (kind == UICollectionElementKindSectionHeader) {
        IRMainCollectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"mainHeaderView" forIndexPath:indexPath];
        
        reusableview = headerView;
        NSString *title = [IRDataMannager fetchCategoryTitle:indexPath.section];
        
        //解决线框view 只初始化一次问题
        if (!headerView.roundLabel.text.length) {
            //设置标题
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(5, headerView.frame.size.height-1, headerView.frame.size.width-10, 1)];
            lineView.backgroundColor = [UIColor colorWithWhite:0.800 alpha:0.500];
            
            [headerView addSubview:lineView];
        }
        
        headerView.roundLabel.text = [title substringWithRange:NSMakeRange(0,1)];
        headerView.titleLabel.text = title;
        
        
        weakify(self);
        headerView.openCaregoryBlock = ^{
            strongify(self);
            IRCategoryTableViewController *categoryVC = [[IRCategoryTableViewController alloc] init];
            categoryVC.categoryType = indexPath.section;
            [self.navigationController pushViewController:categoryVC animated:YES];
            categoryVC.addToMainBlock =^(IRCategoryModel *addModel)
            {
                strongify(self);
               // [self.collectionArray[indexPath.section] addObject:addModel];
                [self.mainCollectionView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]];
            };
        };
        }
    
// 还可定义底部view  备用   if (kind == UICollectionElementKindSectionFooter) {
//        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
//        
//        reusableview = footerview;
//    }
    
    return reusableview;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"mainCollectionCell";
    
    IRMainCollectionViewCell *cell = (IRMainCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    IRCategoryModel * category = self.collectionArray[indexPath.section][indexPath.row];
    cell.category = category;
    return cell;
}

/**
 *  首页item点击方法
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    IRCategoryModel * category = self.collectionArray[indexPath.section][indexPath.row];
    
    KINWebBrowserViewController *webBrowser = [KINWebBrowserViewController webBrowser];
    [webBrowser setDelegate:self];
    webBrowser.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:webBrowser animated:YES];
    
    if (category.categoryUrl) {
        [webBrowser loadURLString:category.categoryUrl];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    self.collectionArray = nil;
    // Dispose of any resources that can be recreated.
}

@end
