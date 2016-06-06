//
//  newRockingVC.m
//  YKY
//
//  Created by 肖亮 on 15/9/6.
//  Copyright (c) 2015年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "newRockingVC.h"
#import "AFNetworking.h"
#import "common.h"
#import "myAccountVC.h"
#import "Account.h"
#import "UIImageView+WebCache.h"
#import "AccountTool.h"
#import "XLAudioTool.h"
#import "MBProgressHUD+MJ.h"
#import <CommonCrypto/CommonDigest.h>
#import <AVFoundation/AVFoundation.h>
#import "XLPlaysound.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "severceDeal.h"
#import "navCell.h"
#import "newBounsDetailVC.h"
#import <CoreLocation/CoreLocation.h>
#import "jumpSafairTool.h"
#import "homeTableBarVC.h"
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import "sharToFrend.h"
#import "rockingPrizeData.h"
#import "AppDelegate.h"
#import "rightImgBtn.h"
#import "newChargeDetailVC.h"


@interface newRockingVC ()<UIAccelerometerDelegate,UMSocialUIDelegate,UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate,BMKLocationServiceDelegate>

@property (weak, nonatomic) IBOutlet UIView *leftTableViewBackView;

/** 设置距离的Tableview */
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (nonatomic , copy) NSString * nowLat;
@property (nonatomic , copy) NSString * nowLon;

/** 钻石数label */
@property (weak, nonatomic) IBOutlet UILabel *zuanshiNumLabel;
@property (weak, nonatomic) IBOutlet UIView *zuanshiBackView;
@property (weak, nonatomic) IBOutlet UIImageView *rockBackImgVeiw;

/** 金币数Label */
@property (weak, nonatomic) IBOutlet UILabel *goldNmbLabel;
/** 银币数Label */
@property (weak, nonatomic) IBOutlet UILabel *silevNmbLabel;
@property (weak, nonatomic) IBOutlet UIView *jinbiBackView;

/** 摇到奖品提示图的背景大Btn */
@property (nonatomic , strong) UIButton * btn;
/** 提示窗的背景View */
@property (nonatomic , strong) UIView * view1;
/** 存放摇取到的奖品数据模型的数组 */
@property (nonatomic , strong) NSMutableArray * modelArray;
@property (nonatomic ) SystemSoundID shortSound;

/**  判断是否开启音效开关的标识 */
@property (nonatomic , copy) NSString * on;
@property (nonatomic , strong)AVAudioPlayer  * player;

/** 奖品类型id */
@property (nonatomic , copy) NSString * prizeKindId;


/** 存放距离的数据原数组 */
@property (nonatomic , strong) NSArray * juliArray;


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
/** 摇出来的奖品的id */
@property (nonatomic , copy) NSString * prizeId;

/** 用户所在城市 */
@property (nonatomic , copy) NSString * city;
/** 用户所在地区 */
@property (nonatomic , copy) NSString * town;
/** 用户所在街道详细信息 */
@property (nonatomic , copy) NSString * userNowAdress;
@property (nonatomic , strong) CLLocationManager * locationManager;
@property (nonatomic , strong) rightImgBtn * leftBtn;
@property (nonatomic , strong) UIImageView * leftImg;
@property (nonatomic , strong) UIImageView * rightImg;

/** 黑色遮盖View */
@property (nonatomic , strong) UIView * blackView;

@property (weak, nonatomic) IBOutlet UIImageView *yaoyiyaoBackImgView;

@property (weak, nonatomic) IBOutlet UIImageView *guibishenheImageView;

@property (nonatomic , strong) UIButton * leftbackbt;
@property (nonatomic) BOOL leftOneC;

@property (nonatomic) BOOL canChooseMi;

@end

