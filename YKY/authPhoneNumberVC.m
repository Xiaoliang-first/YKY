//
//  authPhoneNumberVC.m
//  YKY
//
//  Created by 肖亮 on 15/10/17.
//  Copyright (c) 2015年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "authPhoneNumberVC.h"
#import "AFNetworking.h"
#import "common.h"
#import "MBProgressHUD+MJ.h"
#import "MZTimerLabel.h"
#import "pinlessVC.h"
#import "Account.h"
#import "AccountTool.h"
#import "myNavViewController.h"


@interface authPhoneNumberVC ()<UITextFieldDelegate,UIAlertViewDelegate>

/** 提示手机号被注册 */
@property (weak, nonatomic) IBOutlet UILabel *remindSignedLabel;
/** 电话号码field */
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberField;
/** 验证码field */
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
/** 获取验证码btn */
@property (weak, nonatomic) IBOutlet UIButton *getAuthCodeBtn;
/** 确认按钮 */
@property (weak, nonatomic) IBOutlet UIButton *okBtn;
/** 验证码背景view */
@property (weak, nonatomic) IBOutlet UIView *authCodeBackView;

/** 发送的验证码 */
@property (nonatomic , copy) NSString * authCode;

/** 是否需要在一块摇注册 */
@property (nonatomic) BOOL signOrNo;

@property (nonatomic , copy) NSString * getAuthCodePhoneNum;

@end

@implementation authPhoneNumberVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"验证手机号";
    
    self.phoneNumberField.delegate = self;
    self.pwdField.delegate = self;
    
    //设置做导航按钮
    [self setLeftNavBtn];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setLeftNavBtn];
    self.authCodeBackView.hidden = YES;
    self.getAuthCodeBtn.hidden = YES;
    self.okBtn.enabled = NO;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.phoneNumberField resignFirstResponder];
    [self.pwdField resignFirstResponder];
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


#pragma mark - textField 的代理方法
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if ([textField isEqual:self.phoneNumberField]) {
        if (self.phoneNumberField.text.length == 11) {
            //判断输入的手机号是否是平台已注册的手机号
            [self isSignOrNo];
        }else{
            [MBProgressHUD showError:@"手机号码输入不正确!"];
        }
    }
    if ([textField isEqual:self.pwdField]){
        if ([self.pwdField.text isEqualToString:self.authCode]) {
            self.okBtn.enabled = YES;
        }else{
            [MBProgressHUD showError:@"验证码输入错误!"];
            self.okBtn.enabled = NO;
        }
    }
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if ([textField isEqual:self.phoneNumberField]) {
        self.authCodeBackView.hidden = YES;
        self.getAuthCodeBtn.hidden = YES;
        self.okBtn.enabled = NO;
        self.pwdField.text = nil;
    }
    if ([textField isEqual:self.pwdField]) {
        if (![self.phoneNumberField.text isEqualToString:self.getAuthCodePhoneNum]) {
            [MBProgressHUD showError:@"手机号码已改变,请重新发送验证码"];
            self.authCodeBackView.hidden = YES;
            self.getAuthCodeBtn.hidden = NO;
        }
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.phoneNumberField resignFirstResponder];
    [self.pwdField resignFirstResponder];
    return YES;
}


