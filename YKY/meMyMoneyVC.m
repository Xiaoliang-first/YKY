//
//  meMyMoneyVC.m
//  YKY
//
//  Created by 肖 亮 on 16/4/15.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "meMyMoneyVC.h"
#import "meJinzhuanZuanVC.h"
#import "Account.h"
#import "AccountTool.h"

@interface meMyMoneyVC ()

@property (nonatomic , strong) UIView * topView;
@property (nonatomic , strong) UILabel * zuanNumLabel;
@property (nonatomic , strong) UILabel * jinNumLabel;
@property (nonatomic , strong) UILabel * yinNumLabel;
@property (nonatomic , strong) UIView * midBackView;
@property (nonatomic , strong) UIView * midBackView2;
@property (nonatomic , strong) UIButton * chargeBtn;


@end

@implementation meMyMoneyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的财产";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setLeft];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [self addView];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_topView removeFromSuperview];
    [_midBackView removeFromSuperview];
    [_midBackView2 removeFromSuperview];
    [_chargeBtn removeFromSuperview];
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
-(void)addView{
    [self addTop];
    [self add2View];
    [self addChargeBtn];
}

-(void)addTop{
    CGFloat h = 50;
    _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kScreenheight, h)];
    [self.view addSubview:_topView];

    CGFloat magin = 15;
    CGFloat H = 20;
    CGFloat w = (kScreenWidth-2*magin)/3;
    self.zuanNumLabel = [moneyImgAndLabel addjinyinImagAndlabelBackViewWithFrame:CGRectMake(magin, 0.5*(h-H), w, H) ImgName:@"zuanshi-me" imgW:23 imgH:22 backView:_topView];
    self.zuanNumLabel.text = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"diamonds"]];

    self.jinNumLabel = [moneyImgAndLabel addjinyinImagAndlabelBackViewWithFrame:CGRectMake(magin+w, 0.5*(h-H), w, H) ImgName:@"jinbi-me" imgW:23 imgH:20 backView:_topView];
    self.jinNumLabel.text = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"gold"]];

    self.yinNumLabel = [moneyImgAndLabel addjinyinImagAndlabelBackViewWithFrame:CGRectMake(magin+2*w, 0.5*(h-H), w, H) ImgName:@"yinbi-me" imgW:23 imgH:22 backView:_topView];
    self.yinNumLabel.text = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"silverCoin"]];

    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, _topView.y+_topView.height, kScreenWidth, 10)];
    line.backgroundColor = YKYColor(242, 242, 242);
    [self.view addSubview:line];

}

-(void)add2View{
    self.midBackView = [myCells addCellsWithH:44 magin:15 ImgvW:23 ImgH:22 backViewY:_topView.y+_topView.height+10 labelW:200 ImgName:@"zuanshi-me" title:@"金币转钻石" ToView:self.view andClickAction:@selector(jinbizhuanzuanshi) VC:self];

    self.midBackView2 = [myCells addCellsWithH:44 magin:16 ImgvW:20 ImgH:22 backViewY:self.midBackView.y+self.midBackView.height labelW:200 ImgName:@"充值记录" title:@"充值记录" ToView:self.view andClickAction:@selector(chongzhijilu) VC:self];
}
-(void)jinbizhuanzuanshi{
    DebugLog(@"金币转钻石");
    meJinzhuanZuanVC * vc = [[meJinzhuanZuanVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)chongzhijilu{
    DebugLog(@"充值记录");
    Account * account = [AccountTool account];
    if (!account) {
        [self jumpToMyaccountVC];
    }else{
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController * vc = [sb instantiateViewControllerWithIdentifier:@"myChargedVC"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}



-(void)addChargeBtn{
    self.chargeBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, kScreenheight-59, kScreenWidth-30, 44)];
    self.chargeBtn.backgroundColor = [UIColor redColor];
    [self.chargeBtn setTitle:@"去充值" forState:UIControlStateNormal];
    [self.chargeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.chargeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:[myFont getTitle2]];
    [self.chargeBtn addTarget:self action:@selector(goCharge) forControlEvents:UIControlEventTouchUpInside];
    //设置图片圆角
    self.chargeBtn.layer.cornerRadius = 5;
    self.chargeBtn.layer.masksToBounds = YES;
    self.chargeBtn.layer.borderWidth = 0.01;
    [self.view addSubview:self.chargeBtn];
}

-(void)goCharge{
    DebugLog(@"去充值");
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController * vc = [sb instantiateViewControllerWithIdentifier:@"newChargeDetailVC"];
    [self.navigationController pushViewController:vc animated:YES];
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
