//
//  AppDelegate.m
//  一块摇
//
//  Created by 亮肖 on 15/4/21.
//  Copyright (c) 2015年 云途基石（北京）信息技术有限公司. All rights reserved.
//

#import "AppDelegate.h"
#import "bossAccount.h"
#import "bossAccountTool.h"
#import "IWControllerTool.h"
#import "UMSocial.h"
#import "UIImageView+WebCache.h"
#import "starVc.h"
#import "UMSocialWechatHandler.h"
#import "common.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "homeVC.h"
#import "remaindVC.h"
#import "MobClick.h"
#import "myNavViewController.h"
#import "AFNetworking.h"
#import "Account.h"
#import "AccountTool.h"
#import "NumberModel.h"
#import "UMessage.h"
#import "myAccountVC.h"
#import "homeTableBarVC.h"
#import "messageCenterVC.h"
#import "MBProgressHUD+MJ.h"
#import "WXApi.h"
#import "YGPrizeDetailVC.h"
#import "myFont.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialWechatHandler.h"



#define dirDoc [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"ClickNumFile.data"]


#define UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define _IPHONE80_ 80000


@interface AppDelegate ()<WXApiDelegate,UIAlertViewDelegate>

@property (nonatomic, assign) UIBackgroundTaskIdentifier taskId;
@property (nonatomic , strong) Reachability * internetReachable;

@end

BMKMapManager* _mapManager;
@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{

    //注册监听网络变化的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus)name:kReachabilityChangedNotification object:nil];
    // Set up Reachability
    _internetReachable = [Reachability reachabilityForInternetConnection];
    [_internetReachable startNotifier];


    //设置全局字体大小类
    [myFont setTitle];

    //将channelId:@"Web" 中的Web 替换为您应用的推广渠道。channelId为nil或@""时，默认会被当作@"App Store"渠道。
    [MobClick startWithAppkey:@"53f77204fd98c585f200de09" reportPolicy:BATCH   channelId:nil];
    
    //集成友盟SDK
    [UMSocialData setAppKey:@"53f77204fd98c585f200de09"];
    
    //设置微信AppId、appSecret，分享url .:wx2c2c2bfb37bc3af6  ;wxd930ea5d5a258f4f
    [UMSocialWechatHandler setWXAppId:@"wx2c2c2bfb37bc3af6" appSecret:@"999a8ffe1c324f72b84f477c847bc255" url:@"http://www.yikuaiyao.com"];

    //sina
//    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://www.yshow.net"];
    //qq
    //设置分享到QQ空间的应用Id，和分享url 链接
//    [UMSocialQQHandler setQQWithAppId:@"" appKey:@"" url:@"http://www.yshow.net"];

    [UMSocialData openLog:NO];
    [UMessage setAutoAlert:NO];
    [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"userInfoIng"];

    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:@"sam7AWdqwsh8HR4fU9nzSLUh" generalDelegate:nil];
    if (!ret) {
        NSLog(@"地图启动失败!");
    }
    
    //set AppKey and AppSecret(远程推送)
    [UMessage startWithAppkey:@"53f77204fd98c585f200de09" launchOptions:launchOptions];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    if(UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
    {
        //register remoteNotification types （iOS 8.0及其以上版本）
        UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
        action1.identifier = @"action1_identifier";
        action1.title=@"Accept";
        action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
        
        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
        action2.identifier = @"action2_identifier";
        action2.title=@"Reject";
        action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
        action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
        action2.destructive = YES;
        
        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
        categorys.identifier = @"category1";//这组动作的唯一标示
        [categorys setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
        
        UIUserNotificationSettings *userSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:[NSSet setWithObject:categorys]];
        [UMessage registerRemoteNotificationAndUserNotificationSettings:userSettings];
        
        [[UIApplication sharedApplication]registerForRemoteNotifications];
        
    }
#else
    register remoteNotification types (iOS 8.0以下)
    [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert];

#endif
    //for log
    [UMessage setLogEnabled:YES];
    
    DebugLog(@"=====launchOptions=%@",launchOptions);

//注册推送别名
    NSString * agt = [[NSUserDefaults standardUserDefaults]objectForKey:@"agentId"];
    DebugLog(@"===agt=%@",agt);
    NSString * isUpTag = [[NSUserDefaults standardUserDefaults]objectForKey:@"agientID-UMAliasTag"];
    DebugLog(@"===isUpTag=%@",isUpTag);
    if (agt && !isUpTag) {
        [UMessage addAlias:[NSString stringWithFormat:@"yky_%@",agt] type:@"yky_push" response:^(id responseObject, NSError *error) {
            if ([responseObject[@"success"] isEqual:@"ok"]) {
                [[NSUserDefaults standardUserDefaults]setObject:agt forKey:@"agientID-UMAliasTag"];
            }
        }];
    }

//远程推送信息处理
    NSDictionary * userInfo = [NSDictionary dictionaryWithDictionary:[launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey]];

    NSString * str = [NSString stringWithFormat:@"%@",userInfo[@"isJump"]];

    //本地通知（到期提醒功能）
    UILocalNotification *note = launchOptions[UIApplicationLaunchOptionsLocalNotificationKey];
    BOOL bl = [str isEqualToString:@"1"] || [str isEqualToString:@"2"];
    if (note && bl==NO) {//点击本地通知启动的程序
        note.applicationIconBadgeNumber = 0;
        //取消所有的本地通知
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        // 程序正处在前台运行，直接返回
        if (application.applicationState == UIApplicationStateActive) {
            return YES;
        }
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        remaindVC *remaindVC = [sb instantiateViewControllerWithIdentifier:@"remaindVC"];
        myNavViewController *navc = [[myNavViewController alloc]initWithRootViewController:remaindVC];
        self.window.rootViewController = navc;
    }else if(bl==NO){//直接点击app图标启动的程序
        //注意：字段一定要是“isJump”,值为“1”。哪个都不能错，在友盟后台发消息的时候一定要在key对应的地方写“isJump”.在value对应位置写“1”，这样才能跳转到系统消息界面。不写isJump时没反应，只写isJump不写value时提示推送的内容，得点击ok按钮才消失。
        note.applicationIconBadgeNumber = 0;
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        //1.创建窗口
        self.window = [[UIWindow alloc] init];
        self.window.frame = CGRectMake(0, 0, kScreenWidth, kScreenheight);
        starVc *star = [[starVc alloc]init];
        star.view.frame=CGRectMake(0, 0, kScreenWidth, kScreenheight);
        [NSThread sleepForTimeInterval:2.0];
        self.window.rootViewController = star ;
        [self.window makeKeyAndVisible];
    }else{
        [self goToMessageVCWithMessage:str];
    }

    return YES;
}

