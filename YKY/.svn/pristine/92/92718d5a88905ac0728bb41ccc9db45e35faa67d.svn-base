//
//  bossLogInAccountVC.m
//  YKY
//
//  Created by 亮肖 on 15/6/26.
//  Copyright (c) 2015年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

//******************商家登陆窗口界面********************

#import "bossLogInAccountVC.h"
#import "AFNetworking.h"
#import "common.h"
#import "MBProgressHUD+MJ.h"
#import <CommonCrypto/CommonDigest.h>
#import "bossAccount.h"
#import "bossAccountTool.h"
#import "bossLogAccountVC.h"
#import "AccountTool.h"


@interface bossLogInAccountVC ()<UITextFieldDelegate>


/** 电话号码Field */
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberField;
/** 密码Field */
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
/** 登陆按钮 */
@property (weak, nonatomic) IBOutlet UIButton *logInBtn;


@end

@implementation bossLogInAccountVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"商家登录";
    
    self.phoneNumberField.delegate = self;
    self.pwdField.delegate = self;
    
    //设置登陆按钮圆角
    self.logInBtn.layer.cornerRadius = 5;
    self.logInBtn.layer.masksToBounds = YES;
    self.logInBtn.layer.borderWidth = 0.1;
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setLeftNavBtn];
}

#pragma mark - 设置左导航nav
-(void)setLeftNavBtn{
    UIBarButtonItem * left = [[UIBarButtonItem alloc]initWithTitle:@"<返回" style:UIBarButtonItemStylePlain target:self action:@selector(leftClick)];
    left.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = left;
}

-(void)leftClick{

    if (self.alterPwdVC_Back == YES) {//商家修改密码成功之后返回来的
        self.alterPwdVC_Back = YES;//判断参数恢复初始化
        //点击返回到商家验证界面
        UIApplication *app = [UIApplication sharedApplication];
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        bossLogAccountVC *vc = [sb instantiateViewControllerWithIdentifier:@"bossLogAccountVC"];
        UINavigationController * navc = [[UINavigationController alloc]initWithRootViewController:vc];
        app.keyWindow.rootViewController = navc;

    }else{//商家首次登陆时push来的
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - 退去输入键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.phoneNumberField resignFirstResponder];
    [self.pwdField resignFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.phoneNumberField resignFirstResponder];
    [self.pwdField resignFirstResponder];
    return YES;
}

#pragma mark - 登陆按钮点击事件
- (IBAction)logBtnClick:(id)sender {
    
    if (self.phoneNumberField.text.length == 0) {
        [MBProgressHUD showError:@"请输入登录账号"];
        return;
    }
    if (self.pwdField.text.length == 0) {
        [MBProgressHUD showError:@"请输入登录密码"];
        return;
    }
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    NSString *str = kBossLogInStr;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary * parameters = @{@"loginName":self.phoneNumberField.text,@"pwd":[self md5:self.pwdField.text]};

    [manager POST:str parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([responseObject[@"code"] isEqual:@(0)]) {
            [[NSUserDefaults standardUserDefaults]setObject:self.phoneNumberField.text forKey:@"bossPhone"];//保存登陆商家的电话号码
            bossAccount * bossaccount = [bossAccount bossWithDict:responseObject[@"data"][0]];
            [bossAccountTool saveAccount:bossaccount];
            [MBProgressHUD showSuccess:@"登录成功"];
            [self jumpToDetail];
        }else{
            [MBProgressHUD showError:responseObject[@"msg"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"网络加载失败"];
    }];
    
}
/** 登陆成功的跳转 */
-(void)jumpToDetail{
    
    //普通用户信息清空
    [AccountTool saveAccount:nil];
    //跳转
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    bossLogAccountVC *vc = [sb instantiateViewControllerWithIdentifier:@"bossLogAccountVC"];
    vc.indentify = @"0";
    [self.navigationController pushViewController:vc animated:YES];
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
