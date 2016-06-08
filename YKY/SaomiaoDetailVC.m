//
//  SaomiaoDetailVC.m
//  YKY
//
//  Created by 肖 亮 on 16/5/30.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "SaomiaoDetailVC.h"
#import "unUsedPrizeModel.h"
#import "boundsPrizeDetailModel.h"
#import "AccountTool.h"
#import "Account.h"


#define kmagin 15


@interface SaomiaoDetailVC ()<UIAlertViewDelegate>

@property(nonatomic , strong) UIScrollView * scrollView;
@property (nonatomic , strong) boundsPrizeDetailModel * prizeModel;
@property (nonatomic , strong) UIAlertView * secuessAlter;
@property (nonatomic , strong) UIAlertView * okDuihuan;
@property (nonatomic , strong) UIAlertView * backAlter;

@end

@implementation SaomiaoDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"奖品详情";
    self.view.backgroundColor = [UIColor whiteColor];
    if (!self.model) {
        [MBProgressHUD showError:@"网络状况不佳,请稍后再试!"];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }

    [self setLeft];

    [self loadData];
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


-(void)loadData{
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    Account * account = [AccountTool account];
    if (![AccountTool account] || !self.model.cid) {
        return;
    }
    NSString * str = kboundDetailDataStr;

    NSDictionary *parameter = @{@"couponsId":self.model.cid,@"userId":account.uiId,@"client":Kclient,@"serverToken":account.reponseToken};

    DebugLog(@"===%@",parameter);
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    [manager POST:str parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DebugLog(@"==%@",responseObject);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([responseObject[@"code"] isEqual:@(0)]) {
            for (NSDictionary * dict in responseObject[@"data"]) {
                self.prizeModel = [boundsPrizeDetailModel modelWithDict:dict];
            }
            [self addSubView];
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



#pragma mark - 添加子控件
-(void)addSubView{
//scrollView
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenheight)];
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, kScreenheight);
    self.scrollView.backgroundColor = YKYColor(242, 242, 242);
    [self.view addSubview:self.scrollView];

//顶部承载view
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, 0.36*kScreenheight)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:topView];

    DebugLog(@"===%f====%f",self.scrollView.y,topView.y);

    //图片
    CGFloat magin = 10;
    UIImageView * imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, topView.height-50)];
    [imgView sd_setImageWithURL:[NSURL URLWithString:self.model.url] placeholderImage:[UIImage imageNamed:@"prepare_loading_big"]];
    [topView addSubview:imgView];

    //奖品名称有效期价格
    CGFloat priceW= [getLabelHeight wigthWithConnect:[NSString stringWithFormat:@"¥%@",self.prizeModel.marketPrice] andHeight:15 font:[myFont getTitle3]];
    CGFloat pnameLH = [getLabelHeight heightWithConnect:_model.pname andLabelW:kScreenWidth-3*kmagin-priceW font:[myFont getTitle2]];
    UILabel * pnameL = [[UILabel alloc]initWithFrame:CGRectMake(kmagin, imgView.height+magin, kScreenWidth-3*kmagin-priceW, pnameLH)];
    UILabel * priceL = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-kmagin-priceW, pnameL.y+pnameL.height-15, priceW, 15)];
    pnameL.text = [NSString stringWithFormat:@"%@ (%@)",_model.pname,[NSString stringWithFormat:@"有效期%@",_model.etime]];
    pnameL.font = [UIFont systemFontOfSize:[myFont getTitle2]];
    priceL.text = [NSString stringWithFormat:@"¥%@",self.prizeModel.marketPrice];
    priceL.font = [UIFont systemFontOfSize:[myFont getTitle3]];
    pnameL.textColor = YKYTitleColor;
    priceL.textColor = [UIColor redColor];
    [topView addSubview:pnameL];
    [topView addSubview:priceL];
    //修改topview高度
    topView.frame = CGRectMake(0, 64, kScreenWidth, pnameL.y+pnameL.height+magin);


