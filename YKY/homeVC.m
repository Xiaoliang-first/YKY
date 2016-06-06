//
//  homeVC.m
//  YKY
//
//  Created by 肖亮 on 15/9/6.
//  Copyright (c) 2015年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "homeVC.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "Account.h"
#import "AccountTool.h"
#import "SDCycleScrollView.h"
#import "UIImageView+WebCache.h"
#import "customVIew.h"
#import "adDetailVC.h"
#import "homeTableViewCell.h"
#import "common.h"
#import "cityModel.h"
#import "townModel.h"
#import "UIView+XL.h"
#import <CommonCrypto/CommonDigest.h>
#import "prizeModel.h"
#import "registModel.h"
#import "homePrizeDetailVC.h"
#import "myNavViewController.h"
#import "registe5Btns.h"
#import "homeMidView.h"
#import "theMore.h"
#import "alterView.h"
#import "adBannerModle.h"
#import "YaogouVC.h"
#import "homeNewScuessPrizeVC.h"
#import "QRViewController.h"
#import "SaomiaojieguoVC.h"
#import "homeTableBarVC.h"





@interface homeVC ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,SDCycleScrollViewDelegate,UIAlertViewDelegate,UITabBarControllerDelegate>


/** 承载三个模块按钮的背景View */
@property (strong , nonatomic) UIView *threeModesBackView;
/** 展示列表数据的tableView */
@property (strong , nonatomic) UITableView *TableView;
/** 本期大奖数据源 */
@property (nonatomic , strong) NSMutableArray * dataArray;



/** 广告图片ID的数组 */
//@property (nonatomic , strong) NSMutableArray * adIdArray;
/** 广告轮播器的滚动View */
@property (nonatomic , strong) SDCycleScrollView * adView;
/** 滚动图片URL数组 */
@property (strong , nonatomic) NSMutableArray * imagesDataArray;
/** 滚动图片数组 */
@property (nonatomic , strong) NSMutableArray * Images;
/** 滚动图片点击要加载的Url字符串数组 */
//@property (nonatomic , strong) NSMutableArray * linkUrlsArray;


@property (nonatomic , strong) prizeModel * prizemodel;


/** 是否去过城市列表 */
@property (nonatomic) BOOL haveGoneCitys;
/** 连续签到第几天 */
@property (nonatomic , copy) NSString * day;
/** 一日提醒一次的标识符 */
@property (nonatomic ) BOOL isTaday;
/** 签到时间字符串 */
@property (nonatomic , copy) NSString * locationDateString;
/** 签到模型数据源数组 */
@property (nonatomic , strong) NSMutableArray * registArray;



/** 县区背后黑色半透明Btn */
@property (nonatomic , strong) UIButton * subCitysBackBtn;
/** 县区背景View */
@property (nonatomic , strong) UIView * subCitysBackView;
/** 县区背景View的高 */
@property (nonatomic) CGFloat subCitysBkViewHight;
/** 县区数据源数组 */
@property (nonatomic , strong) NSMutableArray * townsArray;


@property (nonatomic , strong) UIAlertView * locationAlertView;
@property (nonatomic , strong) UIAlertView * photoAlter;

@property (nonatomic , strong) UIAlertView * NWStateAlter;
@property (nonatomic, strong) Reachability *reachability;

//@property (nonatomic , strong) UILabel * leftL;
@property (nonatomic) BOOL one;//网络监听标志,防止网络环境变化请求两次banner属于数据

@end

@implementation homeVC


-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        self.dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}
-(NSMutableArray *)imagesDataArray{
    if (_imagesDataArray == nil) {
        self.imagesDataArray = [[NSMutableArray alloc]init];
    }
    return _imagesDataArray;
}
-(NSMutableArray *)Images{
    if (_Images == nil) {
        self.Images = [[NSMutableArray alloc]init];
    }
    return _Images;
}
-(NSMutableArray *)registArray{
    if (_registArray == nil) {
        self.registArray = [[NSMutableArray alloc]init];
    }
    return _registArray;
}
-(NSMutableArray *)townsArray{
    if (_townsArray == nil) {
        self.townsArray = [[NSMutableArray alloc]init];
    }
    return _townsArray;
}




