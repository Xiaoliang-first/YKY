//
//  meShezhiVC.m
//  YKY
//
//  Created by 肖 亮 on 16/4/14.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "meShezhiVC.h"

@interface meShezhiVC ()

/** 音效开关 */
@property (weak, nonatomic) UIButton *voiceBtn;
/** 音效开或管标识 */
@property (nonatomic , copy) NSString * on;
/** 到期提醒开关 */
@property (weak, nonatomic) UIButton *remindBtn;
/** 到期提醒开关标识 */
@property (nonatomic , copy) NSString * remindOn;



@end

@implementation meShezhiVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = YKYColor(242, 242, 242);
    self.title = @"设置";
    //默认音效开
    NSString * str = [[NSUserDefaults standardUserDefaults]objectForKey:@"on"];
    if (str.length == 0) {
        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"on"];
    }
    [self setLeft];
    [self addViews];
}

-(void)viewWillAppear:(BOOL)animated{
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


-(void)addViews{
    CGFloat h = 44;
    CGFloat magin = 15;

    //消息中心
    UIView * view1 = [self addCellWithH:h magin:magin viewFrame:CGRectMake(0,74, kScreenWidth, h) title:@"消息中心" action:@selector(messageCenterBtnClick)];


    //音效backView
    UIView * view2 = [[UIView alloc]initWithFrame:CGRectMake(0, view1.y+view1.height, kScreenWidth, h)];
    view2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view2];
    //ling
    CGFloat voiceLH = 20;
    //音效label
    UILabel * voiceL = [[UILabel alloc]initWithFrame:CGRectMake(magin, 0.5*(h-voiceLH), 60, voiceLH)];
    voiceL.text = @"音效";
    voiceL.font = [UIFont systemFontOfSize:[myFont getTitle2]];
    voiceL.textColor = [UIColor darkGrayColor];
    [view2 addSubview:voiceL];
    //音效开关
    CGFloat vioW = 45;
    CGFloat vioH = 24;
    UIButton * voiveBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.width-vioW*1.5, 0.5*(h-voiceLH), vioW, vioH)];
    NSString * openStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"on"];
    if ([openStr isEqualToString:@"0"]) {
        [voiveBtn setBackgroundImage:[UIImage imageNamed:@"yinxiaoguan"] forState:UIControlStateNormal];
    }else{
        [voiveBtn setBackgroundImage:[UIImage imageNamed:@"yinxiaokai"] forState:UIControlStateNormal];
    }
    [voiveBtn addTarget:self action:@selector(voiceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view2 addSubview:voiveBtn];
    self.voiceBtn = voiveBtn;
    [line addLineWithFrame:CGRectMake(voiceL.x, h-1, kScreenWidth-voiceL.x, 1) andBackView:view2];


    //到期提醒backView
//    CGFloat naoW = 17;
    CGFloat naoH = 19;
    UIView * view3 = [[UIView alloc]initWithFrame:CGRectMake(0, view2.y+view2.height, kScreenWidth, h)];
    view3.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view3];
//    //闹钟图
//    UIImageView * naozhong = [[UIImageView alloc]initWithFrame:CGRectMake(magin, 0.5*(h-naoH), naoW, naoH)];
//    naozhong.image = [UIImage imageNamed:@"到期提醒"];
//    [view3 addSubview:naozhong];
    //到期提醒label
    UILabel * tixingL = [[UILabel alloc]initWithFrame:CGRectMake(voiceL.x, 10, 80, 20)];
    tixingL.font = [UIFont systemFontOfSize:[myFont getTitle2]];
    tixingL.textColor = [UIColor darkGrayColor];
    tixingL.text = @"到期提醒";
    [view3 addSubview:tixingL];
    //提醒btn
    UIButton * tixingBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.width-vioW*1.5, 0.5*(h-naoH), vioW, vioH)];
    NSString * openStr1 = [[NSUserDefaults standardUserDefaults]objectForKey:@"remindOn"];
    if ([openStr1 isEqualToString:@"0"]) {
        [tixingBtn setBackgroundImage:[UIImage imageNamed:@"yinxiaoguan"] forState:UIControlStateNormal];
    }else{
        [tixingBtn setBackgroundImage:[UIImage imageNamed:@"yinxiaokai"] forState:UIControlStateNormal];
    }
    [tixingBtn addTarget:self action:@selector(remindBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view3 addSubview:tixingBtn];
    self.remindBtn = tixingBtn;
    [line addLineWithFrame:CGRectMake(tixingL.x, h-1, kScreenWidth-tixingL.x, 1) andBackView:view3];



    //帮助中心backView
    UIView * view4 = [self addCellWithH:h magin:magin viewFrame:CGRectMake(0, view3.y+view3.height+10, kScreenWidth, h) title:@"帮助中心" action:@selector(goHelpCenter)];

    //服务协议backView
    UIView * view5 = [self addCellWithH:h magin:magin viewFrame:CGRectMake(0, view4.y+view4.height, kScreenWidth, h) title:@"服务协议" action:@selector(goSeverceDetail)];


    //评价一下backView
    UIView * view6 = [self addCellWithH:h magin:magin viewFrame:CGRectMake(0, view5.y+view5.height, kScreenWidth, h) title:@"评价一下" action:@selector(goPingJia)];


    //联系客服
    UIView * view7 = [self addCellWithH:h magin:magin viewFrame:CGRectMake(0, view6.y+view6.height+10, kScreenWidth, h)title:@"联系客服" action:@selector(callSeverBtnClickme)];


    //关于一快摇
    UIView * view8 = [self addCellWithH:h magin:magin viewFrame:CGRectMake(0, view7.y+view7.height, kScreenWidth, h)title:@"关于一快摇" action:@selector(aboutRockingBtnClick)];

    //清空缓存
    UIView * view9 = [[UIView alloc]initWithFrame:CGRectMake(0, view8.y+view8.height+10, kScreenWidth, h)];
    view9.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view9];
    UILabel * lastL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0.5*(h-23), kScreenWidth, 23)];
    lastL.font = [UIFont systemFontOfSize:[myFont getTitle2]];
    lastL.textColor = [UIColor darkGrayColor];
    lastL.text = @"清空缓存";
    lastL.textAlignment = NSTextAlignmentCenter;
    [view9 addSubview:lastL];
    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, h)];
    btn.backgroundColor = [UIColor clearColor];
    [view9 addSubview:btn];
    [btn addTarget:self action:@selector(cleanBtnClick) forControlEvents:UIControlEventTouchUpInside];


}