@implementation newRockingVC


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
    self.navigationItem.title = @"摇一摇";
    self.leftOneC = YES;
    self.leftbackbt = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenheight)];
    self.leftbackbt.backgroundColor = [UIColor blackColor];
    self.leftbackbt.alpha = 0.5;
    [self.leftbackbt addTarget:self action:@selector(leftTableBtDissmess) forControlEvents:UIControlEventTouchUpInside];

    //设置图片圆角
    self.leftTableViewBackView.layer.cornerRadius = 5;
    self.leftTableViewBackView.layer.masksToBounds = YES;
    self.leftTableViewBackView.layer.borderWidth = 0.01;
    //设置图片圆角
    self.leftTableView.layer.cornerRadius = 5;
    self.leftTableView.layer.masksToBounds = YES;
    self.leftTableView.layer.borderWidth = 0.01;

    Account * account = [AccountTool account];
    if (!account) {
        [MBProgressHUD showError:@"请登录您的账号!"];
        [NSTimer scheduledTimerWithTimeInterval:1.2 target:self selector:@selector(jumpToMyAccountVC) userInfo:nil repeats:NO];
        self.goldNmbLabel.text = @"0";
        self.silevNmbLabel.text = @"0";
        self.zuanshiNumLabel.text = @"0";
        return;
    }else{
        self.goldNmbLabel.text = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"gold"]];
        self.silevNmbLabel.text = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"silverCoin"]];
        self.zuanshiNumLabel.text = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"diamonds"]];
    }

    //验证是否登陆进行下一步操作
    [self getLagerstPrizeData];

    //添加遮盖
    [self addzhegai];
}

#pragma mark - 是否添加遮盖
-(void)addzhegai{
    //用户第一次进入摇奖界面
    if ([self isFirstOrNo]) {//判断是不是新版本第一次登陆
        UIApplication * app =[UIApplication sharedApplication];
        self.blackView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _blackView.backgroundColor = [UIColor clearColor];
        UIWindow * window = [app keyWindow];
        [window addSubview:_blackView];
        //黑色半透明背景btn
        UIButton * btn = [[UIButton alloc]initWithFrame:[UIScreen mainScreen].bounds];
        btn.backgroundColor = [UIColor blackColor];
        btn.alpha = 0.6f;
        [_blackView addSubview:btn];
        [btn addTarget:self action:@selector(dissBlackBtn:) forControlEvents:UIControlEventTouchUpInside];
        //手指图片
        UIImageView * shouzhi = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"firstrock"]];
        if (iPhone5) {
            shouzhi = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.centerX-0.5*self.jinbiBackView.width-33-self.zuanshiBackView.width,self.rockBackImgVeiw.y+self.rockBackImgVeiw.height-15, 100, 85)];
        }else if (iPhone6){
            shouzhi = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.centerX-0.5*self.jinbiBackView.width-33-self.zuanshiBackView.width,self.rockBackImgVeiw.y+self.rockBackImgVeiw.height+85, 100, 85)];
        }else if (iPhone6plus){
            shouzhi = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.centerX-0.5*self.jinbiBackView.width-33-self.zuanshiBackView.width,self.rockBackImgVeiw.y+self.rockBackImgVeiw.height+150, 100, 85)];
        }else{//iphone4/4s
            shouzhi = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.centerX-0.5*self.jinbiBackView.width-33-self.zuanshiBackView.width,self.rockBackImgVeiw.y+self.rockBackImgVeiw.height-100, 100, 85)];
        }
        [shouzhi setImage:[UIImage imageNamed:@"firstrock"]];
        [_blackView addSubview:shouzhi];
    }
}

#pragma mark - 判断是否是第一次登陆
-(BOOL)isFirstOrNo{
    NSString *key = (__bridge NSString *)kCFBundleVersionKey;
    // 1.当前软件的版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];

    // 2.沙盒中的版本号
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *sandBoxVersion = [defaults stringForKey:key];

    // 3.比较  当前软件的版本号  和  沙盒中的版本号
    if ([currentVersion compare:sandBoxVersion] == NSOrderedDescending) {
        return YES;
    }else{
        return NO;
    }
}

-(void)dissBlackBtn:(UIButton*)btn{
    [btn removeFromSuperview];
    [self.blackView removeFromSuperview];
}