- (void)viewDidLoad {
    [super viewDidLoad];

//添加控件
    [self addSubViews];

//oldDidLoad
    [self oldViewDidLoad];

// 监听网络状态发生改变的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStateChange) name:kReachabilityChangedNotification object:nil];
    // 获得Reachability对象
    self.reachability = [Reachability reachabilityForInternetConnection];
    // 开始监控网络
    [self.reachability startNotifier];


    [self setRight];
    
}

#pragma mark - 设置导航条右侧扫描按钮
-(void)setRight{
    UIButton * rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 22, 22)];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"saomiaoanniu"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];

    self.navigationItem.rightBarButtonItem = right;
}
-(void)rightClick{

    if ([self validateCamera]) {
        [self showQRViewController];
    } else {
        self.photoAlter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有摄像头或摄像头不可用" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [self.photoAlter show];
    }
}
#pragma mark - 判断是否有摄像头或者摄像头是否能用
- (BOOL)validateCamera {
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] &&
    [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

#pragma mark - 跳转到扫描界面
- (void)showQRViewController {
    if (![AccountTool account]) {
        [MBProgressHUD showError:@"请登录!"];
        [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(jumpToAccountVc) userInfo:nil repeats:NO];
        return;
    }
    QRViewController *qrVC = [[QRViewController alloc] init];
    qrVC.ID = @"1";
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController pushViewController:qrVC animated:YES];
}


#pragma mark - 网络变化重新加载数据
- (void)networkStateChange
{
    if ([netWorkState netWorkChange]) {
        if (([netWorkState isEnableWIFI] || [netWorkState isEnable3G]) && _imagesDataArray.count == 0) {
            [self.imagesDataArray removeAllObjects];
            [self.adView removeFromSuperview];
            [self.Images removeAllObjects];
            if (_one) {
                [self loadData];
                _one = NO;
            }
        }
    }
}


#pragma mark - 旧viewdidload
-(void)oldViewDidLoad{
    self.view.backgroundColor = [UIColor whiteColor];
    //设置数据源和代理
    self.TableView.delegate = self;
    self.TableView.dataSource = self;
    //设置控制器顶部标题
    self.navigationItem.title = @"一块摇";

    //注册cell
    [self.TableView registerNib:[UINib nibWithNibName:@"homeTableViewCell" bundle:nil] forCellReuseIdentifier:@"homeTableViewCell"];
    
    //设置指示器的联网动画
    UIApplication *app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible=YES;
    //顶部广告轮播器数据请求
    if (![[NSUserDefaults standardUserDefaults]objectForKey:@"cityId"]) {
        /** 顶部联网动画（关闭）*/
        app.networkActivityIndicatorVisible=NO;
        //用户第一次登陆的时候是没有城市ID的直接跳转到城市列表界面
        UIApplication *app = [UIApplication sharedApplication];
        UIWindow *window = app.keyWindow;
        // 切换window的rootViewController
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UITableViewController *VC = [sb instantiateViewControllerWithIdentifier:@"citysViewVC"];
        myNavViewController *navc = [[myNavViewController alloc]initWithRootViewController:VC];
        window.rootViewController = navc;

    }else{//用户不是第一次登陆的情况---加载首页banner数据
        [self loadData];
    }

    //角标清零
    UILocalNotification * ln  = [[[UIApplication sharedApplication] scheduledLocalNotifications]lastObject];
    ln.applicationIconBadgeNumber = 0;

    //判断是否开提醒功能
    NSString *isOpenRemind = [[NSUserDefaults standardUserDefaults]objectForKey:@"remindOn"];
    if (isOpenRemind == nil) {
        isOpenRemind = @"1";//默认开启，1：开启状态
    }
}

