//
//  newMeVC.m
//  YKY
//
//  Created by 肖亮 on 15/9/6.
//  Copyright (c) 2015年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "newMeVC.h"
#import "Account.h"
#import "AccountTool.h"
#import "UIImageView+WebCache.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "common.h"
#import "userInfo.h"
#import "UMSocial.h"
#import "myCenterVC.h"
#import "MobClick.h"
#import "UIView+XL.h"
#import "homeTableBarVC.h"
#import "rightImgBtn.h"
#import "meShezhiVC.h"
#import "meZhanghaoVC.h"
#import "myNavViewController.h"
#import "meMyMoneyVC.h"
#import "newBonusVC.h"
#import "meRuningPrizeVC.h"
#import "meSucessVCViewController.h"
#import "meLucksVC.h"
#import "YGPrizeDetailVC.h"
#import "getMyFriendsVC.h"


#define kMargin 15
#define kopenUrl [kbaseURL stringByAppendingString:@"/jiangdou.jsp"]


@interface newMeVC ()<UIScrollViewDelegate>

@property (nonatomic , strong) userInfo * userModel;

/** 滚动scrollView */
@property (nonatomic , strong) UIScrollView * backScrollView;
/** 顶部backView */
@property (nonatomic , strong) UIView * topView;
@property (nonatomic , strong) UIView * moneyBackView;
@property (nonatomic , strong) UIView * the1View;
@property (nonatomic , strong) UIView * the2View;
@property (nonatomic , strong) UIView * the3View;
@property (nonatomic , strong) UIView * the4View;
@property (nonatomic , strong) UIView * lineBottom;

/** 修改back */
@property (nonatomic , strong) UIView * fixBtnsBackView;
/** 音效提醒清缓存back */
@property (nonatomic , strong) UIView * voiceBackView;
/** 消息中心充值记录产品吐槽联系客服 */
@property (nonatomic , strong) UIView * messageBackView;
/** 关于一块摇back */
@property (nonatomic , strong) UIView * aboutYKYBackView;
/** 登录退出按钮 */
@property (strong, nonatomic) UIButton *logAndOutBtn;



/** 头像ImageView */
@property (weak, nonatomic) UIImageView *iconImageView;
/** 用户头像Url */
@property (nonatomic , strong) NSURL * iconUrl;
/** 昵称Label */
@property (weak, nonatomic) UILabel *userNameLabel;
/** 钻石数目label */
@property (nonatomic , weak) UILabel * zuNumLabel;
/** 金币数目Label */
@property (weak, nonatomic) UILabel *goldNmbLabel;
/** 银币数目Label */
@property (weak, nonatomic) UILabel *silverCoinLabel;
/** 编辑按钮Btn */
@property (weak, nonatomic) UIButton *penBtn;
/** 登录或注册按钮 */
@property (weak, nonatomic) UIButton *logOrSinBtn;
/** 金币和银币背景View */
@property (weak, nonatomic) UIView *goldAndSilverBackView;


/** 音效开关 */
@property (weak, nonatomic) UIButton *voiceBtn;
/** 音效开或管标识 */
@property (nonatomic , copy) NSString * on;
/** 到期提醒开关 */
@property (weak, nonatomic) UIButton *remindBtn;
/** 到期提醒开关标识 */
@property (nonatomic , copy) NSString * remindOn;



@end

@implementation newMeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"我的";
    //默认音效开
    NSString * str = [[NSUserDefaults standardUserDefaults]objectForKey:@"on"];
    if (str.length == 0) {
        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"on"];
    }

    [self setRight];

    //添加scrollView
    UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0,self.view.width, self.view.height)];
    self.backScrollView = scrollView;
    self.backScrollView.backgroundColor = YKYColor(242, 242, 242);
    self.backScrollView.delegate = self;
    self.backScrollView.contentSize = CGSizeMake(self.view.width, 0.4*kScreenheight);
    [self.view addSubview:self.backScrollView];

}

