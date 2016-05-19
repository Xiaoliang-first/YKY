//
//  fixDetailVC.m
//  YKY
//
//  Created by 肖亮 on 15/9/11.
//  Copyright (c) 2015年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "fixDetailVC.h"
#import "common.h"
#import "AFNetworking.h"
#import "Account.h"
#import "AccountTool.h"
#import "MBProgressHUD+MJ.h"
#import "myAccountVC.h"
#import <CommonCrypto/CommonDigest.h>

@interface fixDetailVC ()<UITextFieldDelegate>

/** 密码的Field */
@property (weak, nonatomic) IBOutlet UITextField *pwdField;

@end

@implementation fixDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pwdField.delegate = self;
    self.phoneNumber.text = self.phoneNumberStr;
    self.navigationItem.title = @"确认修改";
    [self setLeftNavBtn];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setLeftNavBtn];
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


#pragma mark - 键盘消失
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.pwdField resignFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.pwdField resignFirstResponder];
    return YES;
}

#pragma mark - 确认修改按钮的点击事件
- (IBAction)okFixBtnClick:(id)sender {
    if (self.phoneNumberStr.length == 0) {
        return;
    }
    if (self.pwdField.text.length == 0) {
        [MBProgressHUD showError:@"请输入已登录账号密码"];
        return;
    }
    
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    //确认修改
    NSString *str = kFixPhoneNmbStr;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    Account * account = [AccountTool account];
    
    NSDictionary *parameters = @{@"client":Kclient,@"userId":account.uiId,@"serverToken":account.reponseToken,@"phone":self.phoneNumber.text,@"pwd":[self md5:self.pwdField.text]};
    
    [manager POST:str parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([responseObject[@"code"] isEqual:@(0)]) {
            Account *acc = [AccountTool account];
            if (acc) {
                //实现当前用户注销（就是把 account.data文件清空）
                acc = nil;
                [AccountTool saveAccount:acc];
                //当前用户注销之后跳转到登陆界面
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                myAccountVC * myAccountVC = [sb instantiateViewControllerWithIdentifier:@"myAccountVC"];
                myAccountVC.phoneNumberFiled.text = self.phoneNumber.text;
                myAccountVC.ID = @"2";
                [self.navigationController pushViewController:myAccountVC animated:YES];
                [MBProgressHUD showSuccess:@"修改成功"];
            }else{
                [MBProgressHUD showError:responseObject[@"msg"]];
            }
        }else if([responseObject[@"code"] isEqual:KotherLogin]){
            [MBProgressHUD showError:@"账号已过期,请重新登录!"];
            [self jumpToMyaccountVC];
        }else{
            [MBProgressHUD showError:responseObject[@"msg"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"网络加载失败,请重试!"];
    }];
}

//单点登录
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


#pragma mark - MD5密码加密
-(NSString *)md5:(NSString *)str {
    
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (unsigned int)strlen(cStr), result );
    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

@end