#pragma mark - 添加控件
-(void)addSubViews{
    //添加scrollView
    UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0,self.view.width, self.view.height)];
    scrollView.backgroundColor = [UIColor clearColor];
    self.backScrollerView = scrollView;
    self.backScrollerView.contentSize = CGSizeMake(self.view.width, kScreenheight*2);
    self.backScrollerView.contentInset = UIEdgeInsetsMake(0, 0, kScreenheight*0.5, 0);
    [self.view addSubview:self.backScrollerView];

    //banner
    UIView * bannerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 150)];
    bannerView.backgroundColor = [UIColor clearColor];
    self.ADScrollBackView = bannerView;
    [self.backScrollerView addSubview:bannerView];

    //middleView
    [homeMidView addMidViewWithY:bannerView.y+bannerView.height andViewController:self andActiviAction:@selector(activityCenterBtnClick) andzhongjiagnAction:@selector(lookLucksBtnClick) andTaoAction:@selector(taoGouBtnClick) andYaoAction:@selector(yaoGouBtnClick)];

    //theMore
    [theMore addTheMoreViewWithY:bannerView.y+bannerView.height+170 andVc:self andAction:@selector(TheMoreBtnClick)];

    //currentPrize
    UITableView * table = [[UITableView alloc]initWithFrame:CGRectMake(0, bannerView.y+bannerView.height+215, self.view.width, 5*125)];
    table.scrollEnabled = NO;
    table.separatorColor = [UIColor clearColor];
    self.TableView = table;
    [scrollView addSubview:self.TableView];


    //界面滚动范围
    self.backScrollerView.contentSize = CGSizeMake(self.view.width, self.TableView.y+self.TableView.height-270);
    if (self.view.height > 668) {
        self.backScrollerView.contentSize = CGSizeMake(self.view.width, self.TableView.y+self.TableView.height-375);
    }
}

#pragma mark - 重磅推出没有数据时tableView隐藏，并添加提示view
-(void)addNoPrizeBottomView{
    self.TableView.hidden = YES;

    CGFloat viewW = 0.65*kScreenWidth;//267
    CGFloat viewH = 0.35*kScreenWidth;//140
    UIView * tishiView = [[UIView alloc]initWithFrame:CGRectMake(0.5*(kScreenWidth-viewW), self.TableView.y+20, viewW, viewH)];
    tishiView.backgroundColor = [UIColor whiteColor];
    [self.backScrollerView addSubview:tishiView];
    UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, viewW, viewH)];
    imgV.image = [UIImage imageNamed:@"noPrizeImg"];
    [tishiView addSubview:imgV];
    CGFloat btnW = 0.4*kScreenWidth;//165
    CGFloat btnH = 0.1*kScreenWidth;//40
    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(0.5*(kScreenWidth-btnW), tishiView.y+tishiView.height+10, btnW, btnH)];
    [btn setBackgroundImage:[UIImage imageNamed:@"noPrizeGoRock"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(goRockBuy) forControlEvents:UIControlEventTouchUpInside];
    [self.backScrollerView addSubview:btn];


    //界面滚动范围
    self.backScrollerView.contentSize = CGSizeMake(self.view.width, tishiView.y+tishiView.height-200);
    if (self.view.height > 668) {
        self.backScrollerView.contentSize = CGSizeMake(self.view.width, tishiView.y+tishiView.height-270);
    }
    DebugLog(@"===%f====%f",tishiView.y+tishiView.height,self.backScrollerView.contentSize.height);
}
#pragma mark - 去摇购界面
-(void)goRockBuy{
    DebugLog(@"去摇购");
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    homeTableBarVC *vc = [sb instantiateViewControllerWithIdentifier:@"homeTableBarVC"];
    UIApplication *app = [UIApplication sharedApplication];
    UIWindow *window = app.keyWindow;
    window.rootViewController = vc;
    UIViewController* myvc =  vc.childViewControllers[1];
    vc.selectedViewController = myvc;
}



#pragma mark - 设置左导航按钮
-(void)setLeftAndRightNaViBtn{
    UIBarButtonItem * left = [[UIBarButtonItem alloc]initWithTitle:@"城市选择" style:UIBarButtonItemStylePlain target:self action:@selector(leftClick)];
    left.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = left;
}

#pragma mark - 城市切换按钮
-(void)leftClick{
    [self jumpToCitysViewVC];
}