-(void)setRight{
    UIBarButtonItem * left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"设置"] style:UIBarButtonItemStylePlain target:self action:@selector(leftClick)];
    left.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = left;
}
-(void)leftClick{
    DebugLog(@"设置按钮被点击");
    meShezhiVC * vc = [[meShezhiVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - willAppear和willDisappear
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //发送广播
    [[NSNotificationCenter defaultCenter] postNotificationName:@"youAreLuckey" object:nil];

    //添加控件
    [self addsubViews];

    if ([AccountTool account]) {
        self.logAndOutBtn.hidden = NO;
    }else{
        self.logAndOutBtn.hidden = YES;
    }
    self.tabBarController.tabBar.hidden = NO;
    [self haveOrNoAccountLogIn];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];

    [navBackClear setNavBackColorWithBar:self.navigationController.navigationBar];

    [self.tabBarController.tabBar.items[4] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];

    [self.the4View removeFromSuperview];
    [self.the3View removeFromSuperview];
    [self.the2View removeFromSuperview];
    [self.topView removeFromSuperview];
    [self.the1View removeFromSuperview];
    [self.moneyBackView removeFromSuperview];
    [self.logAndOutBtn removeFromSuperview];
    [self.lineBottom removeFromSuperview];
}



#pragma mark - 添加控件
-(void)addsubViews{

    Account * account = [AccountTool account];

    [self addTopViews];

    [self add1View];

    UIView * line0 = [[UIView alloc]initWithFrame:CGRectMake(0, self.the1View.y+self.the1View.height, kScreenWidth, 10)];
    line0.backgroundColor = YKYColor(242, 242, 242);
    [self.backScrollView addSubview:line0];

    [self add2View];

    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(0, self.the2View.y+self.the2View.height, kScreenWidth, 10)];
    line1.backgroundColor = YKYColor(242, 242, 242);
    [self.backScrollView addSubview:line1];

    [self add3View];
    [line addLineWithFrame:CGRectMake(kMargin, self.the3View.height-1, kScreenWidth-2*kMargin, 1) andBackView:self.the3View];

    if (account) {
        self.lineBottom = [[UIView alloc]initWithFrame:CGRectMake(0, self.the3View.y+self.the3View.height, kScreenWidth, 10)];
        self.lineBottom.backgroundColor = YKYColor(242, 242, 242);
        [self.backScrollView addSubview:self.lineBottom];

        [self add4View];
    }
//    /** 添加顶部固定View */
//    [self addTopView];
//    
//    //添加修改手机号和修改密码
//    [self addfixBtns];
//    
//    //添加音效提醒清缓存
//    [self addVoiceRemindAndClearBtns];
//    
//    //添加消息中心充值记录产品吐槽联系客服
//    [self addmessageChargeBackView];
//    
//    //添加关于一块摇
//    [self addAboutYKYBack];
//    
//    //添加注销按钮
//    [self addlogOrOutBtn];

}
-(void)addTopViews{
    Account * account = [AccountTool account];
    //导航条颜色
    [navBackClear setNavBackColorClearWithVC:self.navigationController.navigationBar];


    UIView * TopBackView = [[UIView alloc]initWithFrame:CGRectMake(0, -64, self.view.width, 160)];
    //图片
    UIImageView * imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, TopBackView.height)];
    imgBack.image = [UIImage imageNamed:@"topBackImg"];
    [self.backScrollView addSubview:TopBackView];
    [TopBackView addSubview:imgBack];
    self.topView = TopBackView;


    //中间登陆按钮
    CGFloat W = 100.0;
    UIButton * logB = [[UIButton alloc]initWithFrame:CGRectMake(imgBack.centerX-W*0.5, imgBack.centerY-0.3*W, W, W)];
    [logB setTitle:@"登录 | 注册" forState:UIControlStateNormal];
    logB.titleLabel.font = [UIFont systemFontOfSize:[myFont getTitle1]];
    [logB setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logB addTarget:self action:@selector(logOrSinBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [TopBackView addSubview:logB];
    logB.hidden = YES;
    self.logOrSinBtn = logB;


    //头像view
    CGFloat imgW = 75;
    UIView * ico = [[UIView alloc]initWithFrame:CGRectMake(kMargin, 0.45*imgBack.height, imgW, imgW)];
    ico.backgroundColor = YKYColor(253, 153, 147);
    if (account) {
        [TopBackView addSubview:ico];
    }
    UIImageView * iconV = [[UIImageView alloc]initWithFrame:CGRectMake(4, 4, imgW-8, imgW-8)];
    iconV.image = [UIImage imageNamed:@"icon-me"];
    [ico addSubview:iconV];
    self.iconImageView = iconV;
    //设置图片圆角
    iconV.layer.cornerRadius = 0.5*iconV.width;
    iconV.layer.masksToBounds = YES;
    iconV.layer.borderWidth = 0.01;
    //设置图片圆角
    ico.layer.cornerRadius = 0.5*ico.width;
    ico.layer.masksToBounds = YES;
    ico.layer.borderWidth = 0.01;


    //昵称label
    UILabel * nameL = [[UILabel alloc]initWithFrame:CGRectMake(ico.x+ico.width+15, ico.y+0.35*ico.height, 0.5*self.view.width, 20)];
    nameL.font = [UIFont boldSystemFontOfSize:17];
    nameL.textAlignment = NSTextAlignmentLeft;
    nameL.textColor = [UIColor whiteColor];
    [TopBackView addSubview:nameL];
    self.userNameLabel = nameL;


    //账户管理
    CGFloat zhW = 65;
     rightImgBtn * zhanghuBtn = [[rightImgBtn alloc]initWithFrame:CGRectMake(TopBackView.width-zhW-kMargin, nameL.y, zhW, 22)];
    [zhanghuBtn setImage:[UIImage imageNamed:@"jiantou-right"] withTitle:@"账户管理" forState:UIControlStateNormal font:[myFont getTitle2]];
    zhanghuBtn.titleLabel.font = [UIFont systemFontOfSize:[myFont getTitle2]];
    [zhanghuBtn addTarget:self action:@selector(zhanghuBtnClick) forControlEvents:UIControlEventTouchUpInside];
    if (account) {
        [TopBackView addSubview:zhanghuBtn];
    }


//    //去充值按钮
//    CGFloat chargeBtnW = 60;
//    UIButton *chargeBtn = [[UIButton alloc]initWithFrame:CGRectMake(TopBackView.width-kMargin-chargeBtnW, nameL.y+nameL.height+0.4*kMargin, chargeBtnW, 23)];
//    //设置图片圆角
//    chargeBtn.layer.cornerRadius = 2;
//    chargeBtn.layer.masksToBounds = YES;
//    chargeBtn.layer.borderWidth = 0.01;
//    [chargeBtn setTitle:@"去充值" forState:UIControlStateNormal];
//    [chargeBtn setTitleColor:YKYColor(249, 61, 66) forState:UIControlStateNormal];
//    chargeBtn.backgroundColor = [UIColor whiteColor];
//    chargeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
//    chargeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
//    [chargeBtn addTarget:self action:@selector(chargeBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    if (account) {
//        [TopBackView addSubview:chargeBtn];
//    }




    //金银币背景View
    CGFloat myMoneyBackW = 100;
    self.moneyBackView = [[UIView alloc]initWithFrame:CGRectMake(0, TopBackView.y+TopBackView.height, kScreenWidth, 50)];
    self.moneyBackView.backgroundColor = [UIColor whiteColor];
    [_backScrollView addSubview:self.moneyBackView];
    //装载金币跟银币图片个数的view
    self.goldAndSilverBackView = self.moneyBackView;
    //钻
    CGFloat magi = 15;
    CGFloat moneW = ((kScreenWidth-myMoneyBackW)-2*magi)/3;
    CGFloat moneH = 17;
    CGFloat moneY = 0.5*(self.moneyBackView.height-moneH);
    self.zuNumLabel = [moneyImgAndLabel addjinyinImagAndlabelBackViewWithFrame:CGRectMake(magi, moneY, moneW, moneH) ImgName:@"zuanshi-me" imgW:22 imgH:22 backView:self.moneyBackView];
    //金
    self.goldNmbLabel = [moneyImgAndLabel addjinyinImagAndlabelBackViewWithFrame:CGRectMake(1.5*magi+moneW, moneY, moneW, moneH) ImgName:@"jinbi-me" imgW:22 imgH:20 backView:self.moneyBackView];

    //银
    self.silverCoinLabel = [moneyImgAndLabel addjinyinImagAndlabelBackViewWithFrame:CGRectMake(2*magi+2*moneW, moneY, moneW, moneH) ImgName:@"yinbi-me" imgW:22 imgH:22 backView:self.moneyBackView];
    //分界线
    [line addLineWithFrame:CGRectMake(kScreenWidth-myMoneyBackW, 0, 1, self.moneyBackView.height) andBackView:self.moneyBackView];
    //右边view
    CGFloat rigBtnW = 70;
    rightImgBtn * rig = [[rightImgBtn alloc]initWithFrame:CGRectMake(kScreenWidth-rigBtnW-magi, 0, rigBtnW, self.moneyBackView.height)];
    [rig setImage:[UIImage imageNamed:@"jiantou_me"] withTitle:@"我的财产" forState:UIControlStateNormal font:[myFont getTitle3]];
    rig.titleLabel.font = [UIFont systemFontOfSize:[myFont getTitle3]];
    [rig setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [rig addTarget:self action:@selector(myMoneyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.moneyBackView addSubview:rig];

    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(0, self.moneyBackView.y+self.moneyBackView.height, kScreenWidth, 10)];
    line1.backgroundColor = YKYColor(242, 242, 242);
    [self.backScrollView addSubview:line1];
}

#pragma mark - 登录/注册按钮点击事件
- (void)logOrSinBtnClick{
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController * vc = [sb instantiateViewControllerWithIdentifier:@"myAccountVC"];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 账号管理按钮点击事件
-(void)zhanghuBtnClick{
    DebugLog(@"账号管理按钮点击事件");
    meZhanghaoVC * vc = [[meZhanghaoVC alloc]init];
    vc.userName = self.userNameLabel.text;
    vc.iconUrl = self.iconUrl;
    vc.userModel = self.userModel;
    [self.navigationController pushViewController:vc animated:YES];
}
//#pragma mark - 去充值按钮点击事件
//-(void)chargeBtnClick{
//    DebugLog(@"充值按钮点击事件");
//    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    UIViewController * vc = [sb instantiateViewControllerWithIdentifier:@"newChargeDetailVC"];
//    [self.navigationController pushViewController:vc animated:YES];
//}
#pragma mark - 我的财产按钮点击事件
-(void)myMoneyBtnClick{
    DebugLog(@"我的财产按钮被点击");
    meMyMoneyVC * vc = [[meMyMoneyVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 添加邀请好友赚钱承载view
-(void)add1View{
    Account * account = [AccountTool account];
    CGFloat h = 40;
    CGFloat lableH = 17;
    self.the1View = [[UIView alloc]initWithFrame:CGRectMake(0, self.moneyBackView.y+self.moneyBackView.height+10, kScreenWidth, h)];
    if (!account) {
        self.the1View.frame = CGRectMake(0, self.topView.y+self.topView.height+10, kScreenWidth, h);
    }
    self.the1View.backgroundColor = [UIColor whiteColor];
    [self.backScrollView addSubview:self.the1View];

    //label
    UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(kMargin, 0.5*(h-lableH), 190, lableH)];
    title.text = @"邀请好友赚钱";
    title.textColor = YKYTitleColor;
    [self.the1View addSubview:title];
    title.font = [UIFont systemFontOfSize:[myFont getTitle2]];
    UIImageView * jiantou = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-kMargin-8, 0.5*(h-14),8,14)];
    jiantou.image = [UIImage imageNamed:@"jiantou_me"];
    [self.the1View addSubview:jiantou];

    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, h)];
    btn.backgroundColor = [UIColor clearColor];
    [btn addTarget:self action:@selector(getMyFriends) forControlEvents:UIControlEventTouchUpInside];
    [self.the1View addSubview:btn];
}
#pragma mark - 邀请好友赚钱实现方法
-(void)getMyFriends{
    DebugLog(@"=====邀请好友");
    getMyFriendsVC * vc = [[getMyFriendsVC alloc]initWithNibName:@"getMyFriendsVC" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}



#pragma mark - 添加摇一摇奖品承载view
-(void)add2View{
    CGFloat h = 40;
    CGFloat lableH = 17;
    int num = 3;
    NSArray * array = @[@"摇一摇奖品",@"随意摇奖品",@"指定摇奖品"];
    self.the2View = [[UIView alloc]initWithFrame:CGRectMake(0, self.the1View.y+self.the1View.height+10, kScreenWidth, num*h)];
    self.the2View.backgroundColor = [UIColor whiteColor];
    [self.backScrollView addSubview:self.the2View];
    for (int i = 0; i<num; i++) {
        UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(kMargin, i*h+0.5*(h-lableH), 90, lableH)];
        title.text = array[i];
        title.textColor = YKYColor(51, 51, 51);
        [self.the2View addSubview:title];
        if (i==0) {
            title.font = [UIFont systemFontOfSize:[myFont getTitle2]];
            title.textColor = YKYColor(51, 51, 51);
            title.textAlignment = NSTextAlignmentLeft;
            bottomLineBtn * btn = [[bottomLineBtn alloc]initWithFrame:CGRectMake(title.x+title.width-45, title.y+4, kScreenWidth-title.width, 13)];
            [btn setColor:YKYColor(249, 61, 66)];
            [btn setTitleColor:YKYColor(249, 61, 66) forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:[myFont getTitle4]];
            [btn addTarget:self action:@selector(lookOldPrize) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitle:@"(如何查询已使用和已过期的奖品)" forState:UIControlStateNormal];
            [self.the2View addSubview:btn];
            [line addLineWithFrame:CGRectMake(kMargin, (i+1)*h-1, kScreenWidth-2*kMargin, 1) andBackView:self.the2View];
        }else{
            title.frame = CGRectMake(2*kMargin,i*h+0.5*(h-lableH), 100, lableH);
            title.textColor = YKYColor(102, 102, 102);
            title.font = [UIFont systemFontOfSize:[myFont getTitle3]];
            UIImageView * jiantou = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-kMargin-8, i*h+0.5*(h-14),8,14)];
            jiantou.image = [UIImage imageNamed:@"jiantou_me"];
            [self.the2View addSubview:jiantou];
            if (i==1) {
                [line addLineWithFrame:CGRectMake(kMargin, (i+1)*h-1, kScreenWidth-2*kMargin, 1) andBackView:self.the2View];
            }
            UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(0, i*h, kScreenWidth, h)];
            btn.backgroundColor = [UIColor clearColor];
            btn.tag = i+42340;
            [btn addTarget:self action:@selector(prizeKindBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.the2View addSubview:btn];
        }
    }
}
-(void)lookOldPrize{
    DebugLog(@"查看已使用和已过期");
    YGPrizeDetailVC * vc = [[YGPrizeDetailVC alloc]init];
    vc.vcTitle = @"已使用和已过期";
    vc.requestUrl = [NSURL URLWithString:kopenUrl];
    [self.navigationController pushViewController:vc animated:YES];
//    [self jumpToSafari];
}
/** Safari打开已使用已过期网址 */
-(void)jumpToSafari{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kopenUrl]];
}


