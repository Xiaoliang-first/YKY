//
//  newActivityRockingVC.m
//  YKY
//
//  Created by 肖亮 on 15/9/19.
//  Copyright (c) 2015年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "newActivityRockingVC.h"
#import "AFNetworking.h"
#import "common.h"
#import "myAccountVC.h"
#import "Account.h"
#import "UIView+XL.h"
#import "UIImageView+WebCache.h"
#import "AccountTool.h"
#import "unUsedPrizeModel.h"
#import "XLAudioTool.h"
#import "MBProgressHUD+MJ.h"
#import <AVFoundation/AVFoundation.h>
#import "XLPlaysound.h"
#import "UMSocial.h"
#import "newActivityModel.h"
#import "newBounsDetailVC.h"
#import "sharToFrend.h"
#import "rockingPrizeData.h"


@interface newActivityRockingVC ()<UIAccelerometerDelegate,UMSocialUIDelegate>


/** 钻石数Label */
@property (weak, nonatomic) IBOutlet UILabel *zuanshiNumLabel;
/** 金币数Label */
@property (weak, nonatomic) IBOutlet UILabel *goldNmbLabel;
/** 银币数Label */
@property (weak, nonatomic) IBOutlet UILabel *silevNmbLabel;
/** 活动时间Label */
@property (weak, nonatomic) IBOutlet UILabel *activityTimeLabel;


///** 摇到奖品提示图的背景大Btn */
//@property (nonatomic , strong) UIButton * btn;
///** 提示窗的背景View */
//@property (nonatomic , strong) UIView * view1;
/** 存放摇取到的奖品数据模型的数组 */
@property (nonatomic , strong) NSMutableArray * modelArray;
@property (nonatomic ) SystemSoundID shortSound;


/**  判断是否开启音效开关的标识 */
@property (nonatomic , copy) NSString * on;
/**  是否在晃动中的标识（1表示晃动中 0表示没有晃动） */
@property (nonatomic,copy) NSString * isRocking ;
@property (nonatomic , strong)AVAudioPlayer  * player;

/** 奖品类型id */
@property (nonatomic , copy) NSString * prizeKindId;
/** 摇出来的奖品Id */
@property (nonatomic , copy) NSString * couponsId;
/** 摇出来的奖品有效期 */
@property (nonatomic , copy) NSString * endDate;
/** 摇出来的奖品小图URL字符串 */
@property (nonatomic , copy) NSString * prizeLowUrl;
/** 摇出来的奖品type */
@property (nonatomic , copy) NSString * type;
/** 摇出来的奖品名字 */
@property (nonatomic , copy) NSString * couponsName;
/** 摇出来的产品的id */
@property (nonatomic , copy) NSString * prizeId;



@end

@implementation newActivityRockingVC



-(NSMutableArray *)modelArray{
    if (_modelArray == nil) {
        self.modelArray = [[NSMutableArray alloc]init];
    }
    return _modelArray;
}

- (AVAudioPlayer *)player
{
    if (!_player) {
        // 0.音频文件的URL
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"rock_music.mp3"withExtension:nil];
        
        // 1.创建播放器(一个AVAudioPlayer只能播放一个URL)
        AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        
        // 2.缓冲
        [player prepareToPlay];
        
        self.player = player;
    }
    return _player;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"活动摇";
    self.tabBarController.tabBar.hidden = YES;
    
    //设置导航按钮们
    [self setLeftNavBtn];

    [self setright];
}

#pragma mark - 设置leftItem
-(void)setright{
    UIBarButtonItem * right = [[UIBarButtonItem alloc]initWithTitle:@"充值" style:UIBarButtonItemStylePlain target:self action:@selector(rightClick)];
    right.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = right;
}
-(void)rightClick{
    DebugLog(@"充值");
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController * vc = [sb instantiateViewControllerWithIdentifier:@"newChargeDetailVC"];
    [self.navigationController pushViewController:vc animated:YES];
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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    //开始本控制器的工作
    [self star];
}
#pragma mark - star开始本控制器工作
-(void)star{
    self.navigationItem.title = self.model.activeName;
    
    Account *account = [AccountTool account];
    if (account) {
        self.goldNmbLabel.text = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"gold"]];
        self.silevNmbLabel.text = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"silverCoin"]];
        self.zuanshiNumLabel.text = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"diamonds"]];
        self.activityTimeLabel.text = [NSString stringWithFormat:@"活动时间:%@至%@",self.model.startDate,self.model.endDate];
    }else{
        [MBProgressHUD showError:@"用户信息有误,请重新登录!"];
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(jumpToMyaccountVC) userInfo:nil repeats:NO];
        return;
    }
    
    // 设置陀螺仪
    UIAccelerometer *accelerometer = [UIAccelerometer sharedAccelerometer]; // 实例对象
    accelerometer.delegate = self; // 设置代理为本身控制器
    accelerometer.updateInterval = 0.1; // 设置传感器更新数据的时间间隔
    [self.view becomeFirstResponder]; // 窗口对象作为第一响应者运动事件
    
    //晃动标志
    self.isRocking = @"0";
    //音效开关标志
    self.on = @"1";
    
}

