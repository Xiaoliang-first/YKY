//
//  homeTableBarVC.m
//  YKY
//
//  Created by 肖亮 on 15/9/6.
//  Copyright (c) 2015年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "homeTableBarVC.h"
#import "myGold.h"
#import "meLucksVC.h"
#import "myNavViewController.h"
#import "AccountTool.h"

static luckView * _luckV;
static UIButton * _btn;
static UIButton * _xiaoX;
@interface homeTableBarVC ()

@end

@implementation homeTableBarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置tabbar
    [self setTabBarImges];

    //注册一个广播
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addLuckMessage) name:@"youAreLuckey" object:nil];

}

-(void)addLuckMessage{

    NSString * bindPath = @"/yshakeCoupons/getLuckeNotif";

    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];

    if (![AccountTool account]) {
        return;
    }
    
    [XLRequest AFPostHost:kbaseURL bindPath:bindPath postParam:parameter isClient:YES getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        DebugLog(@"查看是否中奖===%@",responseDic);
        if ([responseDic[@"code"] isEqual:@0]) {
            myGold *model = [myGold modelWithDict:responseDic[@"data"][0]];
            [self showLuckViewWithModel:model];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(void)showLuckViewWithModel:(myGold*)model{

    _btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenheight)];
    _btn.backgroundColor = [UIColor blackColor];
    [_btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    _btn.alpha = 0.5;
    [self.view addSubview:_btn];

    _luckV = [[luckView alloc]initWithFrame:CGRectMake(0.15*kScreenWidth, 0.35*kScreenheight, 0.7*kScreenWidth, 0.7*kScreenWidth)];
    [_luckV showWithModel:nil VC:self Action:@selector(btnClick) serials:model.serials pname:model.pname];
    [self.view addSubview:_luckV];

    _xiaoX = [[UIButton alloc]initWithFrame:CGRectMake(_luckV.x+_luckV.width-40, _luckV.y-35, 30, 30)];
    [_xiaoX setBackgroundImage:[UIImage imageNamed:@"xiaochazi"] forState:UIControlStateNormal];
    [_xiaoX addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_xiaoX];
}
-(void)click:(UIButton*)btn{
    [_xiaoX removeFromSuperview];
    [_luckV removeFromSuperview];
    [_btn removeFromSuperview];
}

-(void)btnClick{
    [_xiaoX removeFromSuperview];
    [_luckV removeFromSuperview];
    [_btn removeFromSuperview];
    
    meLucksVC * vc = [[meLucksVC alloc]init];
    vc.identify = @"1";
    myNavViewController * navc = [[myNavViewController alloc]initWithRootViewController:vc];
    UIApplication * app = [UIApplication sharedApplication];
    UIWindow * window = app.keyWindow;
    window.rootViewController = navc;
}

-(void)setTabBarImges{
//改变tabbar背景色
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    backView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    
    NSArray *TabBarSubView = [[self tabBar] subviews];
    for(UIView *CurrentView in TabBarSubView)
    {
        NSInteger tabBarItemTag = [CurrentView tag];
        if (tabBarItemTag==100){
            [CurrentView removeFromSuperview];//remove the old bgColorView
            break;
        }
    }
    [self.tabBar insertSubview:backView atIndex:0];
    

    UITabBarItem *item0 = [self.tabBar.items objectAtIndex:0];
    UITabBarItem *item1 = [self.tabBar.items objectAtIndex:1];
    UITabBarItem *item2 = [self.tabBar.items objectAtIndex:2];
    UITabBarItem *item3 = [self.tabBar.items objectAtIndex:3];
    UITabBarItem *item4 = [self.tabBar.items objectAtIndex:4];

// 对item设置相应地图片
    //首页
    item0.selectedImage = [[UIImage imageNamed:@"首页-红"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item0.image = [[UIImage imageNamed:@"首页-灰"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [item0 setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor redColor],NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];

    //摇购
    item1.selectedImage = [[UIImage imageNamed:@"摇购icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item1.image = [[UIImage imageNamed:@"摇-tabBar"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [item1 setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor redColor],NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    
    //摇一摇
    item2.selectedImage = [[UIImage imageNamed:@"摇一摇-红"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item2.image = [[UIImage imageNamed:@"摇一摇-灰"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [item2 setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor redColor],NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];

    //淘购
    item3.selectedImage = [[UIImage imageNamed:@"淘购-tabbar"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item3.image = [[UIImage imageNamed:@"tao-tabbar"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [item3 setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor redColor],NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    
    //我
    item4.selectedImage = [[UIImage imageNamed:@"我的-红"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item4.image = [[UIImage imageNamed:@"我的-灰"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [item4 setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor redColor],NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];

    self.tabBar.tintColor = [UIColor darkGrayColor];
}





@end