-(void)prizeKindBtnClick:(UIButton *)btn{
    Account * account = [AccountTool account];
    if (!account) {
        [self jumpToMyaccountVC];
        return;
    }
    switch (btn.tag-42340) {
        case 1:
            DebugLog(@"随意摇");
            [self suiyiyao];
            break;
        case 2:
            DebugLog(@"指定摇");
            [self huodongyao];
            break;
        default:
            break;
    }
}

-(void)suiyiyao{
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    newBonusVC * vc = [sb instantiateViewControllerWithIdentifier:@"newBonusVC"];
    vc.titleStr = @"随意摇奖品";
    [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"couponsType"];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)huodongyao{
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    newBonusVC * vc = [sb instantiateViewControllerWithIdentifier:@"newBonusVC"];
    vc.titleStr = @"指定摇奖品";
    [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"couponsType"];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - 摇购奖品backView
-(void)add3View{
    CGFloat h = 40;
    CGFloat lableH = 17;
    int num = 4;
    NSArray * array = @[@"摇购奖品",@"进行中",@"已揭晓",@"幸运兜"];
    self.the3View = [[UIView alloc]initWithFrame:CGRectMake(0, self.the2View.y+self.the2View.height+10, kScreenWidth, num*h)];
    self.the3View.backgroundColor = [UIColor whiteColor];
    [self.backScrollView addSubview:self.the3View];


    for (int i = 0; i<num; i++) {
        UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(kMargin, i*h+0.5*(h-lableH), 80, lableH)];
        title.text = array[i];
        title.textColor = YKYColor(51, 51, 51);
        [self.the3View addSubview:title];
        if (i==0) {
            title.font = [UIFont systemFontOfSize:[myFont getTitle2]];
            title.textAlignment = NSTextAlignmentLeft;
            [line addLineWithFrame:CGRectMake(kMargin, (i+1)*h-1, kScreenWidth-2*kMargin, 1) andBackView:self.the3View];
        }else{
            title.frame = CGRectMake(2*kMargin,i*h+0.5*(h-lableH), 100, lableH);
            title.textColor = YKYColor(102, 102, 102);
            title.font = [UIFont systemFontOfSize:[myFont getTitle3]];
            UIImageView * jiantou = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-kMargin-8, i*h+0.5*(h-14),8,14)];
            jiantou.image = [UIImage imageNamed:@"jiantou_me"];
            [self.the3View addSubview:jiantou];
            if (i!=3) {
                [line addLineWithFrame:CGRectMake(kMargin, (i+1)*h-1, kScreenWidth-2*kMargin, 1) andBackView:self.the3View];
            }
            UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(0, i*h, kScreenWidth, h)];
            btn.backgroundColor = [UIColor clearColor];
            btn.tag = i+52340;
            [btn addTarget:self action:@selector(yaogouBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.the3View addSubview:btn];
        }
    }
    self.backScrollView.contentSize = CGSizeMake(kScreenWidth, self.the3View.y+self.the3View.height+kMargin+44);
}