#pragma mark - 提醒
-(void)isHaveDataWithRemindIsOn:(NSString *)isOn andTimer:(NSTimer *)timer{
    
    [self.adView removeFromSuperview];
    Account *account = [AccountTool account];
    if (!account.uiId) {//用户ID判空
        //取消定时器
        [timer invalidate];
        timer = nil;
        return;
    }
    NSString * str = kremindStr;
    NSDictionary * parameters = @{@"serverToken":account.reponseToken,@"userId":account.uiId,@"client":Kclient};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    __block NSString * myBool = @"0";
    [manager POST:str parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DebugLog(@"===即将到期数据请求结果=%@",responseObject);
        if ([responseObject[@"code"] isEqual:@(0)]) {
            myBool = @"1";
            //获取当前天
            NSDateFormatter *dateformate = [[NSDateFormatter alloc]init];
            [dateformate setDateFormat:@"dd"];
            NSString *fire = [dateformate stringFromDate:[NSDate date]];
            if ([isOn isEqualToString:@"0"]) {//用户没有开启提醒
                [[UIApplication sharedApplication] cancelAllLocalNotifications];
                //取消定时器
                [timer invalidate];
                return ;
            }else{//用户开启提醒了
                //取消上一个提醒
                [[UIApplication sharedApplication] cancelAllLocalNotifications];
                //保存成功触发提醒功能的时间
                [[NSUserDefaults standardUserDefaults]setObject:fire forKey:@"fireDate"];
                //发出本次通知
                [self setCurruntLnWithFireDate:[NSDate date] andTimer:timer];
            }
        }else{//没有数据不需要触发提醒
            [[UIApplication sharedApplication] cancelAllLocalNotifications];
            //取消定时器
            [timer invalidate];
        }
        //取消定时器
        [timer invalidate];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        //取消定时器
        [timer invalidate];
        myBool = @"0";
    }];
}

/**
 *  设置本地通知对象
 *
 *  @param fireDate 触发本地通知的时间点
 *  @param timer    计时器
 */
-(void)setCurruntLnWithFireDate:(NSDate *)fireDate andTimer:(NSTimer *)timer{
    //0.注册本地通知
    UIUserNotificationType type = UIUserNotificationTypeBadge |
    UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    //系统版本判断
    double version = [[UIDevice currentDevice].systemVersion doubleValue];//判定系统版本。
    if(version>=8.0f){//8.0之后需要注册本地通知
        UIUserNotificationSettings *settings=[UIUserNotificationSettings settingsForTypes:type categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    //1.创建本地通知对象
    UILocalNotification *ln = [[UILocalNotification alloc] init];
    //2.设置通知的属性
    ln.soundName = UILocalNotificationDefaultSoundName;//音效文件(不设置此项时，声音为系统默认滴声)
    ln.alertBody = @"您有奖品即将过期，请火速查看!";
    ln.applicationIconBadgeNumber = 1;
    //2.1设置时区
    ln.timeZone = [NSTimeZone defaultTimeZone];
    //2.2通知重复的频率设置
    ln.repeatInterval = kCFCalendarUnitDay;//(设置为每天重复一次)
    ln.fireDate = fireDate;
    [[UIApplication sharedApplication]scheduleLocalNotification:ln];
    
    //取消定时器
    [timer invalidate];
    timer = nil;
}

#pragma mark - 控制器的willAppear和willDisapper
-(void)viewWillAppear:(BOOL)animated{
    [super viewDidAppear:YES];

    [getIpVC getUserIp];//获取用户的IP

    self.one = YES;
    self.tabBarController.tabBar.hidden = NO;

    self.ADScrollBackView.hidden = NO;
    [self.ADScrollBackView addSubview:self.adView];

    //设置左右导航按钮
    [self setLeftAndRightNaViBtn];

    //判断是否选择过城市
    if (self.haveGoneCitys){
        [self loadData];
    }
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"cityName"]) {
        NSString * city = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"cityName"]];
        if (city.length>6) {
            city = [city substringToIndex:6];//城市选择只取城市名的前六个字
        }
        self.navigationItem.leftBarButtonItem.title = city;
    }else{//没有选择城市
        self.locationAlertView = [[UIAlertView alloc]initWithTitle:@"选择城市" message:@"您还未选择活动城市" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [self.locationAlertView show];
    }
    
    //判断用户是否需要签到
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"dd"];
    NSString * today=[dateformatter stringFromDate:senddate];
    NSString * registDay = [[NSUserDefaults standardUserDefaults]objectForKey:@"registOK"];

    if ([AccountTool account] && ![registDay isEqualToString:today]) {//判断上次签到不是今天，另外有用户登录
        [self getRegistList];
    }else{
        //发送广播
        [[NSNotificationCenter defaultCenter] postNotificationName:@"youAreLuckey" object:nil];
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    //隐藏广告轮播器的容器view、（减少内存消耗）
    self.ADScrollBackView.hidden = YES;
//    [self.imagesDataArray removeAllObjects];
    [self.adView removeFromSuperview];
    [self.tabBarController.tabBar.items[0] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    //取出可能出现的签到界面卡顿到当前界面的现象
    [registe5Btns dissMess];
    self.haveGoneCitys = NO;//把跳转城市列表的标志归no
}

#pragma mark - 获取签到列表
-(void)getRegistList{
    
    NSString *str = kgetrigstStr;
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    /**  获取用户信息  */
    Account * account = [AccountTool account];
    if (account.uiId == nil || account.reponseToken == nil) {//没有用户登录情况下直接返回，不签到。
        return;
    }
    NSDictionary * parameters = @{@"userId":account.uiId,@"client":Kclient,@"serverToken":account.reponseToken};
    [manager POST:str parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([responseObject[@"code"] isEqual:KotherLogin]) {
            [MBProgressHUD showError:@"账号已过有效期,请重新登录!"];
            [self jumpToAccountVc];
        }else if ([responseObject[@"code"] isEqual:@(0)]){
            //添加签到界面，以及签到功能实现
            [registe5Btns addToVC:self];
        }else{
            return ;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"网络加载失败,请检查网络!"];
    }];
}

