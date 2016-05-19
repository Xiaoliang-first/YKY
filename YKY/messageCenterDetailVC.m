//
//  messageCenterDetailVC.m
//  YKY
//
//  Created by 肖亮 on 15/9/14.
//  Copyright (c) 2015年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "messageCenterDetailVC.h"
#import "UIView+XL.h"

@interface messageCenterDetailVC ()

@end

@implementation messageCenterDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.text = self.TitleStr;
    self.timeLabel.text = self.time;
    self.contentLabel.text = self.content;
    
    
    self.navigationItem.title = @"消息中心";
    [self setLeftNavBtn];

    
    self.contentLabel.height = self.contentLabel.frame.size.height+40;
    [self.contentLabel sizeToFit];
    
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
