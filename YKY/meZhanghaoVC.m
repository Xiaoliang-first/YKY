//
//  meZhanghaoVC.m
//  YKY
//
//  Created by 肖 亮 on 16/4/14.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "meZhanghaoVC.h"
#import "Account.h"
#import "AccountTool.h"
#import "myCenterVC.h"
#import "meAdressMangerVC.h"



@interface meZhanghaoVC ()

@end

@implementation meZhanghaoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = YKYColor(242, 242, 242);
    self.title = @"账户管理";
    [self setLeft];
    [self addViews];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

#pragma mark - 设置leftItem
-(void)setLeft{
    UIBarButtonItem * left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"jiantou-Left"] style:UIBarButtonItemStylePlain target:self action:@selector(leftClick)];
    left.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = left;
}
-(void)leftClick{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 添加控件
-(void)addViews{
    CGFloat h = 44;
    CGFloat magin = 15;

    UIView * view1 = [self addCellWithH:h magin:magin viewFrame:CGRectMake(0, 74, kScreenWidth, h) title:@"个人信息" action:@selector(myCenterBtnClick)];

    //修改手机号
    UIView * view2 = [self addCellWithH:h magin:magin viewFrame:CGRectMake(0, view1.y+h, kScreenWidth, h) title:@"修改手机号" action:@selector(fixPhoneNumberBtnClick)];

    //修改密码
    UIView * view3 = [self addCellWithH:h magin:magin viewFrame:CGRectMake(0, view2.y+h, kScreenWidth, h) title:@"修改密码" action:@selector(fixPwdBtnClick)];

    //地址管理
    UIView * view4 = [self addCellWithH:h magin:magin viewFrame:CGRectMake(0, view3.y+h+10, kScreenWidth, h) title:@"地址管理" action:@selector(dizhiGuanliBtnClick)];

    //产品吐槽
    UIView * view5 = [self addCellWithH:h magin:magin viewFrame:CGRectMake(0, view4.y+h, kScreenWidth, h) title:@"产品吐槽" action:@selector(productTucaoBtnClick)];
    view5.backgroundColor = [UIColor whiteColor];
}

-(UIView*)addCellWithH:(CGFloat)h magin:(CGFloat)magin viewFrame:(CGRect)frame title:(NSString*)title action:(SEL)action{
    //backview
    CGFloat labelH = 23;
    UIView * view1 = [[UIView alloc]initWithFrame:frame];
    view1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view1];
    //label
    UILabel * msgL = [[UILabel alloc]initWithFrame:CGRectMake(magin, 0.5*(h-labelH), 80, labelH)];
    msgL.font = [UIFont systemFontOfSize:[myFont getTitle2]];
    msgL.textColor = [UIColor darkGrayColor];
    msgL.text = title;
    [view1 addSubview:msgL];
    //image
    UIImageView * msgImg = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-magin-8, 0.5*(h-14),8,14)];
    msgImg.image = [UIImage imageNamed:@"jiantou_me"];
    [view1 addSubview:msgImg];
    //button
    UIButton * msgBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, h)];
    msgBtn.backgroundColor = [UIColor clearColor];
    [view1 addSubview:msgBtn];
    [msgBtn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    //bottomLine
    [line addLineWithFrame:CGRectMake(msgL.x, h-1, kScreenWidth-msgL.x, 1) andBackView:view1];
    return view1;
}



#pragma mark - 个人信息按钮被点击
-(void)myCenterBtnClick{
    DebugLog(@"个人信息按钮被点击");
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    myCenterVC *vc = [sb instantiateViewControllerWithIdentifier:@"myCenterVC"];
    vc.userName = self.userName;
    vc.iconUrl = [NSString stringWithFormat:@"%@",self.iconUrl];
    vc.userInfoModel = self.userModel;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 修改电话号码按钮点击事件
- (void)fixPhoneNumberBtnClick{
    DebugLog(@"修改手机号按钮被点击");
    Account * account = [AccountTool account];
    if (!account) {
        [self jumpToMyaccountVC];
    }else{
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController * vc = [sb instantiateViewControllerWithIdentifier:@"fixPhoneNumberVC"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - 修改密码按钮点击事件
- (void)fixPwdBtnClick{
    DebugLog(@"修改密码");
    Account * account = [AccountTool account];
    if (!account) {
        [self jumpToMyaccountVC];
    }else{
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController * vc = [sb instantiateViewControllerWithIdentifier:@"fixPwdVC"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - 地址管理按钮点击事件
-(void)dizhiGuanliBtnClick{
    DebugLog(@"地址管理按钮被点击");
    meAdressMangerVC * vc = [[meAdressMangerVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 产品吐槽按钮点击事件
- (void)productTucaoBtnClick{
    DebugLog(@"产品吐槽");
    Account * account = [AccountTool account];
    if (!account) {
        [self jumpToMyaccountVC];
    }else{
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController * vc = [sb instantiateViewControllerWithIdentifier:@"freeTalkVC"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}



//单点登录
-(void)jumpToMyaccountVC{
    Account *account = [AccountTool account];
    if (account) {
        //实现当前用户注销（就是把 account.data文件清空）
        account = nil;
        [AccountTool saveAccount:account];

        //当前用户注销之后跳转到登陆界面
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController * myAccountVC = [sb instantiateViewControllerWithIdentifier:@"myAccountVC"];
        [self.navigationController pushViewController:myAccountVC animated:YES];

    }else{
        //当前用户注销之后跳转到登陆界面
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController * myAccountVC = [sb instantiateViewControllerWithIdentifier:@"myAccountVC"];
        [self.navigationController pushViewController:myAccountVC animated:YES];
    }
}


@end
