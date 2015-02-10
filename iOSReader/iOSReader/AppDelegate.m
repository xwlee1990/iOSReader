//
//  AppDelegate.m
//  iOSReader
//
//  Created by 张李成 on 15-1-19.
//  Copyright (c) 2015年 com.ftxbird. All rights reserved.
//

#import "AppDelegate.h"
#import "IRMainViewController.h"
#import "IRCollectionViewController.h"
#import "IRSettingViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "IRDataMannager.h"
#import "IRAVOSHelper.h"
#import "IRDefineHeader.h"
#import "FCUUID.h"
// AVOS ID And Key
#define AVOSCloudAppID  @"lv9a61q2rymr4gpnedq4spsee61vji7qjnmnwfpg198mb5hu"
#define AVOSCloudAppKey @"53lwe465unijak5wf8lo8auzl08rr1vf9khmwvmfilhh92i9"
@interface AppDelegate ()

@property (nonatomic,strong)UITabBarController *tabBarController;
@property (nonatomic,strong)IRUser *loginUser;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    /**判断是否是第一次启动*/
    [self firstLaunchJudge];
    
    /**设置AVOSCloud*/
    [AVOSCloud setApplicationId:AVOSCloudAppID
                      clientKey:AVOSCloudAppKey];
    
    /**统计应用启动情况*/
    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    /* 重要! 注册子类 App生命周期内 只需要执行一次即可*/
    [IRArticleModel registerSubclass];
    [IRCategoryModel registerSubclass];
    [IRUser registerSubclass];
    
    
    /** 登录 */
    [self IRLogin];


    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    
    
    return YES;
}


/**
 *  登录
 */
- (void)IRLogin
{
    //获取该app 唯一设备id  (当用户系统重装无效)
    NSString *userUUID = [FCUUID uuidForDevice];
    AVQuery *query = [AVQuery queryWithClassName:@"IRUser"];
    [query whereKey:@"userId" equalTo:userUUID];
    weakify(self);
    [query getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        strongify(self);
        if (!object) {
            self.loginUser = [IRUser new];
            self.loginUser.userId = userUUID;
            [self.loginUser saveInBackground];
        } else {
            self.loginUser = (IRUser *)object;
        }
    }];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/**
 *  底部Tabbar控制器
 */
- (UITabBarController *)tabBarController
{
    if(_tabBarController == nil)
    {
        //设置导航栏和状态栏
        [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor colorWithWhite:0.298 alpha:1.000] forKey:NSForegroundColorAttributeName]];
        [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithWhite:0.902 alpha:1.000]];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        [[UINavigationBar appearance] setTintColor:[UIColor colorWithWhite:0.298 alpha:1.000]];
        
        [UINavigationBar appearance].translucent = YES;
        
        //设置tarbar
        UITabBarController *tabBarController = [[UITabBarController alloc] init];
        
        tabBarController.tabBar.tintColor = [UIColor colorWithRed:80/255.0 green:134/255.0 blue:192/255.0 alpha:1];
        tabBarController.tabBar.barTintColor = [UIColor colorWithWhite:0.902 alpha:1.000];
        
        tabBarController.tabBar.translucent = NO;
        
        
        UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"IRMainNavigate" bundle:nil];
        
        IRMainViewController * mainVC = [storyBoard instantiateViewControllerWithIdentifier:@"mainVC"];
        //首页
        //mainViewController *mainVC = [[mainViewController alloc] init];
        // mainVC.view.frame = [UIScreen mainScreen].bounds;
        
        UINavigationController *readerNav = [[UINavigationController alloc] initWithRootViewController:mainVC];
        mainVC.title = @"首页";
        readerNav.tabBarItem.image = [UIImage imageNamed:@"IRHome"];
        readerNav.tabBarItem.selectedImage = [UIImage imageNamed:@"IRHome_blue"];
        [tabBarController addChildViewController:readerNav];
        
        
        //收藏
        IRCollectionViewController *collectVC = [[IRCollectionViewController alloc] init];
        collectVC.view.frame = [UIScreen mainScreen].bounds;
        
        UINavigationController *collectNav = [[UINavigationController alloc] initWithRootViewController:collectVC];
        collectVC.title = @"收藏";
        collectNav.tabBarItem.image = [UIImage imageNamed:@"IRCollet"];
        collectNav.tabBarItem.selectedImage = [UIImage imageNamed:@"IRCollet_blue"];
        
        [tabBarController addChildViewController:collectNav];
        
        
        //设置
        IRSettingViewController *settingVC = [[IRSettingViewController alloc] init];
        settingVC.view.frame = [UIScreen mainScreen].bounds;
        
        UINavigationController *settingNav = [[UINavigationController alloc] initWithRootViewController:settingVC];
        
        settingVC.title = @"设置";
        settingNav.tabBarItem.image = [UIImage imageNamed:@"IRSetting"];
        settingNav.tabBarItem.selectedImage = [UIImage imageNamed:@"IRSetting_blue"];
        
        [tabBarController addChildViewController:settingNav];
        
        
        self.tabBarController = tabBarController;
    }
    
    return _tabBarController;
}

- (void)firstLaunchJudge
{
    //判断用户是不是第一次启动程序
    if (![UserDefaults boolForKey:@"everLaunched"]) {
        
        [UserDefaults setBool:YES forKey:@"everLaunched"];
        [UserDefaults setBool:YES forKey:@"firstLaunch"];
        
        // 开关
        [UserDefaults setBool:YES forKey:@"imageDownloadSwitch"];
        [UserDefaults setBool:YES forKey:@"blogSendSwitch"];
        [UserDefaults setBool:YES forKey:@"webSendSwitch"];
        [UserDefaults setBool:YES forKey:@"openSendSwitch"];
        [UserDefaults setBool:YES forKey:@"blogDownloadSwitch"];
        [UserDefaults setBool:YES forKey:@"webDownloadSwitch"];
        [UserDefaults setBool:YES forKey:@"openDownloadSwitch"];
        
    }
    else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
    }
}

@end