#pragma mark - 判断输入的手机号是否在一块摇后台已注册
-(void)isSignOrNo{
    [MBProgressHUD showMessage:@"验证中..." toView:self.view];
    NSString * str = ksignAuthPhoneStr;
    NSDictionary *parameter = @{@"loginName":self.phoneNumberField.text};
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    [manager POST:str parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"code"] isEqual:@(0)]) {//手机号可被注册
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            self.authCodeBackView.hidden = YES;
            self.getAuthCodeBtn.hidden = NO;
            //需要绑定加注册
            self.signOrNo = YES;
            if (self.phoneNumberField.text.length == 11) {
                self.getAuthCodeBtn.hidden = NO;
                self.authCodeBackView.hidden = YES;
            }
        }else if([responseObject[@"code"] isEqual:@101007]){//手机号已被注册
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            self.authCodeBackView.hidden = YES;
            self.getAuthCodeBtn.hidden = NO;
            //绑定即可
            self.signOrNo = NO;
            if (self.phoneNumberField.text.length == 11) {
                self.getAuthCodeBtn.hidden = NO;
                self.authCodeBackView.hidden = YES;
            }
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
    self.authCodeBackView.hidden = NO;
    self.getAuthCodeBtn.enabled = NO;
    MZTimerLabel *timer = [[MZTimerLabel alloc] initWithLabel:self.getAuthCodeBtn.titleLabel andTimerType:MZTimerLabelTypeTimer];
    [timer setCountDownTime:60];
    timer.timeFormat = [NSString stringWithFormat:@"ss%@",@"秒"];
    [timer startWithEndingBlock:^(NSTimeInterval countTime) {
        self.getAuthCodeBtn.enabled = YES;
        [self.getAuthCodeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
    }];
    
    //发送验证码
    [self sendAuthCode];
}

#pragma mark - 发送验证码
-(void)sendAuthCode{
    
    int Value = (arc4random()%1000000)+100000;
    NSString * automCodeStr = [NSString stringWithFormat:@"%d",Value];
    self.authCode = automCodeStr;
    NSString * str1 = [@"tpl_value=%23code%23%3D" stringByAppendingString:automCodeStr];
    NSString * str = [NSString stringWithFormat:@"http://v.juhe.cn/sms/send?mobile=%@&tpl_id=5672&%@&key=573becaef88739929129aa21b79798d3",self.phoneNumberField.text,str1];
    DebugLog(@"=%@",self.authCode);
    self.getAuthCodePhoneNum = self.phoneNumberField.text;
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    [manager GET:str parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"error_code"] isEqual:@(0)]) {
            [MBProgressHUD showSuccess:@"验证码发送成功,请注意查收!"];
        }else{
            [MBProgressHUD showError:@"验证码发送失败!"];
            [self.getAuthCodeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"网络加载失败,请检查您的网络!"];
    }];
}


#pragma mark - 确认按钮被点击
- (IBAction)okBtnClick:(id)sender {
    if (self.signOrNo) {//需要注册
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        pinlessVC * vc = [sb instantiateViewControllerWithIdentifier:@"pinlessVC"];
        //传参
        vc.registType = self.registType;
        vc.snsAccount = self.snsAccount;
        vc.phoneNumber = self.getAuthCodePhoneNum;
        [self.navigationController pushViewController:vc animated:YES];
    }else{//不需注册，只需绑定
        UIAlertView * alter = [[UIAlertView alloc]initWithTitle:@"确认绑定" message:@"该手机号在一块摇已注册,确认绑定该手机号?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认绑定", nil];
        [alter show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            [MBProgressHUD showError:@"已取消绑定"];
            break;
        case 1:
            [self pinlessAndLogIn];
            break;
        default:
            break;
    }
}

#pragma mark - 绑定登录
-(void)pinlessAndLogIn{
    [MBProgressHUD showMessage:@"绑定中..." toView:self.view];
    NSString * str = kBangDingStr;
    NSDictionary *parameter = [[NSDictionary alloc]init];
    if ([self.registType isEqualToString:@"2"]) {
        parameter = @{@"name":self.snsAccount.userName,@"openId":self.snsAccount.openId,@"third_type":self.registType,@"phone":self.getAuthCodePhoneNum,@"headImage":self.snsAccount.iconURL};
    }else{
        parameter = @{@"name":self.snsAccount.userName,@"openId":self.snsAccount.usid,@"third_type":self.registType,@"phone":self.getAuthCodePhoneNum,@"headImage":self.snsAccount.iconURL};
    }
    NSLog(@"=====%@",parameter);
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    [manager POST:str parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        Account * account = [Account accountWithDict:responseObject[@"data"][0]];
        [AccountTool saveAccount:account];
        [MBProgressHUD showSuccess:@"绑定成功!"];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"网络异常,请检查您的网络!"];
    }];
}

#pragma mark - 跳转到首页
-(void)jumpToRootVC{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController * vc = [sb instantiateViewControllerWithIdentifier:@"homeVC"];
    UIApplication * app = [UIApplication sharedApplication];
    myNavViewController *navc = [[myNavViewController alloc]initWithRootViewController:vc];
    app.keyWindow.rootViewController = navc;
    [app.keyWindow makeKeyAndVisible];
    
}


@end