#pragma mark - 签到按钮点击事件(已改为刮画动作) */
- (void)ok:(UIButton *)btn{
    
    Account *account = [AccountTool account];
    NSString *str = kokregistStr;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"userId":account.uiId,@"client":Kclient,@"serverToken":account.reponseToken};
    [manager POST:str parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DebugLog(@"签到回调res=%@",responseObject);
        [MBProgressHUD hideHUDForView:self.view];
        if ([responseObject[@"code"] isEqual:@100100]) {//避免签到未成功立即切换设备签到但失败的问题
            [self jumpToAccountVc];
            return ;
        }
        if ([responseObject[@"code"] isEqual:Kclient]){
            [MBProgressHUD showError:@"账号已过有效期,请重新登录!"];
            return;
        }else if ([responseObject[@"code"] isEqual:@(0)]){
            //签到成功后保存新的金银币数
            [[NSUserDefaults standardUserDefaults]setObject:responseObject[@"data"][0][@"glod"] forKey:@"gold"];
            [[NSUserDefaults standardUserDefaults]setObject:responseObject[@"data"][0][@"silver"] forKey:@"silverCoin"];
            //设置界面上获得银币的数据
            [registe5Btns setSilverswithText:[NSString stringWithFormat:@"%@",responseObject[@"data"][0][@"addSilver"]]];
            account.gold = responseObject[@"data"][0][@"glod"];
            account.silverCoin = responseObject[@"data"][0][@"silver"];

            //保存签到成功的日子
            NSDate *  senddate=[NSDate date];
            NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
            [dateformatter setDateFormat:@"dd"];
            self.locationDateString=[dateformatter stringFromDate:senddate];
            [[NSUserDefaults standardUserDefaults]setObject:_locationDateString forKey:@"registOK"];

            //设置签到获得银币数
            NSString *str = [NSString stringWithFormat:@"%@",responseObject[@"data"][0][@"addSilver"]];
            [registe5Btns setSilverswithText:str];

            //除去签到通只
            [[NSNotificationCenter defaultCenter]removeObserver:self name:@"qiandao" object:nil];

            //顶部广告轮播器数据请求
            if (![[NSUserDefaults standardUserDefaults]objectForKey:@"cityId"]) {
                UIApplication * app = [UIApplication sharedApplication];
                app.networkActivityIndicatorVisible=NO;
                [self jumpToCitysViewVC];

            }else{
                [self loadData];
            }
            return;
        }else{
            [MBProgressHUD showError:responseObject[@"msg"]];
            return;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"网络不好,刮不动了呢!"];
    }];
}