//中部使用规则
    UILabel * useLabel = [[UILabel alloc]initWithFrame:CGRectMake(kmagin, topView.y+topView.height+kmagin, 200, 17)];
    useLabel.text = @"使用规则";
    useLabel.textColor = YKYTitleColor;
    [_scrollView addSubview:useLabel];

    //小点
    UIImageView * dianV = [[UIImageView alloc]initWithFrame:CGRectMake(kmagin, useLabel.y+useLabel.height+kmagin+8, 4, 4)];
    dianV.image = [UIImage imageNamed:@""];
    [_scrollView addSubview:dianV];
    CGFloat userLH = [getLabelHeight heightWithConnect:self.prizeModel.instructions andLabelW:kScreenWidth-2*kmagin font:[myFont getTitle3]];
    UILabel * dianL = [[UILabel alloc]initWithFrame:CGRectMake(kmagin, useLabel.y+useLabel.height+8, kScreenWidth-3*kmagin, userLH)];
    dianL.numberOfLines = 0;
    dianL.textColor = YKYDeTitleColor;
    dianL.font = [UIFont systemFontOfSize:[myFont getTitle3]];
    dianL.text = self.prizeModel.instructions;
    [_scrollView addSubview:dianL];


//底部悬浮view 提示以及兑换按钮
    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenheight-44, kScreenWidth, 44)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];

    //提示文字和兑换按钮
    CGFloat btnW = 100;
    UILabel * tishiL = [[UILabel alloc]initWithFrame:CGRectMake(kmagin, 12, kScreenWidth-2*kmagin-btnW, 20)];
    tishiL.textColor = [UIColor redColor];
    tishiL.text = @"*请在商户员工知道下点击确认使用";
    tishiL.font = [UIFont systemFontOfSize:[myFont getTitle4]];
    [bottomView addSubview:tishiL];

    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-kmagin-btnW, 10, btnW, 24)];
    [btn setTitle:@"我要兑换" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor redColor];
    btn.titleLabel.font = [UIFont systemFontOfSize:[myFont getTitle3]];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(duihuan) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:btn];
    //设置图片圆角
    btn.layer.cornerRadius = 8;
    btn.layer.masksToBounds = YES;
    btn.layer.borderWidth = 0.01;

}

-(void)duihuan{
    self.okDuihuan = [[UIAlertView alloc]initWithTitle:@"确认兑换" message:@"您即将兑换该奖品，点击确定按钮完成兑换!" delegate:self cancelButtonTitle:@"暂不兑换" otherButtonTitles:@"确认兑换", nil];
    [self.okDuihuan show];
}

#pragma mark - 确认兑换
-(void)duihuanOK{
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    NSString *str = kUserUsePrizeStr;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    if (self.model.cid == nil) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"交易失败!"];
        return;
    }
    NSString * stringValue = [[NSUserDefaults standardUserDefaults]objectForKey:@"bossIDAndPhone"];
    NSArray * array = [NSArray array];
    array = [stringValue componentsSeparatedByString:@"@"];
    if (!self.model.cid && !array[0]) {
        return;
    }
    NSDictionary * parameters = @{@"couponsId":self.model.cid,@"mId":array[0]};
    [manager POST:str parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"code"] isEqual:@(0)]) {
            [MBProgressHUD showSuccess:@"交易成功!"];
//            //兑换成功后操作
            [self duiOk];//完成兑换的提示
        }else{
            [MBProgressHUD showError:responseObject[@"msg"]];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"网络加载失败"];
    }];
}

-(void)duihuanSeccuss{
    self.secuessAlter = [[UIAlertView alloc]initWithTitle:@"*请商户工作人员点击确认使用" message:@"确认选择兑换券" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    self.secuessAlter.tintColor = [UIColor redColor];
    [self.secuessAlter show];
}

-(void)duiOk{
    self.backAlter = [[UIAlertView alloc]initWithTitle:@"恭喜您!" message:[NSString stringWithFormat:@"您已成功兑换:\"%@\"",self.prizeModel.pname] delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
    [self.backAlter show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            if ([alertView isEqual:self.backAlter]) {
                [self.navigationController popViewControllerAnimated:YES];
            }
            break;
        case 1:
            if ([alertView isEqual:self.secuessAlter]) {
                [self duihuanOK];
            }
            if ([alertView isEqual:self.okDuihuan]) {
                [self duihuanSeccuss];
            }
            break;

        default:
            break;
    }
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