-(void)goToMessageVCWithMessage:(NSString*)str{
    //注意：字段一定要是“isJump”,值为“1”。哪个都不能错，在友盟后台发消息的时候一定要在key对应的地方写“isJump”.在value对应位置写“1”，这样才能跳转到系统消息界面。不写isJump时没反应，只写isJump不写value时提示推送的内容，得点击ok按钮才消失。

    //    UIAlertView * alter = [[UIAlertView alloc]initWithTitle:@"isJump" message:[NSString stringWithFormat:@"%@====%@",userInfo[@"isJump"],str] delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"ok", nil];
    //    [alter show];
    if ([str isEqualToString:@"1"]){
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        messageCenterVC * vc = [sb instantiateViewControllerWithIdentifier:@"messageCenterVC"];
        vc.ID = @"1";//ID为1时直接跳转到系统消息界面
        myNavViewController *navc = [[myNavViewController alloc]initWithRootViewController:vc];
        self.window.rootViewController = navc;
    }else if([str isEqualToString:@"2"]){
        YGPrizeDetailVC * webVC = [[YGPrizeDetailVC alloc]init];
        webVC.ID = @"1";
        webVC.vcTitle = @"推送消息";
        NSString * isUpTag = [[NSUserDefaults standardUserDefaults]objectForKey:@"agientID-UMAliasTag"];
        webVC.requestUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/system/pushMessageDetial?para=%@",kbaseURL,isUpTag]];
        DebugLog(@"====%@",webVC.requestUrl);
        myNavViewController *navc = [[myNavViewController alloc]initWithRootViewController:webVC];
        self.window.rootViewController = navc;
    }
}

#pragma mark - 添加系统回调
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [UMSocialSnsService handleOpenURL:url wxApiDelegate:self];
}


#pragma mark - 全局禁止横屏
-(UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}


/**
 *  程序进入后台时调用这个方法
 */
