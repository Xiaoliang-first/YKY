//
//  noticeDetailVC.m
//  一块摇
//
//  Created by 亮肖 on 15/4/27.
//  Copyright (c) 2015年 云途基石（北京）信息技术有限公司. All rights reserved.
//

#import "noticeDetailVC.h"
#import "common.h"
#import "noticeModel.h"

@interface noticeDetailVC ()

@end

@implementation noticeDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"系统通知";

    self.view.backgroundColor =  [UIColor whiteColor];
    [self setLeftNavBtn];
    self.noticeDetailLabel.text = self.noticemodel.sysContent;
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
