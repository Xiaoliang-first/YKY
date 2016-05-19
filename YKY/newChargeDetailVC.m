//
//  newChargeDetailVC.m
//  YKY
//
//  Created by 肖亮 on 15/9/17.
//  Copyright (c) 2015年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "newChargeDetailVC.h"
#import "common.h"
#import "UIView+XL.h"
#import "AFNetworking.h"
#import "Account.h"
#import "AccountTool.h"
#import "MBProgressHUD+MJ.h"
#import "chooseChargeWayViewController.h"
#import "myAccountVC.h"
#import <CommonCrypto/CommonCryptor.h>
#import "GTMBase64.h"


@interface newChargeDetailVC ()<UIActionSheetDelegate>

@property (nonatomic , strong) UIImageView * imgView;
@property (weak, nonatomic) UILabel *zuanshiNumLabel;
@property (weak, nonatomic) UILabel *glodNumLabel;
@property (weak, nonatomic) UILabel *silverCoinNumLabel;
/** 所选择的充值金额 */
@property (nonatomic , copy) NSString * money;
/** 赠送的钻石数 */
@property (nonatomic , copy) NSString * zsZuanShi;
/**
 *  后台返回的订单号
 */
@property (nonatomic , copy) NSString * msg;
/** 后台返回的值 */
@property (nonatomic , copy) NSString * Value;
/** weixin后台返回的参数信息数组 */
@property (nonatomic , strong) NSMutableArray * dataArray;



#define k4Y 80
#define k5Y 130
#define k6Y 125
#define k6pY 210



@end

@implementation newChargeDetailVC

#pragma mark - 懒加载数组
-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        self.dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"充值";
    //添加园图和砖石金币银币图
    [self addgudingView];
    Account * account = [AccountTool account];
    if (!account) {
        [MBProgressHUD showError:@"账号信息有误,请重新登录!"];
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(jumpToMyaccountVC) userInfo:nil repeats:NO];
        return;
    }
    [self setLeft];
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

