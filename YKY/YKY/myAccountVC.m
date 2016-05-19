//
//  myAccountVC.m
//  一块摇
//
//  Created by 亮肖 on 15/4/24.
//  Copyright (c) 2015年 云途基石（北京）信息技术有限公司. All rights reserved.
//

#import "myAccountVC.h"
#import "AFNetworking.h"
#import <CommonCrypto/CommonDigest.h>
#import "common.h"
#import "Account.h"
#import "AccountTool.h"
#import "myNavViewController.h"
#import "MBProgressHUD+MJ.h"
#import "homeTableBarVC.h"
#import "UMSocial.h"
#import "authPhoneNumberVC.h"
#import "MobClick.h"
//#import "UMSocialQQHandler.h"
//#import "UMSocialSinaSSOHandler.h"
//#import "UMSocialWechatHandler.h"




@interface myAccountVC () <UIAlertViewDelegate,UITextFieldDelegate>



/**  用户密码Field */
@property (weak, nonatomic) IBOutlet UITextField *passwordFiled;

/**  登陆按钮 */
@property (weak, nonatomic) IBOutlet UIButton *logInBtn;

/**  提示窗label */
@property (nonatomic , strong) UIView * myView;

/** 商家登录按钮 */
@property (weak, nonatomic) IBOutlet UIButton *bossLogBtn;

/** 放在scrollView上的承载View */
@property (weak, nonatomic) IBOutlet UIView *backViewOnScroll;

/** 验证之后提示view */
@property (nonatomic , strong) UIAlertView * authOkAlter;

@property (nonatomic , strong) NSDictionary * request;

@end

@implementation myAccountVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [[UITextField appearance] setTintColor:[UIColor lightGrayColor]];

    self.title = @"登录";
    
    //指定代理
    self.passwordFiled.delegate = self;
    self.phoneNumberFiled.delegate = self;
    
    //添加手势识别器
    UITapGestureRecognizer *put = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeKeyboard)];
    [self.backViewOnScroll addGestureRecognizer:put];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    //设置左键点击事件
    UIBarButtonItem * left = [[UIBarButtonItem alloc]initWithTitle:@"<返回" style:UIBarButtonItemStylePlain target:self action:@selector(left2Click)];
    left.tintColor = [UIColor whiteColor];
    [left setImage:[UIImage imageNamed:@"jiantou-Left"]];
    self.navigationItem.leftBarButtonItem = left;
}

#pragma mark - 键盘消失
-(void)removeKeyboard{
    [self.phoneNumberFiled resignFirstResponder];
    [self.passwordFiled resignFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.phoneNumberFiled resignFirstResponder];
    [self.passwordFiled resignFirstResponder];
    return YES;
}

#pragma mark - 左键点击返回主界面
-(void)left2Click{
    if ([self.ID isEqualToString:@"2"]) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        homeTableBarVC *vc = [sb instantiateViewControllerWithIdentifier:@"homeTableBarVC"];
        UIApplication *app = [UIApplication sharedApplication];
        UIWindow *window = app.keyWindow;
        
        window.rootViewController = vc;
        
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}


