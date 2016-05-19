//
//  signinVC.m
//  YKY
//
//  Created by 肖亮 on 15/9/22.
//  Copyright (c) 2015年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "signinVC.h"
#import "MBProgressHUD+MJ.h"
#import "AFNetworking.h"
#import "common.h"
#import "MZTimerLabel.h"
#import "UIView+XL.h"
#import "signinDetailVC.h"



@interface signinVC ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *remindLabel;
/** 电话号码field */
@property (weak, nonatomic) IBOutlet UITextField *phoneNmbField;

/** 验证码field */
@property (weak, nonatomic) IBOutlet UITextField *authCodeField;

/** 获取验证码Btn */
@property (weak, nonatomic) IBOutlet UIButton *getAuthCodeBtn;
/** 验证码背景View */
@property (weak, nonatomic) IBOutlet UIView *authCodeBackView;



/** 是否可发验证码 */
@property (nonatomic) BOOL isCanSetAuthCode;
/** 发送的验证码 */
@property (nonatomic , copy) NSString * authCode;
/** 确定按钮 */
@property (nonatomic , strong) UIButton * okBtn;

@property (nonatomic , copy) NSString * getAuthCodePhoneNum;

@end

@implementation signinVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"注册";
    
    [self setLeftNavBtn];
    self.getAuthCodeBtn.hidden = YES;
    self.isCanSetAuthCode = NO;
    self.phoneNmbField.delegate = self;
    self.authCodeField.delegate = self;
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

#pragma mark - 键盘消失方法
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    [self.phoneNmbField resignFirstResponder];
//    [self.authCodeField resignFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.phoneNmbField resignFirstResponder];
    [self.authCodeField resignFirstResponder];
    return YES;
}

#pragma mark - 电话号码输入够11位就让其请求是否可注册
-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (self.phoneNmbField.text.length == 0) {
        [MBProgressHUD showError:@"请输入手机号"];
        return;
    }
    if (self.phoneNmbField.text.length > 11 | self.phoneNmbField.text.length < 11) {
        [MBProgressHUD showError:@"手机号输入有误"];
        return;
    }
    
    if (textField.text.length != 11) {
        self.isCanSetAuthCode = NO;
    }
    
    if (self.isCanSetAuthCode == NO && self.authCodeField.text.length == 0) {
        self.authCodeBackView.hidden = YES;
        self.getAuthCodeBtn.hidden = YES;
    }
    
    if ([self.authCodeField.text isEqualToString:self.authCode]) {
        self.authCodeBackView.hidden = NO;
        self.getAuthCodeBtn.hidden = NO;
        self.okBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, self.authCodeBackView.y+self.authCodeBackView.height+30, kScreenWidth-60, 40)];
        
        [self.okBtn setTitle:@"确定" forState:UIControlStateNormal];
        [self.okBtn setBackgroundImage:[UIImage imageNamed:@"chengseyuanjiaojuxing"] forState:UIControlStateNormal];
        [self.okBtn addTarget:self action:@selector(okClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.okBtn];
    }else if(self.authCodeField.text.length != 0 && ![self.authCodeField.text isEqualToString:self.authCode]){
        [MBProgressHUD showError:@"验证码输入错误!"];
        self.authCodeBackView.hidden = NO;
        self.getAuthCodeBtn.hidden = NO;
    }
}

-(void)okClick{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    signinDetailVC * vc = [sb instantiateViewControllerWithIdentifier:@"sigInVC"];
    vc.phone = self.getAuthCodePhoneNum;
    [self.navigationController pushViewController:vc animated:YES];
    
}


-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (self.isCanSetAuthCode == NO && self.phoneNmbField.text.length != 11) {
        
        self.getAuthCodeBtn.hidden = YES;
        self.authCodeBackView.hidden = YES;
        
    }
    if ([textField isEqual:self.phoneNmbField]) {
        self.authCodeBackView.hidden = YES;
        self.getAuthCodeBtn.hidden = YES;
        self.authCodeField.text = nil;
        [self.okBtn removeFromSuperview];
    }
    self.remindLabel.hidden = YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    if ([textField isEqual:self.phoneNmbField]) {
        self.authCodeField.text = nil;
        
        if (self.phoneNmbField.text.length == 11) {
            [self authPhoneNmb];
        }else{
            [MBProgressHUD showError:@"手机号码不正确!"];
        }
    }
    return YES;
}


#pragma mark - 请求是否可注册
-(void)authPhoneNmb{
    
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    
    NSString * str = ksignAuthPhoneStr;
    
    NSDictionary *parameter = @{@"loginName":self.phoneNmbField.text};
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:str parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {

        if ([responseObject[@"code"] isEqual:@(0)]) {//手机号可被注册
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            self.getAuthCodeBtn.hidden = NO;
            self.isCanSetAuthCode = YES;
        }else{//手机号已被注册
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showError:@"该手机号已被注册!"];
            self.isCanSetAuthCode = NO;
            self.remindLabel.hidden = NO;
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"手机号认证失败,请检查您的网络!"];
    }];
}

#pragma mark - 获取验证码按钮点击事件
- (IBAction)getAuthCodeBtnClick:(id)sender {
    self.getAuthCodeBtn.hidden = NO;
    self.getAuthCodeBtn.enabled = NO;
    self.authCodeBackView.hidden = NO;
    MZTimerLabel *timer = [[MZTimerLabel alloc] initWithLabel:self.getAuthCodeBtn.titleLabel andTimerType:MZTimerLabelTypeTimer];
    [timer setCountDownTime:60];
    timer.timeFormat = [NSString stringWithFormat:@"ss%@",@"秒"];
    [timer startWithEndingBlock:^(NSTimeInterval countTime) {
        self.getAuthCodeBtn.enabled = YES;
        self.authCodeBackView.hidden = YES;
        [self.getAuthCodeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
    }];
    
    int Value = (arc4random()%999999)+100000;
    NSString * automCodeStr = [NSString stringWithFormat:@"%d",Value];
    self.authCode = automCodeStr;
    NSString * str1 = [@"tpl_value=%23code%23%3D" stringByAppendingString:automCodeStr];
    NSString * str = [NSString stringWithFormat:@"http://v.juhe.cn/sms/send?mobile=%@&tpl_id=5672&%@&key=573becaef88739929129aa21b79798d3",self.phoneNmbField.text,str1];
    
    self.getAuthCodePhoneNum = self.phoneNmbField.text;
    
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