#pragma mark - 重写----视图将要消失取消传感器
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    [self.tabBarController.tabBar.items[2] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    // 取消传感器，也就是设置代理为空
    [[UIAccelerometer sharedAccelerometer] setDelegate:nil];
}

// 用加速计侦测手机的晃动事件，需要在收到重力加速计的数据后做一些复杂的数学运算才能很好的实现，但是，UIResponder给我们提供了方法，已经帮我们完成了计算，我们只需使用下面的接口：
#pragma mark 重写----手机开始晃动时调用
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    
    if (![self.isRocking isEqualToString:@"0"]) {
        return;
    }
    //取出保存的开关标示
    self.on = [[NSUserDefaults standardUserDefaults]objectForKey:@"on"];
    
    if ([self.on isEqualToString:@"1"] || self.on.length == 0) {
        //播放声音
        [XLAudioTool playSound:@"rock_music.mp3"];
    }
    NSString *str = kactivityRockingStr;
    Account *account = [AccountTool account];
    if (account == nil) {
        return;
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    NSString * agentId = [[NSUserDefaults standardUserDefaults] objectForKey:@"agentId"];

    NSDictionary *parameters = @{@"userId":account.uiId,@"client":Kclient,@"serverToken":account.reponseToken,@"activeId":self.model.activeId,@"agentId":agentId};
    
    if (self.modelArray.count>0) {
        [self.modelArray removeAllObjects];//清空已经摇到的奖品
    }
    
    [manager POST:str parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject[@"code"] isEqual:@(0)]) {
            //摇奖成功之后刷新界面的金银币数
            self.silevNmbLabel.text = [NSString stringWithFormat:@"%@",responseObject[@"data"][0][@"silver"]];
            self.goldNmbLabel.text = [NSString stringWithFormat:@"%@",responseObject[@"data"][0][@"glod"]];
            self.zuanshiNumLabel.text = [NSString stringWithFormat:@"%@",responseObject[@"data"][0][@"diamonds"]];
            //保存摇奖之后的金银币数到用户信息
            account.gold = responseObject[@"data"][0][@"glod"];
            account.silverCoin = responseObject[@"data"][0][@"silver"];
            account.diamonds = responseObject[@"data"][0][@"diamonds"];
            //保存摇奖之后的金币数
            [[NSUserDefaults standardUserDefaults]setObject:account.gold forKey:@"gold"];
            [[NSUserDefaults standardUserDefaults]setObject:account.silverCoin forKey:@"silverCoin"];
            [[NSUserDefaults standardUserDefaults]setObject:account.diamonds forKey:@"diamonds"];


            self.couponsId = responseObject[@"data"][0][@"id"];
            self.endDate = responseObject[@"data"][0][@"etime"];
            self.prizeLowUrl = responseObject[@"data"][0][@"smallUrl"];
            self.type = responseObject[@"data"][0][@"type"];
            self.couponsName = responseObject[@"data"][0][@"pname"];
            self.prizeId = responseObject[@"data"][0][@"pid"];

            
            if ([self.on isEqualToString:@"1"] || self.on.length == 0) {//音效开关开状态
                [XLAudioTool playSound:@"grade_2.mp3"];
            }
            if ([self.isRocking isEqualToString:@"0"]) {//未摇奖状态
                [self addbackView];//未摇奖状态下添加奖品提示图
            }

        }else if ([responseObject[@"code"] isEqual:KotherLogin]){
            [MBProgressHUD showError:@"账号已过有效期,请重新登录!"];
            [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(jumpToMyaccountVC) userInfo:nil repeats:NO];
        }else{
            [MBProgressHUD showError:responseObject[@"msg"]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"网络加载失败"];
    }];
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

#pragma mark -  摇到的奖品提示图
- (void)addbackView{
    self.isRocking = @"1";//正在摇奖中的标志
    
    [rockingPrizeData prizeShowWithCouponsName:self.couponsName andImgUrlStr:self.prizeLowUrl andEndDate:self.endDate andVC:self remove:@selector(removeBackView) lookDetail:@selector(lookDetail) share:@selector(shardWithFriend)];

}

#pragma mark - 与好友分享
- (void)shardWithFriend{
    Account * account = [AccountTool account];

    [sharToFrend shareWithImgurl:self.prizeLowUrl andPid:self.prizeId phone:account.phone andVC:self];
//    [sharToFrend shareWithImgurl:self.prizeLowUrl andPname:self.couponsName phone:account.phone andVC:self];
//    [sharToFrend shareWithType:@"0" andImgurl:self.prizeLowUrl andCouponsId:self.couponsId andVC:self];
}

#pragma mark - 查看详情
- (void)lookDetail{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    newBounsDetailVC *vc = [sb instantiateViewControllerWithIdentifier:@"newBounsDetailVC"];
    vc.Type = self.type;
    vc.couponsId = self.couponsId;
    [rockingPrizeData dissmess];
    [self.navigationController pushViewController:vc animated:YES];
}

//返回小按钮
- (void)removeBackView{
    self.isRocking = @"0";
    [rockingPrizeData dissmess];
    //激活传感器，也就是设置代理为空
    [[UIAccelerometer sharedAccelerometer] setDelegate:self];
}

@end