#pragma mark - 获取用户当前位置信息
-(void)getUserLocation{
    // 实例化一个位置管理器
    self.locationManager = [[CLLocationManager alloc] init];
    if ([[[UIDevice currentDevice] systemVersion] floatValue]<8.0) {
        
    }else{
        [self.locationManager requestAlwaysAuthorization];
    }
    
    self.locationManager.delegate = self;
    
    // 设置定位精度
    // kCLLocationAccuracyNearestTenMeters:精度10米
    // kCLLocationAccuracyHundredMeters:精度100 米
    // kCLLocationAccuracyKilometer:精度1000 米
    // kCLLocationAccuracyThreeKilometers:精度3000米
    // kCLLocationAccuracyBest:设备使用电池供电时候最高的精度
    // kCLLocationAccuracyBestForNavigation:导航情况下最高精度，一般要有外接电源时才能使用
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    // distanceFilter是距离过滤器，为了减少对定位装置的轮询次数，位置的改变不会每次都去通知委托，而是在移动了足够的距离时才通知委托程序
    // 它的单位是米，这里设置为至少移动100再通知委托处理更新;
    self.locationManager.distanceFilter = 100.0f; // 如果设为kCLDistanceFilterNone，则每秒更新一次;

    // 判断的手机的定位功能是否开启
    // 开启定位:设置 > 隐私 > 位置 > 定位服务
    if ([CLLocationManager locationServicesEnabled]) {
        // 启动位置更新
        // 开启位置更新需要与服务器进行轮询所以会比较耗电，在不需要时用stopUpdatingLocation方法关闭;
        [self.locationManager startUpdatingLocation];
        
    }else {
        UIAlertView * alterView = [[UIAlertView alloc]initWithTitle:@"请开启定位服务!" message:@"设置 > 隐私 > 位置 > 定位服务" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alterView show];
        //设置导航按钮们
        [self setLeftNavBtn];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSURL *url = [NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"];
    switch (buttonIndex) {
        case 0:
            
            break;
        case 1:
            
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                //如果点击打开的话，需要记录当前的状态，从设置回到应用的时候会用到
                [[UIApplication sharedApplication] openURL:url];
            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }
            break;
        default:
            break;
    }
}

#pragma mark - CLLocationManagerDelegate
// 地理位置发生改变时触发
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    // 获取经纬度
    self.nowLat = [NSString stringWithFormat:@"%f",newLocation.coordinate.latitude];
    self.nowLon = [NSString stringWithFormat:@"%f",newLocation.coordinate.longitude];
    
    
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *array, NSError *error){
        if (array.count > 0){
            CLPlacemark *placemark = [array objectAtIndex:0];
            //将获得的所有信息显示到label上
            //            self.location.text = placemark.name;
            //获取城市
            NSString *city = placemark.locality;
            NSString *town = placemark.subLocality;
            
            if (!city) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
                city = [city substringFromIndex:2];
            }
            
            self.city = city;
            self.town = town;

            NSString * st = [NSString stringWithFormat:@"%@",placemark.addressDictionary[@"FormattedAddressLines"][0]];
            self.userNowAdress = st;
            
            //设置导航按钮们
            [self setLeftNavBtn];
        }else if (error == nil && [array count] == 0)
        {
            //设置导航按钮们
            [self setLeftNavBtn];
        }else if (error != nil)
        {
            //设置导航按钮们
            [self setLeftNavBtn];
        }
    }];
    
    // 停止位置更新
    [manager stopUpdatingLocation];
}

// 定位失误时触发
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSString *errorString;
    [manager stopUpdatingLocation];
    switch([error code]) {
        case kCLErrorDenied:
            //用户拒绝访问其位置
            errorString = @"Access to Location Services denied by user";
            [MBProgressHUD showError:@"应用访问位置未获得您的授权!"];
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case kCLErrorLocationUnknown:
            //临时不能访问用户位置
            errorString = @"Location data unavailable";
            [MBProgressHUD showError:@"无法获取您的位置信息!"];
            [self.navigationController popViewControllerAnimated:YES];
            break;
        default:
            errorString = @"An unknown error has occurred";
            break;
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    self.leftTableViewBackView.hidden = YES;
    [self.leftbackbt removeFromSuperview];
    self.leftOneC = YES;
}

