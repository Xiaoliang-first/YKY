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
    self.view.backgroundColor = [UIColor whiteColor];
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

    //消息中心backview
    CGFloat imgH = 23;
    CGFloat imgW = 16;
    UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(0,70, kScreenWidth, h)];
    view1.backgroundColor = [UIColor clearColor];
    [self.view addSubview:view1];
    //消息中心
    UIImageView * msgImg = [[UIImageView alloc]initWithFrame:CGRectMake(magin, 0.5*(h-imgH), imgW, imgH)];
    msgImg.image = [UIImage imageNamed:@"消息中心"];
    [view1 addSubview:msgImg];
    UILabel * msgL = [[UILabel alloc]initWithFrame:CGRectMake(msgImg.x+msgImg.width+14, 0.5*(h-imgH), 80, imgH)];
    msgL.font = [UIFont systemFontOfSize:[myFont getTitle2]];
    msgL.textColor = [UIColor darkGrayColor];
    msgL.text = @"消息中心";
    [view1 addSubview:msgL];
    UIButton * msgBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, h)];
    msgBtn.backgroundColor = [UIColor clearColor];
    [view1 addSubview:msgBtn];
    [msgBtn addTarget:self action:@selector(messageCenterBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [line addLineWithFrame:CGRectMake(msgL.x, h-1, kScreenWidth-msgL.x, 1) andBackView:view1];


    //音效backView
    UIView * view2 = [[UIView alloc]initWithFrame:CGRectMake(0, view1.y+view1.height, kScreenWidth, h)];
    view2.backgroundColor = [UIColor clearColor];
    [self.view addSubview:view2];
    //ling
    CGFloat lingW = 16;
    CGFloat lingH = 20;
    UIImageView * ling = [[UIImageView alloc]initWithFrame:CGRectMake(magin, 0.5*(h-lingH), lingW, lingH)];
    ling.image = [UIImage imageNamed:@"音效"];
    [view2 addSubview:ling];
    //音效label
    UILabel * voiceL = [[UILabel alloc]initWithFrame:CGRectMake(ling.x+ling.width+14, 0.5*(h-lingH), 60, lingH)];
    voiceL.text = @"音效";
    voiceL.font = [UIFont systemFontOfSize:[myFont getTitle2]];
    voiceL.textColor = [UIColor darkGrayColor];
    [view2 addSubview:voiceL];
    //音效开关
    CGFloat vioW = 45;
    CGFloat vioH = 24;
    UIButton * voiveBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.width-vioW*1.5, 0.5*(h-lingH), vioW, vioH)];
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
    CGFloat naoW = 17;
    CGFloat naoH = 19;
    UIView * view3 = [[UIView alloc]initWithFrame:CGRectMake(0, view2.y+view2.height, kScreenWidth, h)];
    view3.backgroundColor = [UIColor clearColor];
    [self.view addSubview:view3];
    //闹钟图
    UIImageView * naozhong = [[UIImageView alloc]initWithFrame:CGRectMake(magin, 0.5*(h-naoH), naoW, naoH)];
    naozhong.image = [UIImage imageNamed:@"到期提醒"];
    [view3 addSubview:naozhong];
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



    //清除缓存backView
    CGFloat clearImgW = 16;
    CGFloat clearImgH = 20;
    UIView * view4 = [[UIView alloc]initWithFrame:CGRectMake(0, view3.y+view3.height, kScreenWidth, h)];
    view4.backgroundColor = [UIColor clearColor];
    [self.view addSubview:view4];
    //垃圾桶图
    UIImageView * clearImgV = [[UIImageView alloc]initWithFrame:CGRectMake(magin, 0.5*(h-clearImgH), clearImgW, clearImgH)];
    clearImgV.image = [UIImage imageNamed:@"清除缓存"];
    [view4 addSubview:clearImgV];
    //清缓存lbel
    UILabel * clearL = [[UILabel alloc]initWithFrame:CGRectMake(voiceL.x, 0.5*(h-clearImgH), 90, clearImgH)];
    clearL.text = @"清空缓存";
    clearL.font = [UIFont systemFontOfSize:[myFont getTitle2]];
    clearL.textColor = [UIColor darkGrayColor];
    [view4 addSubview:clearL];
    //底线
    //清空缓存按钮
    UIButton * clearBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.view.width, h)];
    clearBtn.backgroundColor = [UIColor clearColor];
    [view4 addSubview:clearBtn];
    [clearBtn addTarget:self action:@selector(cleanBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [line addLineWithFrame:CGRectMake(clearL.x, h-1, kScreenWidth, 1) andBackView:view4];


    //联系客服backView
    CGFloat callW = 16;
    CGFloat callH = 22;
    UIView * view5 = [[UIView alloc]initWithFrame:CGRectMake(0, view4.y+view4.height, kScreenWidth, h)];
    view5.backgroundColor = [UIColor clearColor];
    [self.view addSubview:view5];
    UIImageView * callImg = [[UIImageView alloc]initWithFrame:CGRectMake(magin, 0.5*(h-callH), callW, callH)];
    callImg.image = [UIImage imageNamed:@"联系客服"];
    [view5 addSubview:callImg];
    UILabel * callL = [[UILabel alloc]initWithFrame:CGRectMake(tixingL.x, 0.5*(h-callH), 80, callH)];
    callL.font = [UIFont systemFontOfSize:[myFont getTitle2]];
    callL.textColor = [UIColor darkGrayColor];
    callL.text = @"联系客服";
    [view5 addSubview:callL];
    UIButton * callBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.view.width, h)];
    callBtn.backgroundColor = [UIColor clearColor];
    [callBtn addTarget:self action:@selector(callSeverBtnClickme) forControlEvents:UIControlEventTouchUpInside];
    [view5 addSubview:callBtn];
    [line addLineWithFrame:CGRectMake(callL.x, h-1, kScreenWidth-callL.x, 1) andBackView:view5];


    //关于一快摇backView
    CGFloat aboutYKYImgW = 17;
    CGFloat aboutYKYImgH = 18;
    UIView * view6 = [[UIView alloc]initWithFrame:CGRectMake(0, view5.y+view5.height, kScreenWidth, h)];
    view6.backgroundColor = [UIColor clearColor];
    [self.view addSubview:view6];
    UIImageView * abYKYImg = [[UIImageView alloc]initWithFrame:CGRectMake(magin, 0.5*(h-aboutYKYImgH), aboutYKYImgW, aboutYKYImgH)];
    abYKYImg.image = [UIImage imageNamed:@"一块摇23"];
    [view6 addSubview:abYKYImg];

    UILabel * abYKYL = [[UILabel alloc]initWithFrame:CGRectMake(abYKYImg.x+abYKYImg.width+12, 10, 90, 20)];
    abYKYL.font = [UIFont systemFontOfSize:[myFont getTitle2]];
    abYKYL.text = @"关于一块摇";
    abYKYL.textColor = [UIColor darkGrayColor];
    [view6 addSubview:abYKYL];

    UIButton * abYBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.view.width, h)];
    abYBtn.backgroundColor = [UIColor clearColor];
    [abYBtn addTarget:self action:@selector(aboutRockingBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [view6 addSubview:abYBtn];
    [line addLineWithFrame:CGRectMake(abYKYL.x, h-1, kScreenWidth-abYKYL.x, 1) andBackView:view6];
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
