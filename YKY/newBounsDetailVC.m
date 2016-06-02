//
//  newBounsDetailVC.m
//  YKY
//
//  Created by 肖亮 on 15/9/18.
//  Copyright (c) 2015年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "newBounsDetailVC.h"
#import "mapVC.h"
#import "AFNetworking.h"
#import "common.h"
#import "MBProgressHUD+MJ.h"
#import "UIImageView+WebCache.h"
#import "UMSocial.h"
#import "AccountTool.h"
#import "usedPrizeVC.h"
#import "Account.h"
#import <CommonCrypto/CommonDigest.h>
#import "UIView+XL.h"
#import "detailTitleLabel.h"
#import "rightDownLocationBtn.h"
#import "getLabelHeight.h"
#import "sharToFrend.h"
#import "boundsPrizeDetailModel.h"
#import "duihuanyinbi.h"


@interface newBounsDetailVC ()<UMSocialUIDelegate,UIAlertViewDelegate,UIScrollViewDelegate,UIActionSheetDelegate>


/** 滚动容器 */
@property (nonatomic , strong) UIScrollView * backScrollView;
/** 顶部固定视图 */
@property (nonatomic , strong) UIView * smallBackView;


/** 使用规则 */
@property (nonatomic , strong) UILabel * prizeDeTitle;
/** 奖品详情 */
@property (nonatomic , strong) UILabel * bossDeTitle;
/** 联系电话 */
@property (nonatomic , strong) UILabel * bossPhTitle;
/** 有效期 */
@property (nonatomic , strong) UILabel * endTimTitle;
/** 兑换地址 */
@property (nonatomic , strong) UILabel * bossAdrTitle;


/** 奖品图片imagview */
@property (strong, nonatomic) UIImageView *prizeImageView;
/** 奖品名字Label */
@property (strong, nonatomic) UILabel *prizeNameLabel;
/** 奖品价格Label （要拼接￥） */
@property (strong, nonatomic) UILabel *prizePriceLabel;
/** 使用奖品按钮 */
@property (strong, nonatomic) UIButton *useBtn;
/** 兑换银币按钮 */
@property (strong, nonatomic) UIButton *duihuanBtn;
/** 使用规则Label */
@property (strong, nonatomic) UILabel *bossDescLabel;
/** 商家电话Label */
@property (strong, nonatomic) UILabel *bossPhoneNmbLabel;
/** 有效期结束时间Label */
@property (strong, nonatomic) UILabel *endDateLabel;
/** 商家地址Label */
@property (strong, nonatomic) UILabel *bossAdressLabel;
/** 奖品详情 */
@property (strong, nonatomic) UILabel *prizeDescLabel;

@property (nonatomic , strong) boundsPrizeDetailModel * boundsDetailModel;

//奖品类型（未使用：0、已使用：1、已过期：2）
@property (nonatomic , copy) NSString * prizetype;
@property (nonatomic , strong) NSMutableArray * phoneArray;
@property (nonatomic , copy) NSString * str1;
@property (nonatomic , copy) NSString * str2;


@end

@implementation newBounsDetailVC

-(NSMutableArray *)phoneArray{
    if (_phoneArray == nil) {
        self.phoneArray = [[NSMutableArray alloc]init];
    }
    return _phoneArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"奖品详情";
    
    //添加scrollView
    NSString * devStr = [[UIDevice currentDevice]systemVersion];
    float dev = [devStr floatValue];
    UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0,self.view.width, self.view.height)];
    self.backScrollView = scrollView;
    if (dev >= 9.0) {
        scrollView.frame = CGRectMake(0, 0,self.view.width, self.view.height);
    }
    self.backScrollView.contentInset = UIEdgeInsetsMake(0, 0, kScreenheight*0.5, 0);
    [self.view addSubview:self.backScrollView];
    
    
//    //设置使用奖品按钮圆角
//    self.useBtn.layer.cornerRadius = 5;
//    self.useBtn.layer.masksToBounds = YES;
//    self.useBtn.layer.borderWidth = 0.1;
//    //设置兑换银币按钮圆角
//    self.duihuanBtn.layer.cornerRadius = 5;
//    self.duihuanBtn.layer.masksToBounds = YES;
//    self.duihuanBtn.layer.borderWidth = 0.1;

    //请求详情数据
    [self getDataOfPrize];
}

