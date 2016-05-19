//
//  forgetPwdVC.m
//  YKY
//
//  Created by 肖亮 on 15/9/22.
//  Copyright (c) 2015年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "forgetPwdVC.h"
#import "common.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "MZTimerLabel.h"
#import "forgetPwdDetailVC.h"


@interface forgetPwdVC ()<UITextFieldDelegate>

/** 电话号码field */
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
/** 验证码btn */
@property (weak, nonatomic) IBOutlet UIButton *authCodeBtn;
/** 验证码field */
@property (weak, nonatomic) IBOutlet UITextField *authCodeField;
/** 验证码背景view */
@property (weak, nonatomic) IBOutlet UIView *authCodeBackView;
/** 确认按钮btn */
@property (weak, nonatomic) IBOutlet UIButton *okBtnClick;
/** 发送成功的验证码 */
@property (nonatomic , copy) NSString * authCode;


@end

@implementation forgetPwdVC



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setLeftNavBtn];
    self.navigationItem.title = @"忘记密码";
    self.phoneField.delegate = self;
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

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.phoneField resignFirstResponder];
    [self.authCodeField resignFirstResponder];
}


#pragma mark - 输入框结束编辑时调用
-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    if ([textField isEqual:self.phoneField]) {//电话的field
        
        [self authPhone];
        
    }else{//验证码的field
        
        if ([self.authCodeField.text isEqualToString:self.authCode]) {
            self.okBtnClick.hidden = NO;
        }else{
            [MBProgressHUD showError:@"验证码输入错误,请查证后重新输入!"];
            self.okBtnClick.hidden = YES;
        }
        
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if ([textField isEqual:self.phoneField]) {
        self.authCodeBackView.hidden = YES;
        self.authCodeField.text = nil;
        self.okBtnClick.hidden = YES;
        self.authCodeBtn.hidden = YES;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self.authCodeField resignFirstResponder];
    [self.phoneField resignFirstResponder];
    
    return YES;
}


#pragma mark - 验证手机号是否存在
-(void)authPhone{
    
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    
    NSString * str = kauthPhoneStr;
    
    NSDictionary *parameter = @{@"loginName":self.phoneField.text};
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:str parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([responseObject[@"code"] isEqual:@(0)]) {//手机号可被注册
            [MBProgressHUD showError:@"该账号不存在,请查证后再试"];
            self.authCodeBtn.hidden = YES;
        }else{//手机号已被注册
            self.authCodeBtn.hidden = NO;
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"网络加载失败,请检查您的网络!"];
    }];
}




#pragma mark - 验证码按钮点击事件
- (IBAction)authCodeBtnClick:(id)sender {
    self.authCodeBtn.enabled = NO;
    //发送验证码
    [self sendAuthCode];
}

-(void)sendAuthCode{
    MZTimerLabel *timer = [[MZTimerLabel alloc] initWithLabel:self.authCodeBtn.titleLabel andTimerType:MZTimerLabelTypeTimer];
    [timer setCountDownTime:60];
    self.authCodeBtn.enabled = NO;
    timer.timeFormat = [NSString stringWithFormat:@"ss%@",@"秒"];
    [timer startWithEndingBlock:^(NSTimeInterval countTime) {
        self.authCodeBtn.hidden = NO;
        self.authCodeBtn.enabled = YES;
        self.authCodeBtn.enabled = YES;
        [self.authCodeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
    }];
    
    int Value = (arc4random()%999999)+100000;
    NSString * automCodeStr = [NSString stringWithFormat:@"%d",Value];
    self.authCode = automCodeStr;
    NSString * str1 = [@"tpl_value=%23code%23%3D" stringByAppendingString:automCodeStr];
    NSString * str = [NSString stringWithFormat:@"http://v.juhe.cn/sms/send?mobile=%@&tpl_id=5672&%@&key=573becaef88739929129aa21b79798d3",self.phoneField.text,str1];
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    [manager GET:str parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"error_code"] isEqual:@(0)]) {
            [MBProgressHUD showSuccess:@"验证码发送成功,请注意查收!"];
            self.authCodeBackView.hidden = NO;
        }else{
            [MBProgressHUD showError:@"验证码发送失败!"];
            self.authCodeBtn.hidden = NO;
            self.authCodeBackView.hidden = YES;
            [self.authCodeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"网络加载失败,请检查您的网络!"];
    }];
}


#pragma mark - 确定按钮点击事件
- (IBAction)okBtnClick:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    forgetPwdDetailVC * vc = [sb instantiateViewControllerWithIdentifier:@"forgetPwdDetailVC"];
    vc.phone = self.phoneField.text;
    [self.navigationController pushViewController:vc animated:YES];
}




@end
