//
//  mainViewcontroller.m
//  YDJD
//
//  Created by 肖 on 16/5/14.
//  Copyright © 2016年 肖. All rights reserved.
//

#import "mainViewcontroller.h"

#define kscreenW [UIScreen mainScreen].bounds.size.width
#define kscreenH [UIScreen mainScreen].bounds.size.height


@interface mainViewcontroller (){
        UIWebView *webView;
}

@end

@implementation mainViewcontroller

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication
      sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.view.backgroundColor = [UIColor whiteColor];
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.oi51.com/wap2/"]];
    UIView * vi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kscreenW, 20)];
    vi.backgroundColor = [UIColor colorWithRed:208.0/255.0 green:42.0/255.0 blue:58.0/255.0 alpha:1];
    [self.view addSubview:vi];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 20, kscreenW, kscreenH)];
    webView.backgroundColor = [UIColor clearColor];
//    webView.scrollView.bounces = NO;
    [self.view addSubview:webView];
    // 将页面缩放到 webView 大小
    webView.scalesPageToFit = YES;

    [webView loadRequest:request];
}

@end