#pragma mark - 获取奖品数据
-(void)getDataOfPrize{
    
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    Account * account = [AccountTool account];
    NSString * str = kboundDetailDataStr;

    NSDictionary *parameter = @{@"couponsId":self.couponsId,@"userId":account.uiId,@"client":Kclient,@"serverToken":account.reponseToken};

    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    [manager POST:str parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DebugLog(@"==%@",responseObject);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([responseObject[@"code"] isEqual:@(0)]) {
            for (NSDictionary * dict in responseObject[@"data"]) {
                self.boundsDetailModel = [boundsPrizeDetailModel modelWithDict:dict];
            }
            [self setDataWithModel];
        }else if([responseObject[@"code"] isEqual:KotherLogin]){
            [MBProgressHUD showError:@"账号已过有效期,请重新登录!"];
            [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(jumpToMyaccountVC) userInfo:nil repeats:NO];
            return ;
        }else{
            [MBProgressHUD showError:responseObject[@"msg"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"网络加载失败!"];
    }];
}


#pragma mark - 设置界面数据
-(void)setDataWithModel{
    [self addBigBackViewSubViews];
}

#pragma mark - 添加非固定位置子控件
-(void)addBigBackViewSubViews{
    
    //添加顶部固定视图
    [self addTopView];
    
    //添加使用和删除按钮
    [self addUsePrizeBtn];
    
    //添加使用规则
    [self addPrizeDetail];
    
    //添加奖品详情
    [self addBossDesc];
    
    //添加联系电话
    [self addPhoneLabel];
    
    //添加有效期
    [self addEndDate];
    
    //添加兑换地址
    [self addBossAdress];

    self.navigationItem.title = self.boundsDetailModel.mname;
}

#pragma mark - 添加固定位置View
-(void)addTopView{
    
    
    //主背景
    UIView * TopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height*0.36)];
    TopView.backgroundColor = [UIColor whiteColor];
    self.smallBackView = TopView;
    [self.backScrollView addSubview:TopView];
    
    //图片
    CGFloat IMGVH = TopView.height * 0.83;
    UIImageView * imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, TopView.width, IMGVH)];
    [TopView addSubview:imgView];
    self.prizeImageView = imgView;
    [self.prizeImageView sd_setImageWithURL:[NSURL URLWithString:self.boundsDetailModel.url] placeholderImage:[UIImage imageNamed:@"prepare_loading_big"]];
    
    //奖品名字和价格
    CGFloat priceLbW = 70;
    UILabel * prizeNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, IMGVH, TopView.width-priceLbW-8, TopView.height-IMGVH)];
    prizeNameLabel.text = self.boundsDetailModel.pname;
    prizeNameLabel.font = [UIFont systemFontOfSize:14];
    [TopView addSubview:prizeNameLabel];
    //价格label
    UILabel * priceLB = [[UILabel alloc]initWithFrame:CGRectMake(TopView.width-priceLbW-8, IMGVH, priceLbW, TopView.height-IMGVH)];
    priceLB.font = [UIFont systemFontOfSize:14];
    NSString * RMB = @"￥";
    NSString * price = [RMB stringByAppendingFormat:@"%@",self.boundsDetailModel.marketPrice];
    priceLB.text = price;
    priceLB.textAlignment = NSTextAlignmentRight;
    [TopView addSubview:priceLB];

    //底线
    UIView * bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, TopView.height-1, TopView.width, 1)];
    bottomLine.backgroundColor = [UIColor colorWithRed:217.0/255.0 green:217.0/255.0 blue:217.0/255.0 alpha:1.0];
    [TopView addSubview:bottomLine];
}

