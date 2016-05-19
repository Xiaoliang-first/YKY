//
//  IWControllerTool.m
//  
//
//  Created by teacher on 14-6-9.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "IWControllerTool.h"
#import "homeTableBarVC.h"
#import "IWNewfeatureViewController.h"
#import "myNavViewController.h"
#import "severceDeal.h"
#import "bossAccount.h"
#import "bossAccountTool.h"
#import "remaindVC.h"


@implementation IWControllerTool
+ (void)chooseRootViewController
{
    NSString *key = (__bridge NSString *)kCFBundleVersionKey;
    
    // 1.当前软件的版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    
    UIApplication *application = [UIApplication sharedApplication];
    UIWindow *window = application.keyWindow;
    
    // 2.沙盒中的版本号
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *sandBoxVersion = [defaults stringForKey:key];
    
     // 3.比较  当前软件的版本号  和  沙盒中的版本号
    if ([currentVersion compare:sandBoxVersion] == NSOrderedDescending) {
        // 存储当前软件的版本号
        [defaults setObject:currentVersion forKey:key];
        [defaults synchronize];
        
        application.statusBarHidden = YES;
        
        window.rootViewController = [[IWNewfeatureViewController alloc] init];
    } else {
//        // 显示状态栏
        application.statusBarHidden = NO;
        [application setStatusBarStyle:UIStatusBarStyleLightContent];
        
        bossAccount * bossaccount = [bossAccountTool account];
        if (bossaccount) {//有商家登陆
            
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"bossLogAccountVC"];
            myNavViewController *navc = [[myNavViewController alloc]initWithRootViewController:vc];
            
            window.rootViewController = navc;
            
        }else{//用户端登陆
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            UITableViewController *tableBarVC = [sb instantiateViewControllerWithIdentifier:@"homeTableBarVC"];
            
            //第一次使用时需要同意服务协议
            NSString * first = [[NSUserDefaults standardUserDefaults]objectForKey:@"first"];
            if (![first isEqualToString:@"1"]) {
                // 显示状态栏
                UIApplication *app = [UIApplication sharedApplication];
                app.statusBarHidden = NO;
                UIWindow *window = app.keyWindow;
                // 切换window的rootViewController
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                homeTableBarVC *VC = [sb instantiateViewControllerWithIdentifier:@"homeTableBarVC"];
                window.rootViewController = VC;
            }else{
                //当程序被杀死之后点击通知时走这里
                UILocalNotification *note = [[[UIApplication sharedApplication]scheduledLocalNotifications] lastObject];
                if (note) {
                    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    remaindVC *remaindVC = [sb instantiateViewControllerWithIdentifier:@"remaindVC"];
                    myNavViewController *nvc = [[myNavViewController alloc]initWithRootViewController:remaindVC];
                    window.rootViewController = nvc;
                }
                window.rootViewController = tableBarVC;
            }
        }
    }
}
@end