#pragma mark - 跳转到登录界面
-(void)jumpToAccountVc{
    Account * account2 = [AccountTool account];
    if (account2) {//清除脏数据
        //实现当前用户注销（就是把 account.data文件清空）
        account2 = nil;
        [AccountTool saveAccount:account2];
        
        //当前用户注销之后跳转到登陆界面
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController * myAccountVC = [sb instantiateViewControllerWithIdentifier:@"myAccountVC"];
        [self.navigationController pushViewController:myAccountVC animated:YES];
    }else {
        //当前用户注销之后跳转到登陆界面
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController * myAccountVC = [sb instantiateViewControllerWithIdentifier:@"myAccountVC"];
        [self.navigationController pushViewController:myAccountVC animated:YES];
    }
}

#pragma mark - 广告图片数据请求
- (void)loadData{
    
//    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    NSString *url = khomeBannerStr;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    //取出用户所选择的城市ID
    NSString * ciId = [[NSUserDefaults standardUserDefaults]objectForKey:@"cityId"];
    if (ciId == nil) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"请选择城市!"];
        return;
    }
    NSDictionary *parameters = @{@"cityId":ciId};

    //清空旧数据
    [self.imagesDataArray removeAllObjects];
    [self.adView removeFromSuperview];
    [self.Images removeAllObjects];

    //请求新数据
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

        if ([responseObject[@"code"] isEqual:@(0)]) {
            NSArray * array = [[NSArray alloc]init];
            array = responseObject[@"data"];
            for (NSDictionary *dic in array){
                adBannerModle * model = [adBannerModle adModelWithDict:dic];
                [self.imagesDataArray addObject:model];
            }
            UIApplication *app = [UIApplication sharedApplication];
            //设置指示器的联网动画
            app.networkActivityIndicatorVisible=NO;
            //加载本期大奖数据
            [self loadPrizeData];
            //添加顶部滚动图
            [self addTopAdScrollView];

        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        UIApplication *app = [UIApplication sharedApplication];
        //设置指示器的联网动画
        app.networkActivityIndicatorVisible=NO;
        [MBProgressHUD showError:@"图片加载失败,请检查网络!"];
    }];
}

#pragma mark - 跳转到城市选择界面
-(void)jumpToCitysViewVC{
    self.haveGoneCitys = YES;//记录是否已经选择过城市
    self.ADScrollBackView.hidden = YES;
    [self.adView removeFromSuperview];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController * vc = [sb instantiateViewControllerWithIdentifier:@"citysViewVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 添加banner滚动图片
- (void)addTopAdScrollView{
    for (adBannerModle *dict in self.imagesDataArray) {
        //将请求回来的URL字符串转换为URl
        NSURL * url = [NSURL URLWithString:dict.apic];
        //添加URL到图片URL数组
        [self.Images addObject:url];
    }
    self.adView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, self.ADScrollBackView.frame.size.height) imageURLsGroup:self.Images];
    self.adView.delegate = self;
    self.adView.autoScrollTimeInterval = 2.0;
    [self.adView.mainView reloadData];
    [self.ADScrollBackView addSubview:self.adView];
}

#pragma mark - SDCycleScrollView代理方法监听点击事件
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    adBannerModle * model = self.imagesDataArray[index];
    if (!self.imagesDataArray[index]) {
        return;
    }
    NSString * adDetailUrl = model.aurl;

    //跳转
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    adDetailVC *adDetailVC = [sb instantiateViewControllerWithIdentifier:@"adDetailVC"];
    adDetailVC.adDetailUrl=[NSURL URLWithString:adDetailUrl];
    [self.navigationController pushViewController:adDetailVC animated:YES];
    
}
 