-(void)yaogouBtnClick:(UIButton*)btn{
    Account * account = [AccountTool account];
    if (!account) {
        [self jumpToMyaccountVC];
        return;
    }
    meRuningPrizeVC * rockIngvc = [[meRuningPrizeVC alloc]init];
    meSucessVCViewController * SuccessVC = [[meSucessVCViewController alloc]init];
    meLucksVC * luckVC = [[meLucksVC alloc]init];


    switch (btn.tag-52340) {
        case 1:
            DebugLog(@"进行中");
            [self.navigationController pushViewController:rockIngvc animated:YES];
            break;
        case 2:
            DebugLog(@"已揭晓");
            [self.navigationController pushViewController:SuccessVC animated:YES];
            break;
        case 3:
            DebugLog(@"幸运摇购");
            [self.navigationController pushViewController:luckVC animated:YES];
            break;

        default:
            break;
    }
}

#pragma mark - 登陆承载view
-(void)add4View{

    self.the4View = [[UIView alloc]initWithFrame:CGRectMake(0, _the3View.height+_the3View.y+30, kScreenWidth, 44)];
    self.the4View.backgroundColor = [UIColor whiteColor];
    [self.backScrollView addSubview:self.the4View];

    //登陆按钮
//    [line addLineWithFrame:CGRectMake(0, _the3View.height+_the3View.y+44, kScreenWidth, 1) andBackView:self.backScrollView];
    self.logAndOutBtn = [[UIButton alloc]initWithFrame:CGRectMake(kMargin, 0, kScreenWidth-2*kMargin, 44)];
    self.logAndOutBtn.backgroundColor = [UIColor clearColor];
    [self.logAndOutBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    self.logAndOutBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.logAndOutBtn setTitle:@"安全退出" forState:UIControlStateNormal];
    self.logAndOutBtn.titleLabel.font = [UIFont boldSystemFontOfSize:[myFont getTitle2]];
    [self.logAndOutBtn addTarget:self action:@selector(logAndOutBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.the4View addSubview:self.logAndOutBtn];
//    [line addLineWithFrame:CGRectMake(0, _the3View.height+_the3View.y+88, kScreenWidth, 1) andBackView:self.backScrollView];

    //重置滚动位置
    self.backScrollView.contentSize = CGSizeMake(kScreenWidth, self.the4View.y+self.the4View.height+3*kMargin);

}
#pragma mark - 登录退出按钮点击事件
- (void)logAndOutBtnClick {
    //当前用户注销之后跳转到登陆界面
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController * myAccountVC = [sb instantiateViewControllerWithIdentifier:@"myAccountVC"];
    Account * account = [AccountTool account];
    if (account) {//有用户登录
        //实现当前用户注销（就是把 account.data文件清空）
        [self logOutORNo];
    }else{//没有用户登录
        //取消所有的本地通知
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

        [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"gold"];
        [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"silverCoin"];

        [self.navigationController pushViewController:myAccountVC animated:YES];
    }
}

-(void)logOutORNo{
    [MBProgressHUD showMessage:@"正在注销..." toView:self.view];
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    NSString * bindPath = @"/user/logout";
    [XLRequest AFPostHost:kbaseURL bindPath:bindPath postParam:parameter isClient:YES getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        DebugLog(@"注销结果=%@",responseDic);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([responseDic[@"code"] isEqual:@0]) {
            [MBProgressHUD showSuccess:@"退出成功!"];
        }else if ([responseDic[@"code"] isEqual:KotherLogin]){
//            [MBProgressHUD showError:@"您的账号在别处登录,如非本人操作请修改密码!"];
            UIAlertView * alter = [[UIAlertView alloc]initWithTitle:@"警示:" message:@"您的账号已在别处登录,如非本人操作请立即修改密码!" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alter show];
        }
        [self logOut];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"网络加载失败,请检查网路!"];
    }];
}

