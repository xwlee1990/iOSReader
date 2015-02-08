//
//  JHFeedBackViewController.m
//  ios reader
//
//  Created by 李江辉 on 15-2-5.
//  Copyright (c) 2015年 com.ftxbird. All rights reserved.
//

#import "JHFeedBackViewController.h"
#import "JHPlaceHolderTextView.h"
#import "IRDefineHeader.h"

@interface JHFeedBackViewController ()
@property (weak, nonatomic) IBOutlet JHPlaceHolderTextView *textView;
@property (weak, nonatomic) IBOutlet UITextField *userInfoTextView;

@end

@implementation JHFeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViewInfo];
}

- (void)setupViewInfo
{
    [self.view setBackgroundColor:IRGlobalBg];
    [self.navigationItem setTitle:@"意见反馈"];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(buttonClickedTOSubmitInfo)];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.textView.placeholder = @"请填写您的建议...";
    self.textView.font = [UIFont systemFontOfSize:16];
    self.textView.layer.cornerRadius = 5;
    
    self.userInfoTextView.placeholder = @" 手机号或邮箱（选填）";
    self.userInfoTextView.font = [UIFont systemFontOfSize:16];
    self.userInfoTextView.layer.cornerRadius = 5;
    
    
}

- (void)buttonClickedTOSubmitInfo
{
    if(self.textView.text == nil || self.textView.text.length == 0){
        
        UIAlertView  *alertView=[[UIAlertView alloc]initWithTitle:@"请填写反馈意见！" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:
                                 @"确定", nil];
        
        [alertView  show];
        
    }else{
        
        UIAlertView  *alertView=[[UIAlertView alloc]initWithTitle:@"反馈意见提交成功！" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:
                                 @"确定", nil];
        
        [alertView  show];
        
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
