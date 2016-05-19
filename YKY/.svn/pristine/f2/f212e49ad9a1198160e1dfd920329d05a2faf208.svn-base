//
//  fixUserNameVC.m
//  YKY
//
//  Created by 肖亮 on 15/9/10.
//  Copyright (c) 2015年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "fixUserNameVC.h"


@interface fixUserNameVC ()<UITextFieldDelegate>

/** 修改昵称的Field */
@property (weak, nonatomic) IBOutlet UITextField *fixNameField;


@end

@implementation fixUserNameVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"修改昵称";
    
    //显示默认当前
    self.fixNameField.text = self.userName;
    
    //设置导航栏左侧城市切换按钮
    [self setLeftNavBtn];
    
}

#pragma mark - 左导航栏按钮设置
- (void)setLeftNavBtn{
    UIBarButtonItem * left = [[UIBarButtonItem alloc]initWithTitle:@"<返回" style:UIBarButtonItemStylePlain target:self action:@selector(leftClick)];
    left.tintColor = [UIColor whiteColor];
    [left setImage:[UIImage imageNamed:@"jiantou-Left"]];
    self.navigationItem.leftBarButtonItem = left;
}

#pragma arguments 左导航按钮点击事件
-(void)leftClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setLeftNavBtn];
    self.tabBarController.tabBar.hidden = YES;
}

#pragma mark - 保存按钮点击事件
- (IBAction)saveFixedBtnClick:(id)sender {
    [[NSUserDefaults standardUserDefaults]setObject:self.fixNameField.text forKey:@"fixedUserName"];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.fixNameField resignFirstResponder];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.fixNameField resignFirstResponder];
    return YES;
}

@end
