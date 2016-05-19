//
//  homeNewScuessDetailVC.m
//  YKY
//
//  Created by 肖 亮 on 16/4/21.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "homeNewScuessDetailVC.h"
#import "SDCycleScrollView.h"
#import "homeNewScuessDetailLuckerView.h"
#import "homeNewScuessModel.h"
#import "Account.h"
#import "AccountTool.h"
#import "YGPrizeDetailVC.h"
#import "homeLookOldLuckprizeVC.h"
#import "YaogouVC.h"
#import "homeTableBarVC.h"
#import "lookMyLuckNumVC.h"
#import "YGBannerModel.h"
#import "YGPrizeDetailVC.h"


#define kMagin 15

@interface homeNewScuessDetailVC ()

@property (nonatomic , strong) UIScrollView * backScrollView;
@property (nonatomic , strong) UIView * adBackView;
@property (nonatomic , strong) SDCycleScrollView * adView;
@property (nonatomic , strong) UILabel * pnameLabel;
@property (nonatomic , strong) UIView * luckView;
@property (nonatomic , strong) UILabel * bottomLabel;
@property (nonatomic , strong) UIButton * bottomBtn;
@property (nonatomic , strong) UIView * topBottomView;
@property (nonatomic , strong) UIView * imgDetailView;
@property (nonatomic , strong) UIView * lookOldLuckView;
/** banner模型数组 */
@property (nonatomic , strong) NSMutableArray * bannerUrls;


@end

@implementation homeNewScuessDetailVC

-(NSMutableArray *)bannerUrls{
    if (_bannerUrls == nil) {
        self.bannerUrls = [[NSMutableArray alloc]init];
    }
    return _bannerUrls;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"揭晓详情";
    [self setLeft];
    self.view.backgroundColor = [UIColor whiteColor];
    //添加大的滚动view
    self.backScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenheight+kTabbarHeight)];
    self.backScrollView.backgroundColor = YKYClearColor;
    self.backScrollView.contentSize = CGSizeMake(kScreenWidth, kScreenheight);
    [self.view addSubview:self.backScrollView];


}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //添加其他views
    [self addviews];
    [self loadBanner];

    if (_serialID) {
        [self updateData];
    }
    DebugLog(@"===_pid=%@===_serialID=vc%@",_pid,_serialID);
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    for (UIView *sub in self.backScrollView.subviews) {
        [sub removeFromSuperview];
    }
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

#pragma mark - 添加子控件
-(void)addviews{
    //添加顶部
    [self addTopView];

    //添加中部view
    [self addMidView];
    //添加底部继续摇购按钮
    [self addYGBtn];
}


-(void)addTopView{
    //1.0 banner轮播图
    self.adBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 150)];
    self.adBackView.backgroundColor = YKYColor(242, 242, 242);
    [self.backScrollView addSubview:self.adBackView];
    [line addLineWithFrame:CGRectMake(0, self.adBackView.y+self.adBackView.height, kScreenWidth, 1) andBackView:self.adBackView];

    //2.0 奖品名字
    CGFloat magin = 8;
    self.pnameLabel = [[UILabel alloc]initWithFrame:CGRectMake(kMagin, self.adBackView.y+self.adBackView.height+1.5*magin, kScreenWidth-2*kMagin, 20)];
    self.pnameLabel.textAlignment = NSTextAlignmentLeft;
    self.pnameLabel.font = [UIFont systemFontOfSize:[myFont getTitle2]];
    self.pnameLabel.textColor = YKYTitleColor;
    self.pnameLabel.text = _prizemodel.pname;
    [self.backScrollView addSubview:self.pnameLabel];


    //3.0 中奖者提示图
    self.luckView = [homeNewScuessDetailLuckerView addViewWithFrame:CGRectMake(kMagin, self.pnameLabel.y+self.pnameLabel.height+12, kScreenWidth-2*kMagin, 140) toView:self.backScrollView VC:self JisuanAction:@selector(computingMethodBtnClick) headUrlStr:_prizemodel.headImage uname:_prizemodel.uname luckTimeStr:_prizemodel.luckCount joinTimeStr:_prizemodel.ptime luckNumStr:_prizemodel.priNum serials:_prizemodel.serials];

    //4.0 有无摇码状态窗view
    Account * account = [AccountTool account];
    self.topBottomView = [[UIView alloc]initWithFrame:CGRectMake(kMagin, self.luckView.y+self.luckView.height+20, kScreenWidth-2*kMagin, 20)];
    self.topBottomView.backgroundColor = YKYClearColor;
    [self.backScrollView addSubview:self.topBottomView];
    self.bottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0.6*self.topBottomView.width, self.topBottomView.height)];
    self.bottomLabel.font = [UIFont systemFontOfSize:[myFont getTitle3]];
    self.bottomLabel.textAlignment = NSTextAlignmentLeft;
    self.bottomLabel.textColor = YKYTitleColor;
    [self.topBottomView addSubview:self.bottomLabel];

    CGFloat w = 125;
    self.bottomBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.topBottomView.width-w, 0, w, self.topBottomView.height)];
    [self.bottomBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    self.bottomBtn.titleLabel.font = [UIFont systemFontOfSize:[myFont getTitle3]];
    [self.topBottomView addSubview:self.bottomBtn];
    if (account) {
        self.bottomLabel.text = [NSString stringWithFormat:@"当前账号:%@",[phoneSecret phoneSecretWithPhoneNum:account.phone]];
        [self.bottomBtn setTitle:@"查看我的摇码 >>" forState:UIControlStateNormal];
        [self.bottomBtn addTarget:self action:@selector(lookMyLuckNums) forControlEvents:UIControlEventTouchUpInside];
    }else{
        self.bottomLabel.text = @"您还未登录账号!";
        [self.bottomBtn setTitle:@"去登录 >>" forState:UIControlStateNormal];
        [self.bottomBtn addTarget:self action:@selector(jumpTomyAccountVC) forControlEvents:UIControlEventTouchUpInside];
    }
    self.bottomBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    //分割线
    [line addLineWithFrame:CGRectMake(0, self.topBottomView.y+self.topBottomView.height+10, kScreenWidth, 10) andBackView:self.backScrollView];
}


