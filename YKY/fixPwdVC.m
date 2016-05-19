//
//  fixPwdVC.m
//  YKY
//
//  Created by 肖亮 on 15/9/12.
//  Copyright (c) 2015年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "fixPwdVC.h"
#import "AFNetworking.h"
#import <CommonCrypto/CommonDigest.h>
#import "common.h"
#import "AccountTool.h"
#import "Account.h"
#import "MBProgressHUD+MJ.h"
#import "myAccountVC.h"


@interface fixPwdVC ()<UITextFieldDelegate>


/** 旧密码field */
@property (weak, nonatomic) IBOutlet UITextField *oldPwdField;
/** 新密码field */
@property (weak, nonatomic) IBOutlet UITextField *nowPwdField;
/** 确认新密码field */
@property (weak, nonatomic) IBOutlet UITextField *okNowPwdField;


@end

@implementation fixPwdVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"修改密码";
    [self setLeftNavBtn];
    Account * account = [AccountTool account];
    if (!account) {
        [self jumpToMyaccountVC];
    }
    self.oldPwdField.delegate = self;
    self.nowPwdField.delegate = self;
    self.okNowPwdField.delegate = self;
    
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

#pragma mark - 键盘消失
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.nowPwdField resignFirstResponder];
    [self.okNowPwdField resignFirstResponder];
    [self.oldPwdField resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.nowPwdField resignFirstResponder];
    [self.okNowPwdField resignFirstResponder];
    [self.oldPwdField resignFirstResponder];
    return YES;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setLeftNavBtn];
    self.tabBarController.tabBar.hidden = YES;
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


#pragma mark - 确认修改按钮点击事件
- (IBAction)okBtnClick:(id)sender {
    
    if (self.nowPwdField.text.length == 0) {
        [MBProgressHUD showError:@"新密码不能为空!"];
        return;
    }
    if ([self.oldPwdField.text isEqualToString:self.nowPwdField.text]) {
        [MBProgressHUD showError:@"新密码与旧密码一致"];
        return;
    }
    if (![self.nowPwdField.text isEqualToString:self.okNowPwdField.text]) {
        [MBProgressHUD showError:@"新密码输入不一致!"];
        return;
    }
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    
    
    Account *account = [AccountTool account];
    NSString *str = kfixPwdStr;
    
    NSDictionary *parameters = @{@"client":Kclient,@"userId":account.uiId,@"serverToken":account.reponseToken,@"oldPwd":[self md5:self.oldPwdField.text],@"newPwd":[self md5:self.nowPwdField.text]};
    
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
 
    [manger POST:str parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"code"] isEqual:@0]) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showSuccess:@"密码修改成功"];
            //延时执行消失Label
            [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(labelDissmis) userInfo:nil repeats:NO];
        }else if ([responseObject[@"code"] isEqual:KotherLogin]){
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showError:@"账号已过期,请重新登录!"];
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showError:responseObject[@"msg"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"网络加载失败"];
    }];
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



//跳转
-(void)labelDissmis{
    Account *acc = [AccountTool account];
    if (acc) {
        //实现当前用户注销（就是把 account.data文件清空）
        acc = nil;
        [AccountTool saveAccount:acc];
        //当前用户注销之后跳转到登陆界面
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        myAccountVC * myAccountVC = [sb instantiateViewControllerWithIdentifier:@"myAccountVC"];
        myAccountVC.ID = @"2";
        [self.navigationController pushViewController:myAccountVC animated:YES];
    }else{
        
    }
    
}



@end