#pragma mark - 登陆按钮
- (IBAction)logIn:(id)sender {
    
    //判断用户输入的账户和密码是否为空，为空则返回
    if ( self.phoneNumberFiled.text.length == 0 ) {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入您的登录账号!" message:Nil delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }else if (self.phoneNumberFiled.text.length != 0 && self.passwordFiled.text.length == 0){
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"请输入您的登录密码!" message:Nil delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    //请求用户登陆数据
    [self userLogIn];
}


#pragma mark - 登陆按钮点击时的网络请求
- (void)userLogIn{
    //键盘隐藏
    [self.phoneNumberFiled resignFirstResponder];
    [self.passwordFiled resignFirstResponder];
    
    //设置请求manger
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    
    //请求地址URL
    NSString *url = kLogInStr;
    
    //获取输入内容
    NSString * uiPhoneNumber = self.phoneNumberFiled.text;
    NSString * uiPwd = self.passwordFiled.text;

    //设置请求参数
    NSDictionary * parameter = @{@"loginName":uiPhoneNumber,@"pwd":[self md5:uiPwd]};

    //发送Post请求
    [manger POST:url parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {//成功时回调

        if ([responseObject[@"code"] isEqual:@(0)]) {
            //添加小窗提示
            [MBProgressHUD showSuccess:@"登录成功"];
            //清空奖兜跳转登陆界面的标志
            [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"haveJumped"];
            //保存登录用户的数据
            Account * account = [Account accountWithDict:responseObject[@"data"][0]];
            [AccountTool saveAccount:account];

            [[NSUserDefaults standardUserDefaults]setObject:responseObject[@"data"][0][@"gold"] forKey:@"gold"];
            [[NSUserDefaults standardUserDefaults]setObject:responseObject[@"data"][0][@"silver"] forKey:@"silverCoin"];
            [[NSUserDefaults standardUserDefaults]setObject:responseObject[@"data"][0][@"diamonds"] forKey:@"diamonds"];


            //友盟统计
            [MobClick profileSignInWithPUID:[NSString stringWithFormat:@"%@",account.uiId]];
            
            [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"registOK"];//切换账号时把签到时间置空
            
            //延时执行返回上一个（newMeVC）界面的操作
            [self performSelector:@selector(backToRootVc) withObject:nil afterDelay:2.3];
        }else{
            [AccountTool saveAccount:nil];
            //添加小窗提示
            [MBProgressHUD showError:responseObject[@"msg"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {//失败时回调
        [AccountTool saveAccount:nil];
        //添加小窗提示
        [MBProgressHUD showSuccess:@"网络状况不好，请稍后再试"];
    }];
    
}


//返回主界面
-(void)backToRootVc{
    
    [self.navigationController popToRootViewControllerAnimated:YES];

    if ([self.ID isEqualToString:@"2"]) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        homeTableBarVC *vc = [sb instantiateViewControllerWithIdentifier:@"homeTableBarVC"];
        UIApplication *app = [UIApplication sharedApplication];
        UIWindow *window = app.keyWindow;
        
        window.rootViewController = vc;
        
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
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

#pragma mark - 商家登陆按钮点击事件
- (IBAction)bossLogInBtnClick:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController * vc = [sb instantiateViewControllerWithIdentifier:@"bossLogInAccountVC"];
    [self.navigationController pushViewController:vc animated:YES];
}



#pragma mark - 注册按钮点击事件
- (IBAction)singUpBtnClick:(id)sender {
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController * vc = [sb instantiateViewControllerWithIdentifier:@"signinVC"];
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - 忘记密码按钮点击事件
- (IBAction)forgetPwd:(id)sender {
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController * vc = [sb instantiateViewControllerWithIdentifier:@"forgetPwdVC"];
    [self.navigationController pushViewController:vc animated:YES];
    
}


-(void)dismissAuthAlter{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}


#pragma mark - 微信登录
- (IBAction)weixinLogIn:(id)sender {
    
    [MBProgressHUD showMessage:@"正在验证第三方..." toView:self.view];
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){

        [MBProgressHUD hideHUDForView:self.view animated:YES];

        if (response.responseCode == UMSResponseCodeSuccess) {
            
            //友盟返回的用户信息 （通过点语法可以获得用户相关资料信息）
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary]valueForKey:UMShareToWechatSession];
            

            //后台验证
            [self authMyBackWithRegistType:@"2" openId:snsAccount.openId snsAccount:snsAccount];
/*
 友盟在统计用户时以设备为标准，如果需要统计应用自身的账号，请使用以下接口（需使用3.6.4及以上版本SDK）：
 
 + (void)profileSignInWithPUID:(NSString *)puid;
 + (void)profileSignInWithPUID:(NSString *)puid provider:(NSString *)provider;
 
 PUID：用户账号ID.长度小于64字节
 Provider：账号来源。如果用户通过第三方账号登陆，可以调用此接口进行统计。不能以下划线"_"开头，使用大写字母和数字标识，长度小于32 字节 ; 如果是上市公司，建议使用股票代码。
*/
            [MobClick profileSignInWithPUID:snsAccount.openId provider:@"wechat"];
        }
    });
    
    [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToWechatSession  completion:^(UMSocialResponseEntity *response){

    }];
    
    [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(dismissAuthAlter) userInfo:nil repeats:NO];
    
}



#pragma mark - 新浪登录
- (IBAction)sinaLogIn:(id)sender {
    
    [MBProgressHUD showMessage:@"正在验证第三方..." toView:self.view];
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        //获取微博用户名、uid、token等
        if (response.responseCode == UMSResponseCodeSuccess) {
            //友盟返回的用户信息 （点语法获得）
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
            
            //后台验证
            [self authMyBackWithRegistType:@"3" openId:snsAccount.usid snsAccount:snsAccount];
            
            [MobClick profileSignInWithPUID:snsAccount.openId provider:@"sinaWebo"];
        }
    });    
    
    //获取accestoken以及新浪用户信息，得到的数据在回调Block对象形参respone的data属性
    [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToSina  completion:^(UMSocialResponseEntity *response){
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
    [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(dismissAuthAlter) userInfo:nil repeats:NO];
    
}


#pragma mark - 扣扣登录
- (IBAction)qqLogIn:(id)sender {
    
    [MBProgressHUD showMessage:@"正在验证第三方..." toView:self.view];
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQzone];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        //获取微博用户名、uid、token等
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            //友盟返回用户信息
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQzone];
            
            //后台验证
            [self authMyBackWithRegistType:@"1" openId:snsAccount.usid snsAccount:snsAccount];
            
            [MobClick profileSignInWithPUID:snsAccount.usid provider:@"QQ"];
        }
    });
    
    //获取accestoken以及QQ用户信息，得到的数据在回调Block对象形参respone的data属性
    [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToQQ  completion:^(UMSocialResponseEntity *response){
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
    [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(dismissAuthAlter) userInfo:nil repeats:NO];
    
}


//实现回调方法
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    if (response.viewControllerType == UMSViewControllerOauth) {
    }
}