- (void)applicationDidEnterBackground:(UIApplication *)application {

    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"appBack"];

    // 向系统申请后台运行 : 开启一个后台任务
    NSTimer *timer = [[NSTimer alloc]init];
    timer =  [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(function:) userInfo:nil repeats:YES];
    
    // 能够运行在后台的时间是不确定的, 取决于当前的内存使用情况
    self.taskId = [application beginBackgroundTaskWithExpirationHandler:^{
        // 后台运行时间已经过期, 就会调用这个block
        // 停止后台任务
        [application endBackgroundTask:self.taskId];
    }];
    
    //获取新的浏览量统计数组
    NSData * data = [NSData dataWithContentsOfFile:dirDoc];
    NSArray  * array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (!data) {
#pragma mark - 浏览量统计方法--上传完成之后文件删除
        NSFileManager * manager = [NSFileManager defaultManager];
        [manager removeItemAtPath:dirDoc error:nil];
        return;
    }
    NSMutableArray * MutableArray = [[NSMutableArray alloc]init];
    for (NumberModel * model in array) {
        NSDictionary * dict = @{@"type":model.type,@"prizeId":model.prizeId,@"clickNum":[NSString stringWithFormat:@"%d",model.clickNum]};
        [MutableArray addObject:dict];
    }
    //与服务器交互上传最新的浏览量统计数组
    [self commitClickNumWithArray:MutableArray];

    //清除新版本第一次登陆标记
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"first"];
}

#pragma mark - 浏览量统计结果上传
-(void)commitClickNumWithArray:(NSMutableArray *)array{
    
    NSString * str = [kbaseURL stringByAppendingString:@"/user/updateReadNum"];

    NSData * data1 = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:nil];

    NSString *ste = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];

    NSDictionary *parameter = @{@"clickNumStr":ste};

    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:str parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"code"] isEqual:@(0)]) {
#pragma mark - 浏览量统计方法--上传完成之后文件删除
            NSFileManager * manager = [NSFileManager defaultManager];
            [manager removeItemAtPath:dirDoc error:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
#pragma mark - 浏览量统计方法--上传未完成之后文件删除
        NSFileManager * manager = [NSFileManager defaultManager];
        [manager removeItemAtPath:dirDoc error:nil];
    }];
}

-(void)function:(NSTimer*)timer{
    
    //找出对应提醒功能的那个控制器
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    homeVC *vc = [sb instantiateViewControllerWithIdentifier:@"homeVC"];
    
    //一》判断是否当天内发过通知
    NSString *fireDate = [[NSUserDefaults standardUserDefaults]objectForKey:@"fireDate"];//保存的上次触发时间
    
    //现在的时间
    NSDateFormatter *dateformate = [[NSDateFormatter alloc]init];
    [dateformate setDateFormat:@"dd"];
    NSString *now = [dateformate stringFromDate:[NSDate date]];
    
    //判断是否需要触发提醒
    if ([fireDate isEqualToString:now]) {//触发当天
        //        [[UIApplication sharedApplication]cancelAllLocalNotifications];
    }else{//不是触发当天，可以触发
        [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"userClick"];//用户点击提醒标识符置空
        //判断用户是否开提醒功能
        NSString *isOpenRemind = [[NSUserDefaults standardUserDefaults]objectForKey:@"remindOn"];
        if (isOpenRemind == nil) {
            isOpenRemind = @"1";//默认开启提醒功能
        }
        vc.ADScrollBackView.hidden = YES;
        //进一步判断是否触发提醒
        [vc isHaveDataWithRemindIsOn:isOpenRemind andTimer:timer];
    }
}



#pragma mark - 程序在后台时 用户点击提醒横幅的时候调用的方法
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    notification.applicationIconBadgeNumber = 0;
    notification.repeatInterval = kCFCalendarUnitDay;
    
    [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"userClick"];//记录用户点击提醒的标识符
    [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"userInfoIng"];

    //取消所有的本地通知
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

    // 程序正处在前台运行，直接返回
    if (application.applicationState == UIApplicationStateActive) return;
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    remaindVC *remaindVC = [sb instantiateViewControllerWithIdentifier:@"remaindVC"];
    myNavViewController *navc = [[myNavViewController alloc]initWithRootViewController:remaindVC];
    self.window.rootViewController = navc;
}

