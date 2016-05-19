//
//  fixPhoneNumberVC.m
//  YKY
//
//  Created by 肖亮 on 15/9/11.
//  Copyright (c) 2015年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "fixPhoneNumberVC.h"
#import "common.h"
#import "AFNetworking.h"
#import "fixDetailVC.h"
#import "MZTimerLabel.h"
#import "Account.h"
#import "AccountTool.h"
#import "MBProgressHUD+MJ.h"
#import "myAccountVC.h"


@interface fixPhoneNumberVC ()<UITextFieldDelegate>

/** 确认修改按钮 */
@property (weak, nonatomic) IBOutlet UIButton *okBtn;
/** 验证码背景View */
@property (weak, nonatomic) IBOutlet UIView *authCodeBackView;
/** 手机号Field */
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberFiled;
/** 验证码Filed */
@property (weak, nonatomic) IBOutlet UITextField *authCodeField;
/** 获取验证码按钮Btn */
@property (weak, nonatomic) IBOutlet UIButton *getAuthCodeBtn;
/** 提示手机号被注册的Label */
@property (weak, nonatomic) IBOutlet UILabel *remindLabel;
/** 后台发送的验证码 */
@property (nonatomic , copy) NSString * authCode;

@property (nonatomic , copy) NSString * getAuthCodePhoneNum;

@end

@implementation fixPhoneNumberVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"修改手机号";
    
    self.phoneNumberFiled.delegate = self;
    self.authCodeField.delegate = self;
    
    //1.设置左navBtn
    [self setLeftNavBtn];
    
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


#pragma mark - 键盘消失
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.phoneNumberFiled resignFirstResponder];
    [self.authCodeField resignFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.phoneNumberFiled resignFirstResponder];
    [self.authCodeField resignFirstResponder];
    
    if ([textField isEqual:self.phoneNumberFiled]) {
        if (self.phoneNumberFiled.text.length == 11) {
            [self authPhoneNumber];
        }else{
            [MBProgressHUD showError:@"手机号输入有误"];
            self.authCodeBackView.hidden = YES;
        }
    }else if([textField isEqual:self.authCodeField]){
        if ([self.authCodeField.text isEqualToString:self.authCode]) {
            self.okBtn.hidden = NO;
        }else{
            [MBProgressHUD showError:@"验证码输入错误,请重新输入!"];
            self.okBtn.hidden = YES;
        }
    }
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if ([textField isEqual:self.phoneNumberFiled]) {
        self.remindLabel.hidden = YES;
        self.authCodeBackView.hidden = YES;
        self.okBtn.hidden = YES;
    }else if ([textField isEqual:self.authCodeField]){
        self.okBtn.hidden = YES;
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if ([textField isEqual:self.phoneNumberFiled]) {
        if (self.phoneNumberFiled.text.length == 11) {
            [self authPhoneNumber];
        }
    }
}


#pragma mark - 确认修改按钮点击事件
- (IBAction)okFixedBtnClick:(id)sender {
    
    if (self.phoneNumberFiled.text.length == 0) {
        [MBProgressHUD showError:@"请输入新手机号"];
        return;
    }
    if (self.authCodeField.text.length == 0){
        [MBProgressHUD showError:@"请输入验证码"];
        return;
    }
    if (![self.authCodeField.text isEqual:self.authCode]) {
        [MBProgressHUD showError:@"验证码输入错误,请重新输入!"];
        return;
    }
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    fixDetailVC * vc = [sb instantiateViewControllerWithIdentifier:@"fixDetailVC"];
    vc.phoneNumberStr = self.getAuthCodePhoneNum;
    vc.authCode = self.authCode;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - 获取验证码按钮点击事件
- (IBAction)getAuthCodeBtnClick:(id)sender {
    [self sendAuthCode];
}

#pragma mark - 验证手机号是否可发送验证码
-(void)authPhoneNumber{
    
    NSString * str = ksignAuthPhoneStr;
    NSDictionary *parameter = @{@"loginName":self.phoneNumberFiled.text};
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:str parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([responseObject[@"code"] isEqual:@(0)]) {//手机号已被注册
            self.getAuthCodeBtn.hidden = NO;
        }else{//手机号可用
            [MBProgressHUD showError:@"该手机号已被注册!"];
            self.getAuthCodeBtn.hidden = YES;
            self.authCodeBackView.hidden = YES;
            self.remindLabel.hidden = NO;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"网络加载失败,请重新输入手机号!"];
    }];
    
}

#pragma mark - 获取验证码方法
-(void)sendAuthCode{
    self.getAuthCodeBtn.enabled = NO;
    self.authCodeBackView.hidden = NO;
    self.authCodeField.text = nil;
    MZTimerLabel *timer = [[MZTimerLabel alloc] initWithLabel:self.getAuthCodeBtn.titleLabel andTimerType:MZTimerLabelTypeTimer];
    [timer setCountDownTime:60];
    timer.timeFormat = [NSString stringWithFormat:@"ss%@",@"秒"];
    [timer startWithEndingBlock:^(NSTimeInterval countTime) {
        self.getAuthCodeBtn.hidden = NO;
        self.getAuthCodeBtn.enabled = YES;
        [self.getAuthCodeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
    }];
    
    int Value = (arc4random()%999999)+100000;
    NSString * automCodeStr = [NSString stringWithFormat:@"%d",Value];
    self.authCode = automCodeStr;
    NSString * str1 = [@"tpl_value=%23code%23%3D" stringByAppendingString:automCodeStr];
    NSString * str = [NSString stringWithFormat:@"http://v.juhe.cn/sms/send?mobile=%@&tpl_id=5672&%@&key=573becaef88739929129aa21b79798d3",self.phoneNumberFiled.text,str1];
    self.getAuthCodePhoneNum = self.phoneNumberFiled.text;
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    [manager GET:str parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"error_code"] isEqual:@(0)]) {
            [MBProgressHUD showSuccess:@"验证码发送成功,请注意查收!"];
        }else{
            [MBProgressHUD showError:@"验证码发送失败!"];
            self.getAuthCodeBtn.hidden = NO;
            [self.getAuthCodeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"网络加载失败,请检查您的网络!"];
    }];
}


@end
