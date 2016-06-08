//
//  severceDeal.m
//  YKY
//
//  Created by 亮肖 on 15/6/18.
//  Copyright (c) 2015年 云途基石（北京）信息技术有限公司. All rights reserved.
//

#import "severceDeal.h"
#import "common.h"
#import "MBProgressHUD+MJ.h"
#import "myNavViewController.h"
#import "homeTableBarVC.h"

@interface severceDeal ()<UIAlertViewDelegate,UIWebViewDelegate>

/** 访问服务协议网站的webView */
@property (weak, nonatomic) IBOutlet UIWebView *webView;
/** 不同意按钮 */
@property (weak, nonatomic) IBOutlet UIButton *dontAgreeBtn;
/** 同意按钮 */
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;

@end

@implementation severceDeal

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"服务协议";

    self.webView.delegate = self;

    NSString *str = ksevrceXieYiStr;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:str]];
    [self.webView loadRequest:request];
    
    if ([self.identify isEqualToString:@"1"]) {//用户首次登陆的时候走
        self.dontAgreeBtn.hidden = NO;
        self.agreeBtn.hidden = NO;
    }else{
        self.dontAgreeBtn.hidden = YES;
        self.agreeBtn.hidden = YES;
        [self setLeftNavBtn];
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
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

-(void)viewWillDisappear:(BOOL)animated{
    self.identify = @"0";
}

#pragma mark - ********用户点击了不同意按钮********
- (IBAction)dontAgree:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请退出应用！" message:@"由于您不同意本应用的服务协议，您将不能享受我们提供的服务，您点击确定按钮之后应用将自动退出" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            break;
        case 1:
            [self exitApplication];
            break;
        default:
            break;
    }
}

- (void)exitApplication {
    UIApplication *app = [UIApplication sharedApplication];
    
    [UIView beginAnimations:@"exitApplication" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationTransition:UIViewAnimationCurveEaseInOut forView:app.keyWindow cache:NO];
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    app.keyWindow.bounds = CGRectMake(0, 0, 0, 0);
    [UIView commitAnimations];

}
- (void)animationFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    if ([animationID compare:@"exitApplication"] == 0) {
        
        exit(0);
    }
}

#pragma mark - ********用户点击了同意按钮********
- (IBAction)agree:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];

    //首次登陆标记设置为1，标示已经登陆过新版本
    [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"first"];
    
//    UIApplication *app = [UIApplication sharedApplication];
//    UIWindow *window = app.keyWindow;
    // 切换window的rootViewController
//    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    homeTableBarVC *VC = [sb instantiateViewControllerWithIdentifier:@"homeTableBarVC"];
//    myNavViewController * navc = [[myNavViewController alloc]initWithRootViewController:VC];
//    window.rootViewController = navc;


    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    homeTableBarVC *vc = [sb instantiateViewControllerWithIdentifier:@"homeTableBarVC"];
    UIApplication *app = [UIApplication sharedApplication];
    UIWindow *window = app.keyWindow;
    window.rootViewController = vc;

}



@end