/**
 *  内存警告
 */
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    // 取消所有的下载图片请求
    [[SDWebImageManager sharedManager] cancelAll];
    
    // 清除内存缓存
    [[SDWebImageManager sharedManager].imageCache clearMemory];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // 回到前台
    [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"appState"];
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    DebugLog(@"===userInfo=%@",userInfo);
    [UMessage didReceiveRemoteNotification:userInfo];
    DebugLog(@"====class=%@===isjump=%@",[userInfo[@"isJump"] class],userInfo[@"isJump"]);

    [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",userInfo[@"isJump"]] forKey:@"userInfoIsJump"];

    NSString * str = [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfoIng"];
    NSString * appBack = [[NSUserDefaults standardUserDefaults]objectForKey:@"appBack"];

    if ([str isEqualToString:@"0"] && [appBack isEqualToString:@"0"]) {
        UIAlertView * alter = [[UIAlertView alloc]initWithTitle:@"提示" message:@"系统有新的消息,是否立即查看呢？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        [alter show];
    }else{
        [self goToMessageVCWithMessage:[NSString stringWithFormat:@"%@",userInfo[@"isJump"]]];
    }
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"appBack"];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString * string = [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfoIsJump"];
    switch (buttonIndex) {
        case 0:

            break;
        case 1:
            [self goToMessageVCWithMessage:string];
            break;
        default:
            break;
    }
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
}

/**
 *  获取设备的device Token
 *
 *  @param application iOS
 *  @param deviceToken 获取到的设备的device token
 */
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    [UMessage registerDeviceToken:deviceToken];
//6plus  device Token
//    64e074912da83234130b0bf9442160aec7a75d16eaa7ea83d8b78a47f7a04845
    
//b6387064efe7c0c73418215435c5b79f3aa55b2615bdb0991a8b6a8739943f53


//6s  bd7b2d167afaa119165f899fb87e45ce51e6e0387bc20d2988a698d32d0699c7

//公司6s  aa9be35a0ac352769c70d35fa703d6b4fb815ad8b9de8496a9307714233b91e2

    
    DebugLog(@"=============DeviceToken=%@",[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]stringByReplacingOccurrencesOfString: @">" withString: @""]stringByReplacingOccurrencesOfString: @" "withString: @""]);
}

-(void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler{
    [self quickActionWithShortcutItem:shortcutItem];
    completionHandler(YES);
}

-(void)quickActionWithShortcutItem:(UIApplicationShortcutItem*)shortcutItem{
    
    NSString * key = shortcutItem.type;
    if ([key isEqualToString:@"home"]) {//跳首页
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        homeTableBarVC *vc = [sb instantiateViewControllerWithIdentifier:@"homeTableBarVC"];
        self.window.rootViewController = vc;
    }else if([key isEqualToString:@"message"]){//3D跳登陆界面
        if ([AccountTool account]) {//由用户登陆
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            homeTableBarVC *vc = [sb instantiateViewControllerWithIdentifier:@"homeTableBarVC"];
            [vc setSelectedIndex:4];
            self.window.rootViewController = vc;
        }else{//没有用户登录
            UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            myAccountVC * vc = [sb instantiateViewControllerWithIdentifier:@"myAccountVC"];
            vc.ID = @"2";
            myNavViewController * navc = [[myNavViewController alloc]initWithRootViewController:vc];
            self.window.rootViewController = navc;
        }
    }else if ([key isEqualToString:@"yaoyiyao"]){//跳摇奖界面
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        homeTableBarVC *vc = [sb instantiateViewControllerWithIdentifier:@"homeTableBarVC"];
        [vc setSelectedIndex:2];
        self.window.rootViewController = vc;
    }else if ([key isEqualToString:@"jiangdou"]){//跳奖兜界面
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        homeTableBarVC *vc = [sb instantiateViewControllerWithIdentifier:@"homeTableBarVC"];
        [vc setSelectedIndex:1];
        self.window.rootViewController = vc;
    }
}

#pragma mark - 程序将要推出时调用
- (void)applicationWillTerminate:(UIApplication *)application{
    [_internetReachable stopNotifier];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];

    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    homeTableBarVC * vc = [sb instantiateViewControllerWithIdentifier:@"homeTableBarVC"];
    [[NSNotificationCenter defaultCenter] removeObserver:vc name:@"youAreLuckey" object:nil];
}

#pragma mark - 网络变化时更改user的IP和城市
-(void)checkNetworkStatus{
    [getIpVC getUserIp];
}



@end