-(UIView*)addCellWithH:(CGFloat)h magin:(CGFloat)magin viewFrame:(CGRect)frame title:(NSString*)title action:(SEL)action{
    //backview
    CGFloat labelH = 23;
    UIView * view1 = [[UIView alloc]initWithFrame:frame];
    view1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view1];
    //label
    UILabel * msgL = [[UILabel alloc]initWithFrame:CGRectMake(magin, 0.5*(h-labelH), 150, labelH)];
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


#pragma mark - 消息中心按钮点击事件
-(void)messageCenterBtnClick{
    DebugLog(@"消息中心");
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITableViewController * vc = [sb instantiateViewControllerWithIdentifier:@"messageCenterVC"];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 音效开关按钮点击事件
- (void)voiceBtnClick:(id)sender {
    if ([self.on isEqualToString:@"0"] || [[[NSUserDefaults standardUserDefaults]objectForKey:@"on"] isEqualToString:@"0"]) {//打开音效
        [sender setBackgroundImage:[UIImage imageNamed:@"yinxiaokai"] forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"on"];
        self.on = @"1";
        DebugLog(@"音效打开");
    }else{//关闭音效
        [sender setBackgroundImage:[UIImage imageNamed:@"yinxiaoguan"] forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"on"];
        self.on = @"0";
        DebugLog(@"音效关闭");
    }
}
#pragma mark - 到期提醒按钮点击事件
- (void)remindBtnClick:(id)sender {
    if ([self.remindOn isEqualToString:@"0"] || [[[NSUserDefaults standardUserDefaults]objectForKey:@"remindOn"] isEqualToString:@"0"]) {//打开提醒
        [sender setBackgroundImage:[UIImage imageNamed:@"yinxiaokai"] forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"remindOn"];
        self.remindOn = @"1";
        DebugLog(@"打开提醒");
    }else{//关闭提醒
        [sender setBackgroundImage:[UIImage imageNamed:@"yinxiaoguan"] forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"remindOn"];
        //取消所有提醒
        [[UIApplication sharedApplication]cancelAllLocalNotifications];
        self.remindOn = @"0";
        DebugLog(@"关闭提醒");
    }
}

#pragma mark - 帮助中心
-(void)goHelpCenter{
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController * vc = [sb instantiateViewControllerWithIdentifier:@"IntroductionVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 服务协议
-(void)goSeverceDetail{
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController * vc = [sb instantiateViewControllerWithIdentifier:@"severceDeal"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 评价一下
-(void)goPingJia{
    NSString *str = [NSString stringWithFormat:@"http://itunes.apple.com/us/app/id%d", 1001065082];//跳转到AppStore
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:str]];
}


#pragma mark - 清除缓存按钮点击事件
- (void)cleanBtnClick{
    DebugLog(@"清理缓存按钮被点击");
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(labelDissmis2) userInfo:nil repeats:NO];
}
#pragma mark - 清理缓存成功
-(void)labelDissmis2{
    [MBProgressHUD hideHUDForView:self.view];
    [MBProgressHUD showSuccess:@"缓存清理成功!"];
}
#pragma mark - 联系客服按钮点击事件
- (void)callSeverBtnClickme{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"拨号" message:@"服务电话:4006464158" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            break;
        case 1:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4006464158"]];//打电话
            break;
        default:
            break;
    }
}
#pragma mark - 关于一块摇按钮点击事件
- (void)aboutRockingBtnClick{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController * vc = [sb instantiateViewControllerWithIdentifier:@"newAboutRockingVC"];
    [self.navigationController pushViewController:vc animated:YES];
}












@end
