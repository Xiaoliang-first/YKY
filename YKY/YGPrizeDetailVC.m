//
//  YGPrizeDetailVC.m
//  YKY
//
//  Created by 肖 亮 on 16/4/12.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "YGPrizeDetailVC.h"
#import "homeTableBarVC.h"

@interface YGPrizeDetailVC ()

@end

@implementation YGPrizeDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = _vcTitle;

    [self setLeft];

    DebugLog(@"-=-=%@====%@",_requestUrl,_vcTitle);

    UIWebView * webView = [[UIWebView alloc]init];
    if ([_ID isEqualToString:@"1"]) {
        webView.frame = CGRectMake(0, 0, kScreenWidth, kScreenheight);
    }else{
        webView.frame = CGRectMake(0, 0, kScreenWidth, kScreenheight+44);
    }
    [self.view addSubview:webView];
    // 将页面缩放到 webView 大小
    webView.scalesPageToFit = YES;

    NSURLRequest * request = [NSURLRequest requestWithURL:_requestUrl];

    [webView loadRequest:request];
}

#pragma mark - 设置leftItem
-(void)setLeft{
    UIBarButtonItem * left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"jiantou-Left"] style:UIBarButtonItemStylePlain target:self action:@selector(leftClick)];
    left.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = left;
}
-(void)leftClick{
    if ([self.ID isEqualToString:@"1"]) {//首页
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        homeTableBarVC *vc = [sb instantiateViewControllerWithIdentifier:@"homeTableBarVC"];
        UIApplication *app = [UIApplication sharedApplication];
        UIWindow *window = app.keyWindow;
        window.rootViewController = vc;
    }else{//不是推送进来的，直接返回上级
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}


@end
