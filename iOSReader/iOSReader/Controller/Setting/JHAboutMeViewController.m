//
//  JHAboutMeViewController.m
//  ios reader
//
//  Created by 李江辉 on 15-2-5.
//  Copyright (c) 2015年 com.ftxbird. All rights reserved.
//

#import "JHAboutMeViewController.h"
#import "IRDefineHeader.h"

@interface JHAboutMeViewController ()

@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *appIcon;

@end

@implementation JHAboutMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViewInfo];
}

- (void)setupViewInfo
{
    [self.view setBackgroundColor:IRGlobalBg];
    [self.navigationItem setTitle:@"关于我们"];
    
    self.appIcon.layer.masksToBounds = YES;
    self.appIcon.layer.cornerRadius = 0.5 * self.appIcon.frame.size.width;
    
    [self.versionLabel setText:[NSString stringWithFormat:@"version %@", AppVersion]];
    
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
