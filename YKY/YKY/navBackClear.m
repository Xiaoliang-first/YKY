//
//  navBackClear.m
//  YKY
//
//  Created by 肖 亮 on 16/4/13.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "navBackClear.h"

@implementation navBackClear

+(void)setNavBackColorClearWithVC:(UINavigationBar *)bar{
    //去除边框
    [bar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault]; // 删除 forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [bar setShadowImage:[[UIImage alloc] init]];
    //title样式
    [bar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:20], NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    //添加这一行
    [bar setBarTintColor:[UIColor clearColor]];
}

+(void)setNavBackColorWithBar:(UINavigationBar *)bar{

    long RGB = 0xFE0501;
    bar.barTintColor = [UIColor colorWithRed:((float)((RGB & 0xFF0000) >> 16))/255.0 green:((float)((RGB & 0xFF00) >> 8))/255.0 blue:((float)(RGB & 0xFF))/255.0 alpha:1.0];
    [bar setBarTintColor:[UIColor colorWithRed:((float)((RGB & 0xFF0000) >> 16))/255.0 green:((float)((RGB & 0xFF00) >> 8))/255.0 blue:((float)(RGB & 0xFF))/255.0 alpha:1.0]];
    //    bar.tintColor = [UIColor blackColor];
    bar.backgroundColor = [UIColor clearColor];

    [bar setBackgroundImage:[UIImage imageNamed:@"navBack"] forBarMetrics:UIBarMetricsDefault]; // 删除 forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [bar setShadowImage:[[UIImage alloc] init]];
    
    //导航条文字颜色和大小
    [bar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,[UIFont systemFontOfSize:20.0], NSFontAttributeName,nil]];

}


@end