#pragma mark - 设置导航nav
-(void)setLeftNavBtn{

    UIView * leftView = [[UIView alloc]initWithFrame:CGRectMake(-10, 0, 60, 40)];
    //左
//    self.leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 70, 39)];
    self.leftBtn = [[rightImgBtn alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
    [self.leftBtn addTarget:self action:@selector(leftClick) forControlEvents:UIControlEventTouchUpInside];
    [self.leftBtn setImage:[UIImage imageNamed:@"下箭头"] withTitle:@"全城" forState:UIControlStateNormal font:17.0f];
    [self.leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftView addSubview:self.leftBtn];
//    [leftView addSubview:jiantouLeft];
    UIBarButtonItem * left = [[UIBarButtonItem alloc]initWithCustomView:leftView];
    self.navigationItem.leftBarButtonItem = left;

}

#pragma mark - 设置距离
-(void)leftClick{

    //注册cell
    [self registNaveCell];

    if ([AccountTool account] == nil) {
        [MBProgressHUD showError:@"账号信息有误,请重新登录!"];
        return;
    }

    self.leftTableViewBackView.hidden = NO;

    if (_leftOneC) {//添加黑色蒙版，防止重复添加导致屏幕变黑
        [self.view insertSubview:self.leftbackbt belowSubview:self.leftTableViewBackView];
        _leftOneC = NO;
    }

    NSString * city = [[NSUserDefaults standardUserDefaults]objectForKey:@"cityName"];

    self.userNowAdress = [self.userNowAdress stringByReplacingOccurrencesOfString:@"市" withString:@""];//用空穿代替字符串中的"市字"
    city = [city stringByReplacingOccurrencesOfString:@"市" withString:@""];
    DebugLog(@"摇一摇界面获取用户地址city=%@====userLocation=%@",city,self.userNowAdress);
    if (![self.userNowAdress containsString:city]) {//判断字符串是否包含某个字符
        self.juliArray = @[@"全城",@"1000米",@"3000米",@"5000米"];
        self.canChooseMi = NO;
    }else{
        self.canChooseMi = YES;
        self.juliArray = @[@"全城",@"1000米",@"3000米",@"5000米"];
    }
    [self.leftTableView reloadData];

}
-(void)leftTableBtDissmess{
    self.leftTableViewBackView.hidden = YES;
    [self.leftbackbt removeFromSuperview];
    self.leftOneC = YES;
}
#pragma mark - 跳充值界面
-(void)rightClick{
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController * vc = [sb instantiateViewControllerWithIdentifier:@"newChargeDetailVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 数据源方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:self.leftTableView]) {
        return _juliArray.count?_juliArray.count:0;
    }
    return 0;
}
static BOOL bac = YES;
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.leftTableView]) {
        navCell *cell = [tableView dequeueReusableCellWithIdentifier:@"navCell"];
        if (cell == nil) {
            cell = [[navCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"navCell"];
            return cell;
        }
        cell.cellLaebl.text = self.juliArray[indexPath.row];
        self.leftTableViewBackView.hidden = NO;
        if (bac) {
            [self.view insertSubview:self.leftbackbt belowSubview:self.leftTableViewBackView];
            bac = NO;
        }
        return cell;
    }else{
        navCell * cell = [[navCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"navCell"];
        if (cell == nil) {
            cell = [[navCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"navCell"];
            return cell;
        } 
        return cell;
    }
    return nil;
}

-(void)registNaveCell{
    [self.leftTableView registerNib:[UINib nibWithNibName:@"navCell" bundle:nil] forCellReuseIdentifier:@"navCell"];
}

#pragma mark - 代理方法
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
#pragma mark - 选中行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    self.leftTableViewBackView.hidden = YES;
    [self.leftbackbt removeFromSuperview];
    self.leftOneC = YES;

    if (indexPath.row == 0) {
        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"juli"];
        [self.leftBtn setImage:[UIImage imageNamed:@"下箭头"] withTitle:@"全城" forState:UIControlStateNormal font:17.0f];
    }else{
        if (!self.canChooseMi) {
            [MBProgressHUD showError:@"您不在所选城市,无法附近摇!"];
            self.leftTableViewBackView.hidden = YES;
            [self.leftBtn setImage:[UIImage imageNamed:@"下箭头"] withTitle:@"全城" forState:UIControlStateNormal font:17.0f];
            return;
        }
        NSArray * array = @[@"",@"1",@"3",@"5"];

        [[NSUserDefaults standardUserDefaults]setObject:array[indexPath.row] forKey:@"juli"];

        NSString * string = array[indexPath.row];
        NSString * string2 = [NSString string];
        if (indexPath.row == 0) {
            string2 = @"全城";
        }else{
            string2 = [string stringByAppendingString:@"千米"];
        }
        NSString * city = [[NSUserDefaults standardUserDefaults]objectForKey:@"cityName"];
        if (![self.city isEqualToString:city]) {
            [self.leftBtn setImage:[UIImage imageNamed:@"下箭头"] withTitle:@"全城" forState:UIControlStateNormal font:17.0f];
        }else{
            [self.leftBtn setImage:[UIImage imageNamed:@"下箭头"] withTitle:string2 forState:UIControlStateNormal font:17.0f];
        }
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //发送广播
    [[NSNotificationCenter defaultCenter] postNotificationName:@"youAreLuckey" object:nil];
    
    self.tabBarController.tabBar.hidden = NO;

    //初始化晃动标志为0，避免其为空或不能晃动
    self.isRocking = @"0";

    Account * account = [AccountTool account];
    if (!account) {
        [MBProgressHUD showError:@"请登录您的账号!"];
        self.goldNmbLabel.text = @"0";
        self.silevNmbLabel.text = @"0";
        self.zuanshiNumLabel.text = @"0";
        return;
    }else{
        self.goldNmbLabel.text = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"gold"]];
        self.silevNmbLabel.text = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"silverCoin"]];
        self.zuanshiNumLabel.text = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"diamonds"]];
    }
    jumpSafairTool * tool = [[jumpSafairTool alloc]init];
    
    if ([tool jumpOrNo]) {//需要跳转到safair

        self.guibishenheImageView.hidden = NO;
        self.yaoyiyaoBackImgView.hidden = YES;

        NSString * agentId = [[NSUserDefaults standardUserDefaults]objectForKey:@"agentId"];
        
        NSString * str = [NSString stringWithFormat:@"http://api.yikuaiyao.com/ios/index.jsp?rt=%@&uid=%@&t=1&c=%@&acid=0&aid=%@",account.reponseToken,account.uiId,Kclient,agentId];

        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        
    }else{//正常执行程序
        self.guibishenheImageView.hidden = YES;
        self.yaoyiyaoBackImgView.hidden = NO;
        [self getUserLocation];
        //激活传感器，也就是设置代理为控制器
        [[UIAccelerometer sharedAccelerometer] setDelegate:self];
    }


    //右
    UIBarButtonItem* rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"充值" style:UIBarButtonItemStylePlain target:self action:@selector(rightClick)];
    rightBtn.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightBtn;
}


