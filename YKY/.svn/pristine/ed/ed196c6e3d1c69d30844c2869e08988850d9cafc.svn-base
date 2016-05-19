//
//  freeTalkVC.m
//  YKY
//
//  Created by 肖亮 on 15/9/21.
//  Copyright (c) 2015年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "freeTalkVC.h"
#import "AFNetworking.h"
#import "common.h"
#import "Account.h"
#import "AccountTool.h"
#import "MBProgressHUD+MJ.h"
#import "myAccountVC.h"


@interface freeTalkVC ()<UITextViewDelegate>

/** 用户填写意见和建议的textView */
@property (weak, nonatomic) IBOutlet UITextView *textView;
/** 提交按钮 */
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

@end

@implementation freeTalkVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textView.delegate = self;
    
    Account * account = [AccountTool account];
    if (!account) {
        [self jumpToMyaccountVC];
    }
    self.navigationItem.title = @"产品吐槽";
    [self setLeftNavBtn];
}

-(void)jumpToMyaccountVC{
    Account * account2 = [AccountTool account];
    if (account2) {
        //实现当前用户注销（就是把 account.data文件清空）
        account2 = nil;
        [AccountTool saveAccount:account2];
        //当前用户注销之后跳转到登陆界面
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        myAccountVC * myAccountVC = [sb instantiateViewControllerWithIdentifier:@"myAccountVC"];
        [self.navigationController pushViewController:myAccountVC animated:YES];
    }else{
        //当前用户注销之后跳转到登陆界面
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        myAccountVC * myAccountVC = [sb instantiateViewControllerWithIdentifier:@"myAccountVC"];
        [self.navigationController pushViewController:myAccountVC animated:YES];
    }
}

#pragma mark - 设置左导航nav
-(void)setLeftNavBtn{
    UIBarButtonItem * left = [[UIBarButtonItem alloc]initWithTitle:@"<返回" style:UIBarButtonItemStylePlain target:self action:@selector(leftClick)];
    left.tintColor = [UIColor whiteColor];
    [left setImage:[UIImage imageNamed:@"jiantou-Left"]];
    self.navigationItem.leftBarButtonItem = left;
}
-(void)leftClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setLeftNavBtn];
    self.tabBarController.tabBar.hidden = YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.textView resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [self.textView resignFirstResponder];
        return NO;
    }
    return YES;
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    if (self.textView.text.length == 0) {
        self.textView.text = @"请写下您宝贵的意见和建议，我会马不停蹄地进行修改，尽量让您满意!";
    }
}

/**  提交按钮点击事件 */
- (IBAction)commitBtnClick:(id)sender {
    
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    
    if (self.textView.text.length == 0 || [self.textView.text isEqualToString:@"请写下您宝贵的意见和建议，我会马不停蹄地进行修改，尽量让您满意!"]) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"请输入您的宝贵意见!"];
        return;
    }
    
    Account *account = [AccountTool account];
    if (account.reponseToken == nil | account.uiId == nil | account.phone == nil) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"网络不好，请稍后重试!"];
        //延时执行消失Label
        [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(labelDissmis) userInfo:nil repeats:NO];
        return;
    }
    
    NSString *str = kFeedBackStr;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    NSDictionary *parameters = @{@"client":Kclient,@"userId":account.uiId,@"serverToken":account.reponseToken,@"content":self.textView.text};
    
    [manager POST:str parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([responseObject[@"code"] isEqual:@(0)]) {
            [MBProgressHUD showSuccess:responseObject[@"msg"]];
        }else{
            [MBProgressHUD showError:responseObject[@"msg"]];
        }
        //延时执行消失Label
        [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(labelDissmis) userInfo:nil repeats:NO];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"网络加载失败!"];
    }];
}


-(void)textViewDidBeginEditing:(UITextView *)textView{
    textView = self.textView;
    self.textView.text = nil;
    self.textView.textColor = [UIColor blackColor];
}


//Label消失
-(void)labelDissmis{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