#pragma mark - 计算详情按钮点击事件
-(void)computingMethodBtnClick{
    DebugLog(@"计算详情按钮被点击");
    YGPrizeDetailVC * vc = [[YGPrizeDetailVC alloc]init];
    NSString * str = [kbaseURL stringByAppendingString:[NSString stringWithFormat:@"/yshakeCoupons/getCalculateInfo?perid=%@&priNum=%@",_prizemodel.serialId,_prizemodel.luckCode]];
    DebugLog(@"==最新揭晓计算详情url==%@",str);
    vc.requestUrl = [NSURL URLWithString:str];
    vc.vcTitle = @"计算详情";
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 查看我的摇码
-(void)lookMyLuckNums{

    lookMyLuckNumVC * vc = [[lookMyLuckNumVC alloc]init];
    vc.prizemodel = self.prizemodel;
    vc.serialId = _serialID;
    DebugLog(@"查看我的摇码按钮被点击========%@======vc%@",self.prizemodel.serialId,vc.prizemodel.serialId);
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 登录我的账号
-(void)jumpTomyAccountVC{
    DebugLog(@"登录我的账号按钮被点击");
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


#pragma mark - 添加中部view
-(void)addMidView{
    CGFloat h = 40;
    UIColor * color = YKYTitleColor;
    //图文详情
    self.imgDetailView = [myCellsRightNoImg addCellWithFrame:CGRectMake(0, self.topBottomView.y+self.topBottomView.height+20, kScreenWidth, h) Title:@"图文详情" titleLabelFont:[myFont getTitle3] titleColor:color titleX:kMagin toView:self.backScrollView VC:self action:@selector(imageDeTailBtnClick)];
    //查看往期
    self.lookOldLuckView = [myCellsRightNoImg addCellWithFrame:CGRectMake(0, self.imgDetailView.y+self.imgDetailView.height, kScreenWidth, h) Title:@"查看往期" titleLabelFont:[myFont getTitle3] titleColor:color titleX:kMagin toView:self.backScrollView VC:self action:@selector(lookOldLuckBtnClick)];

    //分割线
    [line addLineWithFrame:CGRectMake(0, self.lookOldLuckView.y+self.lookOldLuckView.height, kScreenWidth, 10) andBackView:self.backScrollView];

}


#pragma mark - 图文详情按钮点击事件
-(void)imageDeTailBtnClick{
    DebugLog(@"图文详情按钮点击事件");
    YGPrizeDetailVC * vc = [[YGPrizeDetailVC alloc]init];
    NSString * str = [kbaseURL stringByAppendingString:[NSString stringWithFormat:@"/yshakeUtil/shakeProductDetial?pid=%@",_prizemodel.pid]];
    DebugLog(@"==最新揭晓图文详情url=%@",str);
    vc.requestUrl = [NSURL URLWithString:str];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - 查看往期按钮点击事件
-(void)lookOldLuckBtnClick{
    DebugLog(@"查看往期按钮点击事件");
    homeLookOldLuckPrizeVC *lookOldVC = [[homeLookOldLuckPrizeVC alloc]init];
    lookOldVC.vcTitle = @"查看往期";
    lookOldVC.pid = _prizemodel.pid;
    if (!_prizemodel.pid) {
        lookOldVC.pid = _pid;
    }
    [self.navigationController pushViewController:lookOldVC animated:YES];
}


#pragma mark - 添加底部摇购按钮
-(void)addYGBtn{
    CGFloat h = 40;
    UIButton * ygBtn = [[UIButton alloc]initWithFrame:CGRectMake(kMagin , kScreenheight-kMagin-h,kScreenWidth-2*kMagin,h)];
    ygBtn.backgroundColor = YKYColor(249, 60, 67);
    [ygBtn setTitle:@"继续摇购" forState:UIControlStateNormal];
    [ygBtn addTarget:self action:@selector(ygBtnClick) forControlEvents:UIControlEventTouchUpInside];
    ygBtn.titleLabel.font = [UIFont boldSystemFontOfSize:[myFont getTitle1]];
    //设置图片圆角
    ygBtn.layer.cornerRadius = 5;
    ygBtn.layer.masksToBounds = YES;
    ygBtn.layer.borderWidth = 0.01;
    [self.view addSubview:ygBtn];

    //调整滚动范围
    self.backScrollView.contentSize = CGSizeMake(kScreenWidth, _lookOldLuckView.y+_lookOldLuckView.height+3*kMagin+ygBtn.height);
}
-(void)ygBtnClick{
    DebugLog(@"继续摇购");
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    homeTableBarVC *vc = [sb instantiateViewControllerWithIdentifier:@"homeTableBarVC"];
    UIApplication *app = [UIApplication sharedApplication];
    UIWindow *window = app.keyWindow;
    window.rootViewController = vc;
    UIViewController* myvc =  vc.childViewControllers[1];
    vc.selectedViewController = myvc;
}




-(void)loadBanner{
    [self.bannerUrls removeAllObjects];
    
    NSString * bindPath = @"/yshakeUtil/getBanner";
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    if (_pid) {
        [parameters setValue:_pid forKey:@"pid"];
    }else{
        [parameters setValue:self.prizemodel.pid forKey:@"pid"];
    }

    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    [XLRequest AFPostHost:kbaseURL bindPath:bindPath postParam:parameters isClient:NO getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        DebugLog(@"摇购列表详情获取banner=%@",responseDic);
        if ([responseDic[@"code"] isEqual:@0]) {
            NSArray * array = [NSArray arrayWithArray:responseDic[@"data"]];
            if (array.count == 0) {
                DebugLog(@"广告轮播图获取失败");
                return ;
            }
            for (NSDictionary * dic in responseDic[@"data"]) {
                YGBannerModel * model = [YGBannerModel modelWithDict:dic];
                [self.bannerUrls addObject:model];
            }
            //添加banner滚动图片
            [self addTopAdScrollView];
        }else{
            [MBProgressHUD showError:responseDic[@"msg"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"网络加载失败!"];
        DebugLog(@"摇购列表详情获取banner失败==error=%@===oper=%@",error,operation);
    }];
}

#pragma mark - 添加banner滚动图片
- (void)addTopAdScrollView{
    NSMutableArray * imgs = [[NSMutableArray alloc]init];
    for (YGBannerModel *model in self.bannerUrls) {
        //将请求回来的URL字符串转换为URl
        NSURL * url = [NSURL URLWithString:model.banner];
        //添加URL到图片URL数组
        [imgs addObject:url];
    }
    self.adView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, self.adBackView.frame.size.height) imageURLsGroup:imgs];

//    self.adView.delegate = self;
    self.adView.autoScrollTimeInterval = 2.0;
    [self.adView.mainView reloadData];
    [self.adBackView addSubview:self.adView];

}

-(void)updateData{
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    [parameters setValue:_serialID forKey:@"serailId"];
    [XLRequest AFPostHost:kbaseURL bindPath:@"/yshakeUtil/detailCloud" postParam:parameters isClient:NO getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        DebugLog(@"往期中奖人信息查看结果=%@",responseDic);
        if ([responseDic[@"code"] isEqual:@0]) {
            homeNewScuessModel *model = [homeNewScuessModel modelWithDict:responseDic[@"data"][0]];
            self.prizemodel = model;
            self.prizemodel.serialId = [NSString stringWithFormat:@"%@",model.serialId];
            self.prizemodel.luckCode = [NSString stringWithFormat:@"%@",model.luckCode];
            [self.luckView removeFromSuperview];
            self.pnameLabel.text = model.pname;
            self.luckView = [homeNewScuessDetailLuckerView addViewWithFrame:CGRectMake(kMagin, self.pnameLabel.y+self.pnameLabel.height+10, kScreenWidth-2*kMagin, 140) toView:self.backScrollView VC:self JisuanAction:@selector(computingMethodBtnClick) headUrlStr:model.headImage uname:model.uname luckTimeStr:model.luckCount joinTimeStr:model.ptime luckNumStr:model.priNum serials:model.serials];
        }else{
            [MBProgressHUD showError:@"获奖人信息加载失败!"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"获奖人信息加载失败!"];
        [self.navigationController popViewControllerAnimated:YES];
        DebugLog(@"往期中奖人信息查看失败error=%@",error);
    }];
}



@end