#pragma mark - 验证是否登陆进行下一步操作
-(void)getLagerstPrizeData{
    Account *account = [AccountTool account];
    
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    
    if (account) {//有用户登录
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self star];
    }else{//没有用户登录
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self jumpToMyAccountVC];
    }
}

-(void)star{
    [self.btn removeFromSuperview];
    [self.view1 removeFromSuperview];
    
    Account *account = [AccountTool account];
    if (account) {
    }else{
        [MBProgressHUD showError:@"用户信息有误,请重新登录!"];
        [self jumpToMyAccountVC];
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
    [rockingPrizeData dissmess];
    self.tabBarController.tabBar.hidden = NO;
    
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"juli"];
    [self.leftBtn setTitle:@"全城" forState:UIControlStateNormal];
    
    [self.tabBarController.tabBar.items[2] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    // 取消传感器，也就是设置代理为空
    [[UIAccelerometer sharedAccelerometer] setDelegate:nil];
}


// 用加速计侦测手机的晃动事件，需要在收到重力加速计的数据后做一些复杂的数学运算才能很好的实现，但是，UIResponder给我们提供了方法，已经帮我们完成了计算，我们只需使用下面的接口：
#pragma mark 重写----手机开始晃动时调用
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {

    if ([AccountTool account] == nil) {
        [MBProgressHUD showError:@"账号信息有误,请重新登录!"];
        [NSTimer scheduledTimerWithTimeInterval:1.2 target:self selector:@selector(jumpToMyAccountVC) userInfo:nil repeats:NO];
        return;
    }

    if (![self.isRocking isEqualToString:@"0"]) {
        return;
    }
    
    //取出保存的开关标示
    self.on = [[NSUserDefaults standardUserDefaults]objectForKey:@"on"];
    
    if ([self.on isEqualToString:@"1"] || self.on.length == 0) {
        //播放声音
        [XLAudioTool playSound:@"rock_music.mp3"];
    }
    
    NSString *str = krockingStr;
    Account *account = [AccountTool account];
    if (account == nil) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"账户信息有误,请重新登录!"];
        return;
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
//    NSString * str1=[[NSUserDefaults standardUserDefaults]objectForKey:@"cityId"];

    NSString * kindId = [[NSUserDefaults standardUserDefaults]objectForKey:@"kindId"];
    NSString * juli = [[NSUserDefaults standardUserDefaults]objectForKey:@"juli"];
    NSString * agentId = [[NSUserDefaults standardUserDefaults]objectForKey:@"agentId"];
    
    
    NSDictionary *parameters = [NSDictionary dictionary];

    if (!account.uiId || !agentId || !account.reponseToken) {
        return;
    }

    parameters = @{@"client":Kclient,@"userId":account.uiId,@"agentId":agentId,@"serverToken":account.reponseToken};
    
    if (kindId) {
        parameters = @{@"userId":account.uiId,@"agentId":agentId,@"client":Kclient,@"serverToken":account.reponseToken,@"type":kindId};
    }
    
    if (juli) {
        if (self.nowLat && self.nowLon) {
            parameters = @{@"userId":account.uiId,@"agentId":agentId,@"client":Kclient,@"serverToken":account.reponseToken,@"distance":juli,@"lng":self.nowLon,@"lat":self.nowLat};
        }else {
            parameters = @{@"userId":account.uiId,@"agentId":agentId,@"client":Kclient,@"serverToken":account.reponseToken,@"distance":juli};
        }
    }
    
    if (juli.length != 0 && kindId) {
        
        if (self.nowLon && self.nowLat) {
            parameters = @{@"userId":account.uiId,@"agentId":agentId,@"client":Kclient,@"serverToken":account.reponseToken,@"type":kindId,@"distance":juli,@"lng":self.nowLon,@"lat":self.nowLat};
        }else{
            parameters = @{@"userId":account.uiId,@"agentId":agentId,@"client":Kclient,@"serverToken":account.reponseToken,@"type":kindId,@"distance":juli};
        }
    }

    if (self.modelArray.count>0) {
        [self.modelArray removeAllObjects];//清空已经摇到的奖品
    }
    
    [manager POST:str parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

        if ([responseObject[@"code"] isEqual:@(0)]) {
            //摇奖成功之后刷新界面的金银币数
            self.silevNmbLabel.text = [NSString stringWithFormat:@"%@",responseObject[@"data"][0][@"silver"]];
            self.goldNmbLabel.text = [NSString stringWithFormat:@"%@",responseObject[@"data"][0][@"glod"]];
            self.zuanshiNumLabel.text = [NSString stringWithFormat:@"%@",responseObject[@"data"][0][@"diamonds"]];

            //保存摇奖之后的金币数
            [[NSUserDefaults standardUserDefaults]setObject:responseObject[@"data"][0][@"glod"] forKey:@"gold"];
            [[NSUserDefaults standardUserDefaults]setObject:responseObject[@"data"][0][@"silver"] forKey:@"silverCoin"];
            [[NSUserDefaults standardUserDefaults]setObject:responseObject[@"data"][0][@"diamonds"] forKey:@"diamonds"];

            //设置出奖提示图信息
            self.couponsId = [NSString stringWithFormat:@"%@",responseObject[@"data"][0][@"id"]];
            self.endDate = [NSString stringWithFormat:@"%@",responseObject[@"data"][0][@"etime"]];
            self.prizeLowUrl = responseObject[@"data"][0][@"smallUrl"];
            self.type = responseObject[@"data"][0][@"type"];
            self.couponsName = responseObject[@"data"][0][@"pname"];
            self.prizeId = [NSString stringWithFormat:@"%@",responseObject[@"data"][0][@"pid"]];

            
            if ([self.isRocking isEqualToString:@"0"]) {//未摇奖状态
                [self addbackView];//未摇奖状态下添加奖品提示图
            }
            if ([self.on isEqualToString:@"1"] || self.on.length == 0) {//音效开关开状态
                [XLAudioTool playSound:@"grade_2.mp3"];
            }
        }else if ([responseObject[@"code"] isEqual:KotherLogin]){
            [MBProgressHUD showError:@"账号已过有效期,请重新登录!"];
            [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(jumpToMyAccountVC) userInfo:nil repeats:NO];
        }else{
            [MBProgressHUD showError:responseObject[@"msg"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"网络加载失败"];
    }];
}

#pragma mark -  摇到的奖品提示图
- (void)addbackView{
    //摇奖进行中标识置1，即开始摇动
    self.isRocking = @"1";
    //添加摇出奖品的图片
    [rockingPrizeData prizeShowWithCouponsName:self.couponsName andImgUrlStr:self.prizeLowUrl andEndDate:self.endDate andVC:self remove:@selector(removeBackView) lookDetail:@selector(lookDetail) share:@selector(shardWithFriend)];
}

#pragma mark - 与好友分享
- (void)shardWithFriend{
    Account * account = [AccountTool account];
    [sharToFrend shareWithImgurl:self.prizeLowUrl title:@"我刚在一块摇中获取了一个奖品，只要你摇，惊喜一直不断，你准备好了吗？" andPid:self.prizeId phone:account.phone andVC:self];
//    [sharToFrend shareWithImgurl:self.prizeLowUrl andPname:self.couponsName phone:account.phone andVC:self];
//    [sharToFrend shareWithType:@"1" andImgurl:self.prizeLowUrl andCouponsId:self.couponsId andVC:self];
}

#pragma mark - 查看详情
- (void)lookDetail{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    newBounsDetailVC *vc = [sb instantiateViewControllerWithIdentifier:@"newBounsDetailVC"];
    vc.Type = self.type;
    vc.couponsId = self.couponsId;
    [self.navigationController pushViewController:vc animated:YES];
}
//返回小按钮
- (void)removeBackView{
    //摇奖进行中标识置0，即停止摇动
    self.isRocking = @"0";
    [rockingPrizeData dissmess];
    //激活传感器，也就是设置代理为控制器
    [[UIAccelerometer sharedAccelerometer] setDelegate:self];
}

#pragma mark - MD5密码加密
-(NSString *)md5:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (int)strlen(cStr), result );
    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

/**
 *  单点登录，清除当前残留用户数据并跳转到登陆界面。
 */
-(void)jumpToMyAccountVC{
    Account * account2 = [AccountTool account];
    if (account2) {
        //实现当前用户注销（就是把 account.data文件清空）
        account2 = nil;
        [AccountTool saveAccount:account2];
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
