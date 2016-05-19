//
//  newAboutRockingVC.m
//  YKY
//
//  Created by 肖亮 on 15/9/21.
//  Copyright (c) 2015年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "newAboutRockingVC.h"

@interface newAboutRockingVC ()

//显示版本号的Label
@property (weak, nonatomic) IBOutlet UILabel *versionsLabel;

@end

@implementation newAboutRockingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"一块摇";
    
    NSString * currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    
    self.versionsLabel.text = [NSString stringWithFormat:@"一块摇%@",currentVersion];
    
    [self setLeftNavBtn];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setLeftNavBtn];
    self.tabBarController.tabBar.hidden = YES;
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


- (IBAction)scoreBtnClick:(id)sender {
    
    NSString *str = [NSString stringWithFormat:@"http://itunes.apple.com/us/app/id%d", 1001065082];//跳转到AppStore
    
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:str]];
    
}




@end
