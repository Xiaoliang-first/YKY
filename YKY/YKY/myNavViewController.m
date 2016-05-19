//
//  myNavViewController.m
//  YKY
//
//  Created by 亮肖 on 15/5/11.
//  Copyright (c) 2015年 云途基石（北京）信息技术有限公司. All rights reserved.
//

#import "myNavViewController.h"

@interface myNavViewController ()

@end

@implementation myNavViewController
+(void)initialize
{
    UINavigationBar * bar=[UINavigationBar appearance];

    //导航条颜色
    long RGB = 0xFE0501;
    bar.barTintColor = [UIColor colorWithRed:((float)((RGB & 0xFF0000) >> 16))/255.0 green:((float)((RGB & 0xFF00) >> 8))/255.0 blue:((float)(RGB & 0xFF))/255.0 alpha:1.0];
//    bar.tintColor = [UIColor blackColor];
    bar.backgroundColor = [UIColor clearColor];
    //导航条文字颜色和大小
    [bar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,[UIFont systemFontOfSize:20.0], NSFontAttributeName,nil]];

}

- (void)viewDidLoad {
    [super viewDidLoad];
}

//状态栏
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return  UIStatusBarStyleLightContent;
}

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{

    viewController.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    viewController.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
}




@end