#pragma mark - 添加使用奖品按钮
-(void)addUsePrizeBtn{
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(10, self.smallBackView.y+self.smallBackView.height+20, self.view.width-20, 40)];
    //设置使用按钮圆角
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    button.layer.borderWidth = 0.1;
    
    UIButton * deBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, button.y+button.height+8, button.width, button.height)];
    //设置删除按钮圆角
    deBtn.layer.cornerRadius = 5;
    deBtn.layer.masksToBounds = YES;
    deBtn.layer.borderWidth = 0.1;
    [deBtn setBackgroundImage:[UIImage imageNamed:@"yuanjiaojuxing"] forState:UIControlStateNormal];

    [self.backScrollView addSubview:button];
    [self.backScrollView addSubview:deBtn];

    [button setTitle:@"使用奖品"forState:UIControlStateNormal];
    button.enabled = YES;
    button.backgroundColor = [UIColor redColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [deBtn setTitle:@"兑换银币" forState:UIControlStateNormal];
    deBtn.backgroundColor = [UIColor whiteColor];
    [deBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    //按钮事件
    [button addTarget:self action:@selector(useBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [deBtn addTarget:self action:@selector(duihuanyinbiBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //按钮全局化
    self.useBtn = button;
    self.duihuanBtn = deBtn;
}


#pragma mark - 添加使用规则
-(void)addPrizeDetail{
    //标题
    self.prizeDeTitle = [[detailTitleLabel alloc]initWithFrame:CGRectMake(10, self.duihuanBtn.y+self.duihuanBtn.height+30, 80, 20)];
    self.prizeDeTitle.text = @"使用规则:";
    [self.backScrollView addSubview:self.prizeDeTitle];

    //详情内容
    NSString * connect = [self.boundsDetailModel.instructions  stringByReplacingOccurrencesOfString:@" " withString:@""];
    connect = [connect  stringByReplacingOccurrencesOfString:@"	" withString:@""];
    connect = [connect stringByReplacingOccurrencesOfString:@"\\r" withString:@""];
    connect = [connect stringByReplacingOccurrencesOfString:@"\\n" withString:@""];

    CGFloat maxHeight = [getLabelHeight heightWithConnect:connect andLabelW:self.view.width-30 font:[myFont getTitle3]];
    UILabel * label = [getLabelHeight labelWithFrame:CGRectMake(10, self.prizeDeTitle.y+self.prizeDeTitle.height, self.view.width-30, maxHeight+8) andConnect:connect font:[myFont getTitle3]];
    self.bossDescLabel = label;
    [self.backScrollView addSubview:label];
}

#pragma mark - 添加奖品详情
-(void)addBossDesc{
    
    //标题
    self.bossDeTitle = [[detailTitleLabel alloc]initWithFrame:CGRectMake(10, self.bossDescLabel.y+self.bossDescLabel.height+20, 80, 20)];
    self.bossDeTitle.text = @"奖品详情:";
    [self.backScrollView addSubview:self.bossDeTitle];

    //描述详情
    NSString * connect = [self.boundsDetailModel.introduction  stringByReplacingOccurrencesOfString:@" " withString:@""];
    connect = [connect  stringByReplacingOccurrencesOfString:@"	" withString:@""];
    connect = [connect stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    connect = [connect  stringByReplacingOccurrencesOfString:@"\n" withString:@""];

    CGFloat maxHeight = [getLabelHeight heightWithConnect:connect andLabelW:self.view.width-30 font:[myFont getTitle3]];
    UILabel * label = [getLabelHeight labelWithFrame:CGRectMake(10, self.bossDeTitle.y+self.bossDeTitle.height, self.view.width-30, maxHeight+8) andConnect:connect font:[myFont getTitle3]];
    self.bossDescLabel = label;
    [self.backScrollView addSubview:label];
}

#pragma mark - 添加联系电话
-(void)addPhoneLabel{
    //标题
    self.bossPhTitle = [[detailTitleLabel alloc]initWithFrame:CGRectMake(10, self.bossDescLabel.y+self.bossDescLabel.height+20, 80, 20)];
    self.bossPhTitle.text = @"联系电话:";
    [self.backScrollView addSubview:self.bossPhTitle];

    //电话号码
    CGFloat with = [getLabelHeight wigthWithConnect:self.boundsDetailModel.servicePhone andHeight:16 font:14];
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, self.bossPhTitle.y+self.bossPhTitle.height+10, with, 16)];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor darkGrayColor];
    label.text = self.boundsDetailModel.servicePhone;
    self.bossPhoneNmbLabel = label;
    [self.backScrollView addSubview:label];
    
    //竖线
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(label.x+label.width+1, label.y, 1, label.height)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.backScrollView addSubview:lineView];
    
    //电话按钮
    [self addCallPohneBtn];
}

#pragma mark - 添加电话按钮
-(void)addCallPohneBtn{
    
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(self.bossPhoneNmbLabel.frame.origin.x+self.bossPhoneNmbLabel.frame.size.width+15, self.bossPhoneNmbLabel.frame.origin.y, 15, 16)];
    [button setImage:[UIImage imageNamed:@"dianhua-prizeDetail"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(callBossBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.backScrollView addSubview:button];
    
}

#pragma mark - 有效期
-(void)addEndDate{
    
    //标题
    self.endTimTitle = [[detailTitleLabel alloc]initWithFrame:CGRectMake(10, self.bossPhoneNmbLabel.y+self.bossPhoneNmbLabel.height+20, 80, 20)];
    self.endTimTitle.text = @"有效期:";
    [self.backScrollView addSubview:self.endTimTitle];

    //电话号码
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, self.endTimTitle.y+self.endTimTitle.height+10, self.view.width-60, 20)];
    label.textColor = [UIColor darkGrayColor];
    label.font = [UIFont systemFontOfSize:14];
    self.endDateLabel = label;
    if (self.boundsDetailModel.etime) {
        self.endDateLabel.text = [NSString stringWithFormat:@"截止时间：%@",self.boundsDetailModel.etime];
    }

    [self.backScrollView addSubview:label];
    
}


#pragma mark - 兑换地址
-(void)addBossAdress{
    
    //标题
    self.bossAdrTitle = [[detailTitleLabel alloc]initWithFrame:CGRectMake(10, self.endDateLabel.y+self.endDateLabel.height+20, 80, 20)];
    self.bossAdrTitle.text = @"商家地址:";
    [self.backScrollView addSubview:self.bossAdrTitle];

    //地址详情
    NSString * connect = [self.boundsDetailModel.address  stringByReplacingOccurrencesOfString:@" " withString:@""];
    connect = [connect  stringByReplacingOccurrencesOfString:@"	" withString:@""];
    connect = [connect  stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    connect = [connect  stringByReplacingOccurrencesOfString:@"\t" withString:@""];

    CGFloat maxHeight = [getLabelHeight heightWithConnect:connect andLabelW:self.view.width-20 font:[myFont getTitle3]];
    UILabel * label = [getLabelHeight labelWithFrame:CGRectMake(10, self.bossAdrTitle.y+self.bossAdrTitle.height, self.view.width-20, maxHeight+8) andConnect:connect font:[myFont getTitle3]];

    self.bossAdressLabel = label;
    [self.backScrollView addSubview:label];
    
    //添加右下角导航按钮
    [rightDownLocationBtn addLocationBtnWithSuperView:self.backScrollView andLeftView:self.bossAdressLabel andAction:@selector(locationBtnClick) andViewController:self];

    self.backScrollView.contentSize = CGSizeMake(self.view.width,label.y+label.height-250);
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"duihuanSeccess"];
    [self setLeftNavBtn];
}

-(void)viewWillDisappear:(BOOL)animated{
//    self.identify = @"0";
}

#pragma mark - 设置左导航nav
-(void)setLeftNavBtn{
    //左导航按钮
    UIBarButtonItem * left = [[UIBarButtonItem alloc]initWithTitle:@"<返回" style:UIBarButtonItemStylePlain target:self action:@selector(leftClick)];
    left.tintColor = [UIColor whiteColor];
    [left setImage:[UIImage imageNamed:@"jiantou-Left"]];
    self.navigationItem.leftBarButtonItem = left;
    
    //右导航按钮
    UIBarButtonItem * right = [[UIBarButtonItem alloc]initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(rightClick)];
    right.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = right;
    
}
-(void)leftClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 分享按钮点击事件
-(void)rightClick{
    Account * account = [AccountTool account];
    [sharToFrend shareWithImgurl:self.boundsDetailModel.url andPid:self.boundsDetailModel.pid phone:account.phone andVC:self];
//    [sharToFrend shareWithImgurl:self.boundsDetailModel.url andPname:self.boundsDetailModel.pname phone:account.phone andVC:self];
//    [sharToFrend shareWithType:self.Type andImgurl:self.boundsDetailModel.url andCouponsId:self.couponsId andVC:self];
}



#pragma mark - 使用奖品按钮点击事件
- (void)useBtnClick:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    usedPrizeVC *usePrizeVc = [sb instantiateViewControllerWithIdentifier:@"usedPrizeVC"];
    usePrizeVc.identafy = @"2";
    usePrizeVc.bPDetailModel = self.boundsDetailModel;
    [self.navigationController pushViewController:usePrizeVc animated:YES];
    
}