#pragma mark - 注销登陆
-(void)logOut{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController * myAccountVC = [sb instantiateViewControllerWithIdentifier:@"myAccountVC"];
    Account * account = [AccountTool account];
    account = nil;
    [AccountTool saveAccount:account];
    [[UMSocialDataService defaultDataService] requestUnOauthWithType:UMShareToSina  completion:^(UMSocialResponseEntity *response){

    }];
    [[UMSocialDataService defaultDataService] requestUnOauthWithType:UMShareToQQ completion:^(UMSocialResponseEntity *response){

    }];
    [[UMSocialDataService defaultDataService] requestUnOauthWithType:UMShareToWechatSession completion:^(UMSocialResponseEntity *response){

    }];
    [MobClick profileSignOff];
    self.userModel = nil;
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"fixedUserName"];

    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"myAge"];

    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"sex"];

    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"myHopy"];

    [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"gold"];
    [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"silverCoin"];

    //取消所有的本地通知
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

    self.logAndOutBtn.hidden = YES;

    [self.navigationController pushViewController:myAccountVC animated:YES];
}


#pragma mark - 判断有误用户登录
-(BOOL)haveOrNoAccountLogIn{
    Account * account = [AccountTool account];
    //判断是否有用户登录
    if (account) {
        self.iconImageView.hidden = NO;
        self.userNameLabel.hidden = NO;
        self.goldAndSilverBackView.hidden = NO;
        self.penBtn.hidden = NO;
        self.logOrSinBtn.hidden = YES;
        //获取用户基本信息
        [self setUseData];
        return YES;
    }else{
        self.iconImageView.hidden = YES;
        self.userNameLabel.hidden = YES;
        self.goldAndSilverBackView.hidden = YES;
        self.penBtn.hidden = YES;
        self.logOrSinBtn.hidden = NO;
        return NO;
    }
}
#pragma mark - 获取用户基本信息
-(void)setUseData{
    Account *account = [AccountTool account];

    NSString * str = kmeSetUserDataStr;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    if (!account.uiId || !account.reponseToken || !Kclient) {
        return;
    }

    NSDictionary *parameter = @{@"client":Kclient,@"userId":account.uiId,@"serverToken":account.reponseToken};

    [manager POST:str parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DebugLog(@"=====登陆返回信息=%@",responseObject);
        if ([responseObject[@"code"] isEqual:KotherLogin]){
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showError:@"账号已过有效期,请重新登录"];
            [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(jumpToMyaccountVC) userInfo:nil repeats:NO];
        }else if ([responseObject[@"code"] isEqual:@(0)]){
            [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@", responseObject[@"data"][0][@"sex"]] forKey:@"sex"];
            if (responseObject[@"data"] == nil) {
                return;
            }
            [[NSUserDefaults standardUserDefaults]setObject:responseObject[@"data"][0][@"gold"] forKey:@"gold"];
            [[NSUserDefaults standardUserDefaults]setObject:responseObject[@"data"][0][@"silver"] forKey:@"silverCoin"];
            [[NSUserDefaults standardUserDefaults]setObject:responseObject[@"data"][0][@"diamonds"] forKey:@"diamonds"];

            self.userModel = [userInfo accountWithDict:responseObject[@"data"][0]];
            //设置界面信息
            [self setDataOnScreen];

        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showError:responseObject[@"msg"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
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
#pragma mark - 设置界面信息
-(void)setDataOnScreen{

    if (self.userModel.uiGoldCoin) {
        self.goldNmbLabel.text = [NSString stringWithFormat:@"%@",self.userModel.uiGoldCoin];
    }
    if (self.userModel.diamonds) {
        self.zuNumLabel.text = [NSString stringWithFormat:@"%@",self.userModel.diamonds];
    }else{
        self.zuNumLabel.text = @"0";
    }
    if (self.userModel.uiSilverCoin) {
        self.silverCoinLabel.text = [NSString stringWithFormat:@"%@",self.userModel.uiSilverCoin];
    }
    if (self.userModel.uiName.length != 0) {
        self.userNameLabel.text = self.userModel.uiName;
    }else{
        self.userNameLabel.text = @"昵称";
    }
    if (self.userModel.uiHeadImage) {
        [[SDImageCache sharedImageCache] clearDisk];
        [[SDImageCache sharedImageCache] clearMemory];
        self.iconUrl = [NSURL URLWithString:self.userModel.uiHeadImage];
        [self.iconImageView setImage:[UIImage imageNamed:@"icon-me"]];
        [self.iconImageView sd_setImageWithURL:self.iconUrl placeholderImage:[UIImage imageNamed:@"icon-me"]];
    }else{
        [[SDImageCache sharedImageCache] clearDisk];
        [[SDImageCache sharedImageCache] clearMemory];
        [self.iconImageView setImage:[UIImage imageNamed:@"icon-me"]];
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}


#pragma mark - scrollviewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y>-55) {
        [navBackClear setNavBackColorWithBar:self.navigationController.navigationBar];
    }else{
        [navBackClear setNavBackColorClearWithVC:self.navigationController.navigationBar];
    }
}

























//
//#pragma mark - ******************添加灰线********************
//-(void)addLineWithSuperView:(UIView *)superView andFrame:(CGRect)frame {
//    UIView * lineView = [[UIView alloc]initWithFrame:frame];
//    lineView.backgroundColor = [UIColor colorWithRed:230.0/255.0f green:230.0/255.0f blue:230.0/255.0f alpha:1.0f];
//    [superView addSubview:lineView];
//}
//#pragma mark - 添加修改手机号和修改密码按钮
//-(void)addfixBtns{
//    //背景
//    UIView * fixBackView = [[UIView alloc]initWithFrame:CGRectMake(0, self.topView.height+10, self.view.height, 80)];
//    fixBackView.backgroundColor = [UIColor whiteColor];
//    [self.backScrollView addSubview:fixBackView];
//
//    //手机
//    UIImageView * shouji = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 16, 22)];
//    shouji.image = [UIImage imageNamed:@"手机"];
//    [fixBackView addSubview:shouji];
//    //修改手机号Label
//    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(shouji.x+shouji.width+14, 10, 200, 20)];
//    label.text = @"修改手机号";
//    label.font = [UIFont systemFontOfSize:14];
//    label.textColor = [UIColor darkGrayColor];
//    [fixBackView addSubview:label];
//    //中线
//    [self addLineWithSuperView:fixBackView andFrame:CGRectMake(label.x, 39, self.view.width-label.x, 1)];
//    //修改手机号Btn
//    UIButton * fixBt = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 40)];
//    fixBt.backgroundColor = [UIColor clearColor];
//    [fixBt addTarget:self action:@selector(fixPhoneNumberBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [fixBackView addSubview:fixBt];
//    
//    //锁图
//    UIImageView * suo = [[UIImageView alloc]initWithFrame:CGRectMake(15, 50, 16, 22)];
//    suo.image = [UIImage imageNamed:@"密码"];
//    [fixBackView addSubview:suo];
//    //修改密码label
//    UILabel * fixPwdL = [[UILabel alloc]initWithFrame:CGRectMake(label.x, 50, 200, 20)];
//    fixPwdL.text = @"修改密码";
//    fixPwdL.font = [UIFont systemFontOfSize:14];
//    fixPwdL.textColor = [UIColor darkGrayColor];
//    [fixBackView addSubview:fixPwdL];
//    //修改密码按钮
//    UIButton * fixPwdBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 40, self.view.width, 40)];
//    fixPwdBtn.backgroundColor = [UIColor clearColor];
//    [fixPwdBtn addTarget:self action:@selector(fixPwdBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [fixBackView addSubview:fixPwdBtn];
//    
//    self.fixBtnsBackView = fixBackView;
//}
//#pragma mark - 添加音效提醒清缓存
//-(void)addVoiceRemindAndClearBtns{
//    
//    //backView
//    UIView * back2View = [[UIView alloc]initWithFrame:CGRectMake(0, self.fixBtnsBackView.y+ self.fixBtnsBackView.height+10, self.view.width, 120)];
//    back2View.backgroundColor = [UIColor whiteColor];
//    [self.backScrollView addSubview:back2View];
//    
//    //顶线
//    //ling
//    UIImageView * ling = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 16, 20)];
//    ling.image = [UIImage imageNamed:@"音效"];
//    [back2View addSubview:ling];
//    //音效label
//    UILabel * voiceL = [[UILabel alloc]initWithFrame:CGRectMake(ling.x+ling.width+14, 10, 60, 20)];
//    voiceL.text = @"音效";
//    voiceL.font = [UIFont systemFontOfSize:14];
//    voiceL.textColor = [UIColor darkGrayColor];
//    [back2View addSubview:voiceL];
//    //音效开关
//    CGFloat w = 45;
//    CGFloat h = 24;
//    UIButton * voiveBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.width-w*1.5, 10, w, h)];
//    [voiveBtn setBackgroundImage:[UIImage imageNamed:@"yinxiaokai"] forState:UIControlStateNormal];
//    [voiveBtn addTarget:self action:@selector(voiceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [back2View addSubview:voiveBtn];
//    self.voiceBtn = voiveBtn;
//    //zhongxan
//    [self addLineWithSuperView:back2View andFrame:CGRectMake(voiceL.x, 40, self.view.width-voiceL.x, 1)];
//    //闹钟图
//    UIImageView * naozhong = [[UIImageView alloc]initWithFrame:CGRectMake(15, 50, 17, 19)];
//    naozhong.image = [UIImage imageNamed:@"到期提醒"];
//    [back2View addSubview:naozhong];
//    //到期提醒label
//    UILabel * tixingL = [[UILabel alloc]initWithFrame:CGRectMake(voiceL.x, 50, 80, 20)];
//    tixingL.font = [UIFont systemFontOfSize:14];
//    tixingL.textColor = [UIColor darkGrayColor];
//    tixingL.text = @"到期提醒";
//    [back2View addSubview:tixingL];
//    //提醒btn
//    UIButton * tixingBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.width-w*1.5, 50, w, h)];
//    [tixingBtn setBackgroundImage:[UIImage imageNamed:@"yinxiaokai"] forState:UIControlStateNormal];
//    [tixingBtn addTarget:self action:@selector(remindBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [back2View addSubview:tixingBtn];
//    self.remindBtn = tixingBtn;
//    //中线
//    [self addLineWithSuperView:back2View andFrame:CGRectMake(voiceL.x, 80, self.view.width-voiceL.x, 1)];
//    //垃圾桶图
//    UIImageView * clearImgV = [[UIImageView alloc]initWithFrame:CGRectMake(15, 90, 16, 20)];
//    clearImgV.image = [UIImage imageNamed:@"清除缓存"];
//    [back2View addSubview:clearImgV];
//    //清缓存lbel
//    UILabel * clearL = [[UILabel alloc]initWithFrame:CGRectMake(voiceL.x, 90, 90, 20)];
//    clearL.text = @"清空缓存";
//    clearL.font = [UIFont systemFontOfSize:14];
//    clearL.textColor = [UIColor darkGrayColor];
//    [back2View addSubview:clearL];
//    //底线
//    //清空缓存按钮
//    UIButton * clearBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 80, self.view.width, 40)];
//    clearBtn.backgroundColor = [UIColor clearColor];
//    [back2View addSubview:clearBtn];
//    [clearBtn addTarget:self action:@selector(cleanBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    self.voiceBackView = back2View;
//}
//#pragma mark - 消息中心充值记录产品吐槽联系客服
//-(void)addmessageChargeBackView{
//    
//    //back3View
//    UIView * back3View = [[UIView alloc]initWithFrame:CGRectMake(0, self.voiceBackView.y+self.voiceBackView.height+10, self.view.width, 160)];
//    back3View.backgroundColor = [UIColor whiteColor];
//    [self.backScrollView addSubview:back3View];
//    
//    //消息中心
//    UIImageView * msgImg = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 16, 23)];
//    msgImg.image = [UIImage imageNamed:@"消息中心"];
//    [back3View addSubview:msgImg];
//    
//    UILabel * msgL = [[UILabel alloc]initWithFrame:CGRectMake(msgImg.x+msgImg.width+14, 10, 80, 20)];
//    msgL.font = [UIFont systemFontOfSize:14];
//    msgL.textColor = [UIColor darkGrayColor];
//    msgL.text = @"消息中心";
//    [back3View addSubview:msgL];
//    
//    UIButton * msgBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 40)];
//    msgBtn.backgroundColor = [UIColor clearColor];
//    [back3View addSubview:msgBtn];
//    [msgBtn addTarget:self action:@selector(messageCenterBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    
//    //充值记录
//    [self addLineWithSuperView:back3View andFrame:CGRectMake(msgL.x, 40, self.view.width-msgL.x, 1)];
//    UIImageView * chargeImgV = [[UIImageView alloc]initWithFrame:CGRectMake(15, 50, 16, 22)];
//    chargeImgV.image = [UIImage imageNamed:@"充值记录"];
//    [back3View addSubview:chargeImgV];
//    
//    UILabel * chargeL = [[UILabel alloc]initWithFrame:CGRectMake(chargeImgV.x+chargeImgV.width+14, 50, 80, 20)];
//    chargeL.textColor = [UIColor darkGrayColor];
//    chargeL.font = [UIFont systemFontOfSize:14];
//    chargeL.text = @"充值记录";
//    [back3View addSubview:chargeL];
//    
//    UIButton * chargeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 40, self.view.width, 40)];
//    chargeBtn.backgroundColor = [UIColor clearColor];
//    [chargeBtn addTarget:self action:@selector(rechargeRecordBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [back3View addSubview:chargeBtn];
//    
//    //产品吐槽
//    [self addLineWithSuperView:back3View andFrame:CGRectMake(chargeL.x-2, 80, self.view.width-chargeL.x ,1)];
//    UIImageView * tucaoImgV = [[UIImageView alloc]initWithFrame:CGRectMake(15, 90, 16, 22 )];
//    tucaoImgV.image = [UIImage imageNamed:@"产品吐槽"];
//    [back3View addSubview:tucaoImgV];
//    
//    UILabel * tucaoL = [[UILabel alloc]initWithFrame:CGRectMake(chargeL.x, 90, 80, 20)];
//    tucaoL.font = [UIFont systemFontOfSize:14];
//    tucaoL.text = @"产品吐槽";
//    tucaoL.textColor = [UIColor darkGrayColor];
//    [back3View addSubview:tucaoL];
//    
//    UIButton * tucaoBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 80, self.view.width, 40)];
//    [tucaoBtn addTarget:self action:@selector(productTucaoBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    tucaoBtn.backgroundColor = [UIColor clearColor];
//    [back3View addSubview:tucaoBtn];
//    
//    //联系客服
//    [self addLineWithSuperView:back3View andFrame:CGRectMake(tucaoL.x, 120, self.view.width-tucaoL.x, 1)];
//    UIImageView * callImg = [[UIImageView alloc]initWithFrame:CGRectMake(15, 130, 16, 22)];
//    callImg.image = [UIImage imageNamed:@"联系客服"];
//    [back3View addSubview:callImg];
//    
//    UILabel * callL = [[UILabel alloc]initWithFrame:CGRectMake(tucaoL.x, 130, 80, 20)];
//    callL.font = [UIFont systemFontOfSize:14];
//    callL.textColor = [UIColor darkGrayColor];
//    callL.text = @"联系客服";
//    [back3View addSubview:callL];
//
//    UIButton * callBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 120, self.view.width, 40)];
//    callBtn.backgroundColor = [UIColor clearColor];
//    [callBtn addTarget:self action:@selector(callSeverBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [back3View addSubview:callBtn];
//    
//    self.messageBackView = back3View;
//    
//}
//#pragma mark - 关于一块摇
//-(void)addAboutYKYBack{
//    UIView * ykyBack = [[UIView alloc]initWithFrame:CGRectMake(0, self.messageBackView.y+self.messageBackView.height+10, self.view.width, 40)];
//    ykyBack.backgroundColor = [UIColor whiteColor];
//    [self.backScrollView addSubview:ykyBack];
//    UIImageView * abYKYImg = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 17, 18)];
//    abYKYImg.image = [UIImage imageNamed:@"一块摇23"];
//    [ykyBack addSubview:abYKYImg];
//    
//    UILabel * abYKYL = [[UILabel alloc]initWithFrame:CGRectMake(abYKYImg.x+abYKYImg.width+12, 10, 90, 20)];
//    abYKYL.font = [UIFont systemFontOfSize:14];
//    abYKYL.text = @"关于一块摇";
//    abYKYL.textColor = [UIColor darkGrayColor];
//    [ykyBack addSubview:abYKYL];
//    
//    UIButton * abYBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 40)];
//    abYBtn.backgroundColor = [UIColor clearColor];
//    [abYBtn addTarget:self action:@selector(aboutRockingBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [ykyBack addSubview:abYBtn];
//    
//    self.aboutYKYBackView = ykyBack;
//}
//
//
//
//#pragma mark - 添加注销按钮
//-(void)addlogOrOutBtn{
//    UIButton * logBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, self.aboutYKYBackView.y+self.aboutYKYBackView.height+10, self.view.width, 40)];
//    logBtn.backgroundColor = [UIColor whiteColor];
//    [logBtn setTitle:@"注销登录" forState:UIControlStateNormal];
//    [logBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
//    logBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    [logBtn addTarget:self action:@selector(logAndOutBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.backScrollView addSubview:logBtn];
//    self.logAndOutBtn = logBtn;
//    self.backScrollView.contentSize = CGSizeMake(self.view.width, logBtn.y+logBtn.height-200);
//}





//#pragma mark - 修改个人信息按钮点击事件
//- (void)penBtnClick{
//    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    myCenterVC *vc = [sb instantiateViewControllerWithIdentifier:@"myCenterVC"];
//    vc.userName = self.userNameLabel.text;
//    vc.iconUrl = [NSString stringWithFormat:@"%@",self.iconUrl];
//    vc.userInfoModel = self.userModel;
//    [self.navigationController pushViewController:vc animated:YES];
//}
//#pragma mark - 修改电话号码按钮点击事件
//- (void)fixPhoneNumberBtnClick{
//    Account * account = [AccountTool account];
//    if (!account) {
//        [self jumpToMyaccountVC];
//    }else{
//        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        UIViewController * vc = [sb instantiateViewControllerWithIdentifier:@"fixPhoneNumberVC"];
//        [self.navigationController pushViewController:vc animated:YES];
//    }
//}
//#pragma mark - 修改密码按钮点击事件
//- (void)fixPwdBtnClick{
//    Account * account = [AccountTool account];
//    if (!account) {
//        [self jumpToMyaccountVC];
//    }else{
//        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        UIViewController * vc = [sb instantiateViewControllerWithIdentifier:@"fixPwdVC"];
//        [self.navigationController pushViewController:vc animated:YES];
//    }
//}
//#pragma mark - 音效开关按钮点击事件
//- (void)voiceBtnClick:(id)sender {
//    
//    if ([self.on isEqualToString:@"0"]) {//打开音效
//        [sender setBackgroundImage:[UIImage imageNamed:@"yinxiaokai"] forState:UIControlStateNormal];
//        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"on"];
//        self.on = @"1";
//    }else{//关闭音效
//        [sender setBackgroundImage:[UIImage imageNamed:@"yinxiaoguan"] forState:UIControlStateNormal];
//        [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"on"];
//        self.on = @"0";
//    }
//}
//#pragma mark - 到期提醒按钮点击事件
//- (void)remindBtnClick:(id)sender {
//    if ([self.remindOn isEqualToString:@"0"]) {//打开提醒
//        [sender setBackgroundImage:[UIImage imageNamed:@"yinxiaokai"] forState:UIControlStateNormal];
//        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"remindOn"];
//        self.remindOn = @"1";
//    }else{//关闭提醒
//        [sender setBackgroundImage:[UIImage imageNamed:@"yinxiaoguan"] forState:UIControlStateNormal];
//        [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"remindOn"];
//        //取消所有提醒
//        [[UIApplication sharedApplication]cancelAllLocalNotifications];
//        self.remindOn = @"0";
//    }
//}
//#pragma mark - 清除缓存按钮点击事件
//- (void)cleanBtnClick{
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    [[SDImageCache sharedImageCache] clearDisk];
//    [[SDImageCache sharedImageCache] clearMemory];
//    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(labelDissmis2) userInfo:nil repeats:NO];
//}
//#pragma mark - 清理缓存成功
//-(void)labelDissmis2{
//    [MBProgressHUD hideHUDForView:self.view];
//    [MBProgressHUD showSuccess:@"缓存清理成功!"];
//}
//#pragma mark - 消息中心按钮点击事件
//- (void)messageCenterBtnClick{
//    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    UITableViewController * vc = [sb instantiateViewControllerWithIdentifier:@"messageCenterVC"];
//    [self.navigationController pushViewController:vc animated:YES];
//}
//#pragma mark - 充值记录按钮点击事件
//- (void)rechargeRecordBtnClick{
//    Account * account = [AccountTool account];
//    if (!account) {
//        [self jumpToMyaccountVC];
//    }else{
//        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        UIViewController * vc = [sb instantiateViewControllerWithIdentifier:@"myChargedVC"];
//        [self.navigationController pushViewController:vc animated:YES];
//    }
//}
//#pragma mark - 产品吐槽按钮点击事件
//- (void)productTucaoBtnClick{
//    Account * account = [AccountTool account];
//    if (!account) {
//        [self jumpToMyaccountVC];
//    }else{
//        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        UIViewController * vc = [sb instantiateViewControllerWithIdentifier:@"freeTalkVC"];
//        [self.navigationController pushViewController:vc animated:YES];
//    }
//}
//#pragma mark - 联系客服按钮点击事件
//- (void)callSeverBtnClick{
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"拨号" message:@"服务电话:4006464158" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    [alert show];
//    
//}
//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    switch (buttonIndex) {
//        case 0:
//            break;
//        case 1:
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4006464158"]];//打电话
//            break;
//        default:
//            break;
//    }
//}
//#pragma mark - 关于一块摇按钮点击事件
//- (void)aboutRockingBtnClick{
//    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    UIViewController * vc = [sb instantiateViewControllerWithIdentifier:@"newAboutRockingVC"];
//    [self.navigationController pushViewController:vc animated:YES];
//}
//
//
//
//
//



@end