#pragma mark - 请求奖品数据
-(void)loadPrizeData{
    
    NSString * ciName = [[NSUserDefaults standardUserDefaults]objectForKey:@"cityName"];
    
    if (ciName.length == 0) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        UIAlertView *alvie = [[UIAlertView alloc]initWithTitle:@"请点击确定按钮" message:@"选择您所在的地区" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alvie show];
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *urlStr = khomePrizeDataStr;
    if (!ciName) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        return;
    }
    NSString *ciId = [[NSUserDefaults standardUserDefaults]objectForKey:@"cityId"];
    NSDictionary * parameters = @{@"cityId":ciId};
    
    [manager POST:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([responseObject[@"code"] isEqual:@(0)]) {
            NSArray * array = [[NSArray alloc]init];
            array = responseObject[@"data"];
            if (array.count == 0) {
//                [MBProgressHUD showError:@"暂时没有数据"];
                [self addNoPrizeBottomView];
                return ;
            }
            //清除临时数组的缓存
            [self.dataArray removeAllObjects];
            for (NSDictionary *dict in responseObject[@"data"]) {
                prizeModel *prize = [prizeModel prizeWithDict:dict];
                //添加新的数据到临时数组中，座位数据源
                [self.dataArray addObject:prize];
            }

            UIApplication *app = [UIApplication sharedApplication];
            //设置指示器的联网动画
            app.networkActivityIndicatorVisible=NO;
        }else{
            [MBProgressHUD showError:responseObject[@"msg"]];
        }
        [self.TableView reloadData];//刷新数据
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        UIApplication *app = [UIApplication sharedApplication];
        //设置指示器的联网动画
        app.networkActivityIndicatorVisible=NO;
        [MBProgressHUD showError:@"网络加载失败!"];
    }];
}

#pragma mark - 在没有选区城市的情况下提醒用户选城市
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController * vc = [sb instantiateViewControllerWithIdentifier:@"citysViewVC"];
    
    switch (buttonIndex) {
        case 0:
            if ([alertView isEqual:self.photoAlter]) {
                //点击右上角扫描按钮不做处理，避免与跳转城市列表功能重叠
            }else{
                [self.navigationController pushViewController:vc animated:YES];
            }
            break;
        case 1:
            if ([alertView isEqual:self.locationAlertView]) {
                self.haveGoneCitys = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
            break;
        default:
            break;
    }
}

#pragma mark - 更多按钮的点击事件
- (void)TheMoreBtnClick{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController * vc = [sb instantiateViewControllerWithIdentifier:@"theMoreVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 数据源
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count?_dataArray.count:0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    homeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"homeTableViewCell"];
    if (cell == nil) {
        cell = [[homeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"homeTableViewCell"];
        return cell;
    }
    if (self.dataArray.count == 0) {
        return cell;
    }
    cell.prizemodel = self.dataArray[indexPath.row];
    return cell;
}

#pragma mark - 行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 125;
}

#pragma mark - 选中行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    homePrizeDetailVC * vc = [sb instantiateViewControllerWithIdentifier:@"homePrizeDetailVC"];
    prizeModel * model = self.dataArray[indexPath.row];
    vc.jpId = [NSString stringWithFormat:@"%@",model.jpId];
    vc.pId = model.pId;
    vc.indentify = @"3";//由本期大奖跳转到详情界面的标志
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 活动专区按钮点击事件
- (void)activityCenterBtnClick {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController * vc = [sb instantiateViewControllerWithIdentifier:@"newActivityVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 淘购
-(void)taoGouBtnClick {
//    [alterView showWithVC:self title:@"  敬请期待:" text:@"1.无需提供产品就能交易赚钱你喜欢吗？\n2.想立马就能得到实惠奖品吗？\n\n这一切都是真的，攻城师们正在马不停蹄的赶工，请摇粉们耐心等待！" btnTitle:@"我愿等你"];
//    self.tabBarController.tabBar.hidden = YES;
//    self.navigationController.navigationBar.userInteractionEnabled = NO;

    homeNewScuessPrizeVC * vc = [[homeNewScuessPrizeVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 摇购
-(void)yaoGouBtnClick{
//    [alterView showWithVC:self title:@"  敬请期待:" text:@"1.免费就能摇到自己中意的产品，你开不开森？\n2.每天都能让你享受高帅富的体验你乐不乐意？\n\n这一切都是真的，攻城师们正在马不停蹄的赶工，请摇粉们耐心等待！" btnTitle:@"我愿等你"];
//    self.tabBarController.tabBar.hidden = YES;
//    self.navigationController.navigationBar.userInteractionEnabled = NO;

//    YaogouVC * vc = [[YaogouVC alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 查看中奖名单按钮点击事件
- (void)lookLucksBtnClick {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController * vc = [sb instantiateViewControllerWithIdentifier:@"lookLuckTableVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - MD5密码加密
-(NSString *)md5:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (unsigned int)strlen(cStr), result );
    
    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

@end
