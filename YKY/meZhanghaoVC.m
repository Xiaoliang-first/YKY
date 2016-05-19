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
    self.view.backgroundColor = [UIColor whiteColor];
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
    //个人信息backView
    CGFloat naoW = 16;
    CGFloat naoH = 22;
    UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 70, kScreenWidth, h)];
    view1.backgroundColor = [UIColor clearColor];
    [self.view addSubview:view1];
    //个人信息图
    UIImageView * naozhong = [[UIImageView alloc]initWithFrame:CGRectMake(magin, 0.5*(h-naoH), naoW, naoH)];
    naozhong.image = [UIImage imageNamed:@"me-geren"];
    [view1 addSubview:naozhong];
    //个人信息label
    UILabel * tixingL = [[UILabel alloc]initWithFrame:CGRectMake(naozhong.x+naozhong.width+magin, 0.5*(h-naoH), 80, naoH)];
    tixingL.font = [UIFont systemFontOfSize:[myFont getTitle2]];
    tixingL.textColor = [UIColor darkGrayColor];
    tixingL.text = @"个人信息";
    [view1 addSubview:tixingL];
    //个人信息btn
    UIButton * tixingBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, h)];
    [tixingBtn addTarget:self action:@selector(myCenterBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:tixingBtn];
    [line addLineWithFrame:CGRectMake(tixingL.x, h-1, kScreenWidth-tixingL.x, 1) andBackView:view1];


    //修改手机号
    CGFloat shoujiW = 16;
    CGFloat shoujiH = 22;
    UIView * view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 70+h, kScreenWidth, h)];
    view2.backgroundColor = [UIColor clearColor];
    [self.view addSubview:view2];
    //手机
    UIImageView * shouji = [[UIImageView alloc]initWithFrame:CGRectMake(magin, 0.5*(h-shoujiH), shoujiW, shoujiH)];
    shouji.image = [UIImage imageNamed:@"手机"];
    [view2 addSubview:shouji];
    //修改手机号Label
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(shouji.x+shouji.width+14, 0.5*(h-shoujiH), 200, shoujiH)];
    label.text = @"修改手机号";
    label.font = [UIFont systemFontOfSize:[myFont getTitle2]];
    label.textColor = [UIColor darkGrayColor];
    [view2 addSubview:label];
    [line addLineWithFrame:CGRectMake(label.x, h-1, kScreenWidth-label.x, 1) andBackView:view2];
    //修改手机号Btn
    UIButton * fixBt = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.view.width, h)];
    fixBt.backgroundColor = [UIColor clearColor];
    [fixBt addTarget:self action:@selector(fixPhoneNumberBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [view2 addSubview:fixBt];
    



    //修改密码
    CGFloat mimaW = 16;
    CGFloat mimaH = 22;
    UIView * view3 = [[UIView alloc]initWithFrame:CGRectMake(0, 70+2*h, kScreenWidth, h)];
    view3.backgroundColor = [UIColor clearColor];
    [self.view addSubview:view3];
    UIImageView * suo = [[UIImageView alloc]initWithFrame:CGRectMake(magin, 0.5*(h-mimaH), mimaW, mimaH)];
    suo.image = [UIImage imageNamed:@"密码"];
    [view3 addSubview:suo];
    //修改密码label
    UILabel * fixPwdL = [[UILabel alloc]initWithFrame:CGRectMake(label.x, 0.5*(h-mimaH), 200, mimaH)];
    fixPwdL.text = @"修改密码";
    fixPwdL.font = [UIFont systemFontOfSize:[myFont getTitle2]];
    fixPwdL.textColor = [UIColor darkGrayColor];
    [view3 addSubview:fixPwdL];
    [line addLineWithFrame:CGRectMake(fixPwdL.x, h-1, kScreenWidth-fixPwdL.x, 1) andBackView:view3];
    //修改密码按钮
    UIButton * fixPwdBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.view.width, h)];
    fixPwdBtn.backgroundColor = [UIColor clearColor];
    [fixPwdBtn addTarget:self action:@selector(fixPwdBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [view3 addSubview:fixPwdBtn];




    //地址管理
    UIView * view4 = [[UIView alloc]initWithFrame:CGRectMake(0, 70+3*h, kScreenWidth, h)];
    view4.backgroundColor = [UIColor clearColor];
    [self.view addSubview:view4];
    UIImageView * dizhi = [[UIImageView alloc]initWithFrame:CGRectMake(magin, 0.5*(h-mimaH), mimaW, mimaH)];
    dizhi.image = [UIImage imageNamed:@"me-dizhi"];
    [view4 addSubview:dizhi];
    //修改密码label
    UILabel * dizhiL = [[UILabel alloc]initWithFrame:CGRectMake(label.x, 0.5*(h-mimaH), 200, mimaH)];
    dizhiL.text = @"地址管理";
    dizhiL.font = [UIFont systemFontOfSize:[myFont getTitle2]];
    dizhiL.textColor = [UIColor darkGrayColor];
    [view4 addSubview:dizhiL];
    [line addLineWithFrame:CGRectMake(dizhiL.x, h-1, kScreenWidth-dizhiL.x, 1) andBackView:view4];
    //修改密码按钮
    UIButton * dizhiBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.view.width, h)];
    dizhiBtn.backgroundColor = [UIColor clearColor];
    [dizhiBtn addTarget:self action:@selector(dizhiGuanliBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [view4 addSubview:dizhiBtn];



    //产品吐槽
    UIView * view5 = [[UIView alloc]initWithFrame:CGRectMake(0, 70+4*h, kScreenWidth, h)];
    view5.backgroundColor = [UIColor clearColor];
    [self.view addSubview:view5];
    UIImageView * tucaoImgV = [[UIImageView alloc]initWithFrame:CGRectMake(magin, 0.5*(h-mimaH), mimaW, mimaH )];
    tucaoImgV.image = [UIImage imageNamed:@"产品吐槽"];
    [view5 addSubview:tucaoImgV];

    UILabel * tucaoL = [[UILabel alloc]initWithFrame:CGRectMake(label.x, 0.5*(h-mimaH), 80, mimaH)];
    tucaoL.font = [UIFont systemFontOfSize:[myFont getTitle2]];
    tucaoL.text = @"产品吐槽";
    tucaoL.textColor = [UIColor darkGrayColor];
    [view5 addSubview:tucaoL];
    [line addLineWithFrame:CGRectMake(tucaoL.x, h-1, kScreenWidth-tucaoL.x, 1) andBackView:view5];
    UIButton * tucaoBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.view.width, h)];
    [tucaoBtn addTarget:self action:@selector(productTucaoBtnClick) forControlEvents:UIControlEventTouchUpInside];
    tucaoBtn.backgroundColor = [UIColor clearColor];
    [view5 addSubview:tucaoBtn];
    



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
