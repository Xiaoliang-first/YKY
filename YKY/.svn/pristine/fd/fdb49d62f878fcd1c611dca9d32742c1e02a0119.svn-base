//
//  forgetPwdDetailVC.m
//  YKY
//
//  Created by 肖亮 on 15/9/22.
//  Copyright (c) 2015年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "forgetPwdDetailVC.h"
#import "AFNetworking.h"
#import "common.h"
#import "MBProgressHUD+MJ.h"
#import <CommonCrypto/CommonDigest.h>
#import "Account.h"
#import "AccountTool.h"
#import "myAccountVC.h"



@interface forgetPwdDetailVC ()<UITextFieldDelegate>


/** 电话laebl */
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
/** 新密码field */
@property (weak, nonatomic) IBOutlet UITextField *nowPwdField;
/** 确认新密码field */
@property (weak, nonatomic) IBOutlet UITextField *okNowPwdField;



@end

@implementation forgetPwdDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"重置密码";
    
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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setLeftNavBtn];
    self.phoneLabel.text = self.phone;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.nowPwdField resignFirstResponder];
    [self.okNowPwdField resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.nowPwdField resignFirstResponder];
    [self.okNowPwdField resignFirstResponder];
    
    return YES;
}


- (IBAction)okBtnClick:(id)sender {
    [MBProgressHUD showMessage:@"重置中..." toView:self.view];
    if (self.nowPwdField.text.length == 0) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"新密码不能为空!"];
        return;
    }
    
    if (![self.nowPwdField.text isEqualToString:self.okNowPwdField.text]) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"两次密码输入不一致!"];
        return;
    }
    
    
    NSString * str = kforgetPwdStr;

    if ([self.phone isKindOfClass:[NSNull class]] || self.phone.length == 0 || self.okNowPwdField.text.length == 0) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"电话号码输入有误!"];
        return;
    }
    
    NSDictionary *parameter = @{@"loginName":self.phone,@"newPwd":[self md5:self.okNowPwdField.text]};
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:str parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([responseObject[@"code"] isEqual:@(0)]) {
            [MBProgressHUD showSuccess:@"找回密码成功!"];
            [NSTimer scheduledTimerWithTimeInterval:1.2 target:self selector:@selector(jump) userInfo:nil repeats:NO];
        }else{
            [MBProgressHUD showError:responseObject[@"msg"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"网络加载超时,请重试!"];
    }];
}

-(void)jump{
    Account * account2 = [AccountTool account];
    if (account2) {
        //实现当前用户注销（就是把 account.data文件清空）
        account2 = nil;
        [AccountTool saveAccount:account2];
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        myAccountVC * vc = [sb instantiateViewControllerWithIdentifier:@"myAccountVC"];
        vc.ID = @"2";
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        myAccountVC * vc = [sb instantiateViewControllerWithIdentifier:@"myAccountVC"];
        vc.ID = @"2";
        [self.navigationController pushViewController:vc animated:YES];
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