#pragma mark - 联系商家按钮点击事件
- (void)callBossBtnClick{
    NSString * string = self.boundsDetailModel.servicePhone;
    if (string.length >= 14) {
        NSArray * array = [[NSArray alloc]init];
        array = [self.boundsDetailModel.servicePhone componentsSeparatedByString:@" "];
        for (NSString * str in array) {
            if (str.length>10) {
                [self.phoneArray addObject:str];
            }
        }
        self.str1 = self.phoneArray[0];
        self.str2 = self.phoneArray[1];
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"拨号" message:string delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拨号1",@"拨号2", nil];
        [alert show];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"拨号" message:string delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            break;
        case 1:
            
            if (self.str1) {
               [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.str1]]];//打电话
            }else{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.boundsDetailModel.servicePhone]]];//打电话
            }
            break;
        case 2:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.str2]]];//打电话
            break;
        default:
            break;
    }
}

#pragma mark - 导航按钮点击事件
- (void)locationBtnClick{
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    mapVC *vc = [sb instantiateViewControllerWithIdentifier:@"mapVC"];
    vc.boundsPrizeDetailModel = self.boundsDetailModel;
    vc.indentify = @"1";
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - 兑换银币按钮点击事件
- (void)duihuanyinbiBtnClick:(id)sender {
    UIActionSheet * actionSheet = [[UIActionSheet alloc]initWithTitle:@"确认兑换" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"确定", nil];
    actionSheet.delegate = self;
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;//设置样式
    [actionSheet showInView:self.view];

}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            [self changeSilv];
            break;
        case 1:
            
            break;
            
        default:
            break;
    }
}
//兑换银币操作
-(void)changeSilv{
    
    NSString *str = kboundPrizeduihuanYb;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    Account *account = [AccountTool account];
    
    NSDictionary *parameters = @{@"userId":account.uiId,@"couponsId":self.couponsId,@"client":Kclient,@"serverToken":account.reponseToken};
    DebugLog(@"-详情兑换银币parameter=%@",parameters);
    [manager POST:str parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DebugLog(@"-详情兑换银币请求返回结果=%@",responseObject);
        if ([responseObject[@"code"] isEqual:@(0)]) {
            [MBProgressHUD showSuccess:responseObject[@"msg"]];
            [[NSUserDefaults standardUserDefaults]setObject:responseObject[@"data"][0][@"glod"] forKey:@"gold"];
            [[NSUserDefaults standardUserDefaults]setObject:responseObject[@"data"][0][@"silver"] forKey:@"silverCoin"];
            [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"chargeSuccess"];
            [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(back) userInfo:nil repeats:NO];
            DebugLog(@"=-=-=-INDE=%@",_identify);
            if ([self.identify isEqualToString:@"1"]) {
                [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"duihuanSeccess"];
            }else{
                [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"duihuanSeccess"];
            }
        }else{
            [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"duihuanSeccess"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"duihuanSeccess"];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"兑换失败,请检查您的网络!"];
    }];
}

-(void)back{
    [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"shuaxin"];
    [self.navigationController popViewControllerAnimated:YES];
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

-(void)jumpToMyaccountVC{
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
