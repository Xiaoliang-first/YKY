//
//  TGMainVC.m
//  YKY
//
//  Created by 肖 亮 on 16/4/7.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "TGMainVC.h"

@interface TGMainVC ()

@end

@implementation TGMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"淘购";

    [self addViews];
}
-(void)addViews{
    UIImageView * imgV = [[UIImageView alloc]initWithFrame:CGRectMake(0.5*(kScreenWidth-114), 0.5*(kScreenheight-143), 114, 143)];
    imgV.image = [UIImage imageNamed:@"敬请期待"];
    [self.view addSubview:imgV];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    //发送广播
    [[NSNotificationCenter defaultCenter] postNotificationName:@"youAreLuckey" object:nil];
}

@end