#pragma mark - 后台验证
-(void)authMyBackWithRegistType:(NSString *)registType openId:(NSString *)openId  snsAccount:(UMSocialAccountEntity*)snsAoocunt{
    
    NSString * str = kauthPhoneNmbStr;

    if (!openId) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"用户信息验证失败!"];
        return;
    }
    //registType 1.微信 2.新浪 3.qq
    NSDictionary *parameter = @{@"third_type":registType,@"openId":openId};

    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:str parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        //该第三方ID尚未注册
        if ([responseObject[@"code"] isEqual:KnoBangding]) {
            
            //跳转到绑定注册界面
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            authPhoneNumberVC * vc = [sb instantiateViewControllerWithIdentifier:@"authPhoneNumberVC"];
            //传参
            vc.snsAccount = snsAoocunt;
            vc.registType = registType;
            //跳转
            [self.navigationController pushViewController:vc animated:YES];
        }else if([responseObject[@"code"] isEqual:@(0)]){//该第三方ID已注册
            Account * accout = [Account accountWithDict:responseObject[@"data"][0]];
            [AccountTool saveAccount:accout];
            [MBProgressHUD showSuccess:@"登陆成功!"];
            //清空奖兜跳转登陆界面的标志
            [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"haveJumped"];
            /** 保存完成之后跳转到首页 **/
            [self jumpToRootVC];
            
        }else{
            [MBProgressHUD showError:responseObject[@"msg"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"网络加载失败,请检查您的网络!"];
    }];
}


#pragma mark - 跳转到首页
-(void)jumpToRootVC{
    [NSTimer scheduledTimerWithTimeInterval:1.7 target:self selector:@selector(jump) userInfo:nil repeats:NO]; 
}
-(void)jump{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