#pragma mark - 添加固定视图
-(void)addgudingView{
    //添加圆心图标
    if (iPhone5) {
        self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.centerX-120, 100, 240, 240)];
    }else if (iPhone6) {
        self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.centerX-140, 110, 280, 280)];
    }else if (iPhone6plus) {
        self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.centerX-150, 110, 300, 300)];
    }else{//iphone4
        self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.centerX-90, 90, 180, 180)];
    }
    self.imgView.image = [UIImage imageNamed:@"yuan-charge"];
    [self.view addSubview:self.imgView];

    //添加钻石金银币图和label
    if (iPhone5) {
        self.zuanshiNumLabel = [self addzuanshiJinbiYinbiWithBackViewFrame:CGRectMake(self.imgView.x+20, self.imgView.y+self.imgView.height-10, 56, 57) imgName:@"zuanshi-charge"];
        self.glodNumLabel = [self addzuanshiJinbiYinbiWithBackViewFrame:CGRectMake(self.view.centerX-28, self.imgView.y+self.imgView.height-10, 56, 57) imgName:@"jinbi-Charge"];
        self.silverCoinNumLabel = [self addzuanshiJinbiYinbiWithBackViewFrame:CGRectMake(self.view.centerX+(self.imgView.centerX-self.imgView.x+10-82), self.imgView.y+self.imgView.height-10, 56, 57) imgName:@"yinbi-Charge"];
    }else if(iPhone6){
        self.zuanshiNumLabel = [self addzuanshiJinbiYinbiWithBackViewFrame:CGRectMake(self.imgView.x+20, self.imgView.y+self.imgView.height, 56, 57) imgName:@"zuanshi-charge"];
        self.glodNumLabel = [self addzuanshiJinbiYinbiWithBackViewFrame:CGRectMake(self.view.centerX-28, self.imgView.y+self.imgView.height, 56, 57) imgName:@"jinbi-Charge"];
        self.silverCoinNumLabel = [self addzuanshiJinbiYinbiWithBackViewFrame:CGRectMake(self.imgView.centerX+(self.imgView.centerX-self.imgView.x+10-90), self.imgView.y+self.imgView.height, 56, 57) imgName:@"yinbi-Charge"];
    }else if (iPhone6plus){
        self.zuanshiNumLabel = [self addzuanshiJinbiYinbiWithBackViewFrame:CGRectMake(self.imgView.x+25, self.imgView.y+self.imgView.height, 56, 57) imgName:@"zuanshi-charge"];
        self.glodNumLabel = [self addzuanshiJinbiYinbiWithBackViewFrame:CGRectMake(self.view.centerX-28, self.imgView.y+self.imgView.height, 56, 57) imgName:@"jinbi-Charge"];
        self.silverCoinNumLabel = [self addzuanshiJinbiYinbiWithBackViewFrame:CGRectMake(self.view.centerX+(self.imgView.centerX-self.imgView.x+10-89), self.imgView.y+self.imgView.height, 56, 57) imgName:@"yinbi-Charge"];
    }else{//iphone4
        self.zuanshiNumLabel = [self addzuanshiJinbiYinbiWithBackViewFrame:CGRectMake(self.imgView.x-10, self.imgView.y+self.imgView.height, 56, 57) imgName:@"zuanshi-charge"];
        self.glodNumLabel = [self addzuanshiJinbiYinbiWithBackViewFrame:CGRectMake(self.view.centerX-26, self.imgView.y+self.imgView.height, 56, 57) imgName:@"jinbi-Charge"];
        self.silverCoinNumLabel = [self addzuanshiJinbiYinbiWithBackViewFrame:CGRectMake(self.view.centerX+(self.imgView.centerX-self.imgView.x+10-50), self.imgView.y+self.imgView.height, 56, 57) imgName:@"yinbi-Charge"];
    }
    //充值
    [self addChargeBtns];
}
-(UILabel*)addzuanshiJinbiYinbiWithBackViewFrame:(CGRect)frame imgName:(NSString*)imgName{
    //back
    UIView * back = [[UIView alloc]initWithFrame:frame];
    back.backgroundColor = [UIColor clearColor];
    [self.view addSubview:back];
    //图
    UIImageView * imgView = [[UIImageView alloc]initWithFrame:CGRectMake(16, 8, 24, 20)];
    imgView.image = [UIImage imageNamed:imgName];
    [back addSubview:imgView];
    //label
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 36, 56, 21)];
    label.font = [UIFont systemFontOfSize:17];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [back addSubview:label];
    return label;
}
#pragma mark - 添加充值按钮们
-(void)addChargeBtns{

    CGFloat backX = 30.0f;
    CGFloat backH = 70.0f;
    if (iPhone5) {
        backX = 30.0f;
        backH = 75.0f;
    }else if (iPhone6){
        backX = 30.0f;
        backH = 90.0f;
    }else if (iPhone6plus){
        backX = 40.0f;
        backH = 90.0f;
    }
    //1.添加背景View
    UIView * back = [[UIView alloc]initWithFrame:CGRectMake(backX, self.imgView.y+self.imgView.height+57+15, kScreenWidth-2*backX, backH)];
    if (iPhone5) {
        back.frame = CGRectMake(backX, self.imgView.y+self.imgView.height+73, kScreenWidth-2*backX, backH);
    }else if (iPhone6){
        back.frame = CGRectMake(backX, self.imgView.y+self.imgView.height+57+30, kScreenWidth-2*backX, backH);
    }else if (iPhone6plus){
        back.frame = CGRectMake(backX, self.imgView.y+self.imgView.height+57+50, kScreenWidth-2*backX, backH);
    }
    back.backgroundColor = [UIColor clearColor];
    [self.view addSubview:back];

    //循环添加按钮绑定tag
    CGFloat margin = 8.0f;
    CGFloat btnsW = (back.width-5*margin)/4;
    CGFloat btnsH = (back.height-2*margin)/2;

    for (int i = 0; i < 8; i++) {
        if (i<4) {
            UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(margin+i*(btnsW+margin), 0.5*margin, btnsW, btnsH)];
            btn.tag = i+6666;
            [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"money-%d",i]] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"smoney-%d",i]] forState:UIControlStateHighlighted];
            [btn addTarget:self action:@selector(recharge:) forControlEvents:UIControlEventTouchUpInside];
            [back addSubview:btn];
            //设置按钮圆角
            btn.layer.cornerRadius = 5;
            btn.layer.masksToBounds = YES;
            btn.layer.borderWidth = 0.01;
        }else{
            UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(margin+(i-4)*(btnsW+margin), 1.5*margin+btnsH, btnsW, btnsH)];
            btn.tag = i+6666;
            [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"money-%d",i]] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"smoney-%d",i]] forState:UIControlStateHighlighted];
            [btn addTarget:self action:@selector(recharge:) forControlEvents:UIControlEventTouchUpInside];
            [back addSubview:btn];
            //设置按钮圆角
            btn.layer.cornerRadius = 5;
            btn.layer.masksToBounds = YES;
            btn.layer.borderWidth = 0.01;
        }
    }

    //注意事项label
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(back.width-60, back.height, 60, 10)];
    label.text = @"注:1元=1钻石";
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:8.0f];
    [back addSubview:label];

    Account * account = [AccountTool account];

    if (account) {
        self.glodNumLabel.text = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"gold"]];
        self.silverCoinNumLabel.text = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"silverCoin"]];
        self.zuanshiNumLabel.text = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"diamonds"]];
    }else{
        [MBProgressHUD showError:@"账号信息有误,请重新登录!"];
    }
}
#pragma mark - 充值按钮们点击触发事件
-(void)recharge:(UIButton*)btn{

    NSArray * array = @[@"1",@"5",@"10",@"20",@"50",@"100",@"200",@"500"];
    NSArray * zArray = @[@"1",@"3",@"7",@"20"];
    int index = (int)btn.tag - 6666;
    self.money = array[index];
    if (index>3) {
        self.zsZuanShi = zArray[index-4];
    }else{
        self.zsZuanShi = @"0";
    }

    //跳新界面充值
    chooseChargeWayViewController * vc = [[chooseChargeWayViewController alloc]init];
    vc.money = self.money;
    vc.zsZuanShi = self.zsZuanShi;
    [self.navigationController pushViewController:vc animated:YES];
}
//单点登录
-(void)jumpToMyaccountVC{
    Account * account2 = [AccountTool account];
    if (account2) {
        //实现当前用户注销（就是把 account.data文件清空）
        account2 = nil;
        [AccountTool saveAccount:account2];
        
        //当前用户注销之后跳转到登陆界面
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        myAccountVC * myAccountVC = [sb instantiateViewControllerWithIdentifier:@"myAccountVC"];
        [self.navigationController pushViewController:myAccountVC animated:YES];
        
    }else{
        //当前用户注销之后跳转到登陆界面
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        myAccountVC * myAccountVC = [sb instantiateViewControllerWithIdentifier:@"myAccountVC"];
        [self.navigationController pushViewController:myAccountVC animated:YES];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [self setUseData];
}

#pragma mark - 设置用户基本信息
-(void)setUseData{
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    Account *account = [AccountTool account];
    if (!account) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        return;
    }
    NSString * str = kmeSetUserDataStr;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    NSDictionary *parameter = @{@"userId":account.uiId,@"client":Kclient,@"serverToken":account.reponseToken};

    [manager POST:str parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {

        [MBProgressHUD hideHUDForView:self.view animated:YES];

        if ([responseObject[@"code"] isEqual:KotherLogin]){
            [MBProgressHUD showError:@"账号已过有效期,请重新登录"];
            [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(jumpToMyaccountVC) userInfo:nil repeats:NO];
        }else if ([responseObject[@"code"] isEqual:@(0)]){
            NSDictionary * dict = responseObject[@"data"][0];
            [[NSUserDefaults standardUserDefaults]setObject:dict[@"gold"] forKey:@"gold"];
            [[NSUserDefaults standardUserDefaults]setObject:dict[@"silver"] forKey:@"silverCoin"];
            [[NSUserDefaults standardUserDefaults]setObject:dict[@"diamonds"] forKey:@"diamonds"];
            
            if (dict[@"gold"]) {
                self.glodNumLabel.text = [NSString stringWithFormat:@"%@",dict[@"gold"]];
            }
            if (dict[@"silver"]) {
                self.silverCoinNumLabel.text = [NSString stringWithFormat:@"%@",dict[@"silver"]];
            }
            if (dict[@"diamonds"]) {
                self.zuanshiNumLabel.text = [NSString stringWithFormat:@"%@",dict[@"diamonds"]];
            }
        }else{
            [MBProgressHUD showError:responseObject[@"msg"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"网络加载失败"];
    }];
}



@end
