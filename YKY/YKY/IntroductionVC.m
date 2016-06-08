//
//  IntroductionVC.m
//  一块摇
//
//  Created by 亮肖 on 15/4/24.
//  Copyright (c) 2015年 云途基石（北京）信息技术有限公司. All rights reserved.
//

#import "IntroductionVC.h"
#import "common.h"
#import "MBProgressHUD+MJ.h"

@interface IntroductionVC ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation IntroductionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setLeftNavBtn];
    self.webView.delegate = self;
    self.navigationItem.title = @"新手帮助";
    
    NSString *str = kHelpCenterStr;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:str]];
    
    [self.webView loadRequest:request];
    
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

@end
