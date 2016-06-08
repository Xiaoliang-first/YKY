//
//  homePrizeDetailVC.m
//  YKY
//
//  Created by 肖亮 on 15/9/15.
//  Copyright (c) 2015年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "homePrizeDetailVC.h"
#import "MBProgressHUD+MJ.h"
#import "AFNetworking.h"
#import "common.h"
#import "prizeDetailModel.h"
#import "UIImageView+WebCache.h"
#import "bossEnvironmentVC.h"
#import "managerCommendatoryVC.h"
#import "mapVC.h"
#import "NumberModel.h"
#import "viewsNMB_Tool.h"
#import "detailTitleLabel.h"
#import "UIView+XL.h"
#import "rightDownLocationBtn.h"
#import "getLabelHeight.h"


#define dirDoc [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"ClickNumFile.data"]

@interface homePrizeDetailVC ()<UIAlertViewDelegate>


/** 大scrollView容器 */
@property (weak, nonatomic) UIScrollView *backScrollView;


//承载固定控件的VIew
@property (strong, nonatomic) UIView *smallBackView;
/** 右上角的奖字 */
@property (strong, nonatomic) UIImageView *rightTopImageView;
/** 奖品图片（大图） */
@property (strong, nonatomic) UIImageView *prizeImageView;
/** 奖品名字Label */
@property (strong, nonatomic) UILabel *prizeNameLabel;
/** 奖品价格label需要拼接“￥” */
@property (strong, nonatomic) UILabel *prizePriceLabel;





@property (nonatomic , strong) detailTitleLabel * prizeDeTitle;
/** 奖品详情的Label */
@property (strong, nonatomic) UILabel *prizeDetailLabel;
@property (nonatomic , strong) detailTitleLabel * bossDeTitle;
/** 商家描述Label */
@property (strong, nonatomic) UILabel *bossDescLabel;
@property (nonatomic , strong) detailTitleLabel * bossPhTitle;
/** 商家电话Label */
@property (strong, nonatomic) UILabel *bossPhoneNmbLabel;
@property (nonatomic , strong) detailTitleLabel * bossAdrTitle;
/** 商家地址Label */
@property (strong, nonatomic) UILabel *bossAdressLabel;


/** 当前详情数据的Model */
@property (nonatomic , strong) prizeDetailModel * prizeDetailModel;

@property (nonatomic , strong) NSMutableArray * phoneArray;
@property (nonatomic , copy) NSString * str1;
@property (nonatomic , copy) NSString * str2;


@end

@implementation homePrizeDetailVC

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
    self.backScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.backScrollView];

    
    //加载数据
    [self loadData];
}

#pragma mark - 添加非固定位置子控件
-(void)addBigBackViewSubViews{
    
    //添加顶部固定视图
    [self addTopView];
    
    //添加奖品详情
    [self addPrizeDetail];
    
    //添加商家描述
    [self addBossDesc];
    
    //添加联系电话
    [self addPhoneLabel];
    
    //添加兑换地址
    [self addBossAdress];
    
}

#pragma mark - 添加固定位置View
-(void)addTopView{
    
//主背景
    UIView * TopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height*0.35)];
    TopView.backgroundColor = [UIColor whiteColor];
    self.smallBackView = TopView;
    [self.backScrollView addSubview:TopView];
    
    //图片
    CGFloat IMGVH = TopView.height * 0.83;
    UIImageView * imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, TopView.width, IMGVH)];
    [TopView addSubview:imgView];
    self.prizeImageView = imgView;
    [self.prizeImageView sd_setImageWithURL:[NSURL URLWithString:self.prizeDetailModel.url] placeholderImage:[UIImage imageNamed:@"prepare_loading_big"]];
    
//奖品名字和价格
    CGFloat priceLbW = 100;

    CGFloat laH = [getLabelHeight heightWithConnect:self.prizeDetailModel.pname andLabelW:TopView.width-priceLbW-8 font:[myFont getTitle2]];
    UILabel * prizeNameLabel = [getLabelHeight labelWithFrame:CGRectMake(8, IMGVH, TopView.width-priceLbW-8, 1.2*laH) andConnect:self.prizeDetailModel.pname font:[myFont getTitle2]];
    prizeNameLabel.textColor = YKYTitleColor;
    [TopView addSubview:prizeNameLabel];
    //修正topview高度
    TopView.frame = CGRectMake(0, 0, self.view.width, prizeNameLabel.y+prizeNameLabel.height+8);
    //价格label
    UILabel * priceLB = [[UILabel alloc]initWithFrame:CGRectMake(TopView.width-priceLbW-8, IMGVH-4, priceLbW, TopView.height-IMGVH)];
    priceLB.font = [UIFont systemFontOfSize:[myFont getTitle2]];
    NSString * RMB = @"￥";
    NSString * price = [RMB stringByAppendingFormat:@"%d",[self.prizeDetailModel.marketPrice intValue]];
    priceLB.text = price;
    priceLB.textColor = [UIColor redColor];
    priceLB.textAlignment = NSTextAlignmentRight;
    [TopView addSubview:priceLB];

    
    
//商家环境和店长推荐
    UIView * bEBcakV = [[UIView alloc]initWithFrame:CGRectMake(0, IMGVH-30, TopView.width, 30)];
    bEBcakV.backgroundColor = [UIColor blackColor];
    bEBcakV.alpha = kalpha;
    [TopView addSubview:bEBcakV];
    //商家推荐按钮
    UIButton * bEBtn = [[UIButton alloc]initWithFrame:CGRectMake(bEBcakV.centerX-82, bEBcakV.y, 80, bEBcakV.height)];
    [bEBtn setTitle:@"商家环境" forState:UIControlStateNormal];
    bEBtn.backgroundColor = [UIColor clearColor];
    bEBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [bEBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bEBtn addTarget:self action:@selector(bossEventBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [TopView addSubview:bEBtn];
    //灰色间隔线
    UIView * linView = [[UIView alloc]initWithFrame:CGRectMake(bEBcakV.centerX, bEBcakV.y+8, 1, bEBcakV.height-16)];
    linView.backgroundColor = [UIColor whiteColor];
    [TopView addSubview:linView];
    //店长推荐按钮
    UIButton * dztjBtn = [[UIButton alloc]initWithFrame:CGRectMake(bEBcakV.centerX+1, bEBcakV.y+1, 80, bEBcakV.height)];
    dztjBtn.backgroundColor = [UIColor clearColor];
    [dztjBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    dztjBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [dztjBtn setTitle:@"店长推荐" forState:UIControlStateNormal];
    [dztjBtn addTarget:self action:@selector(bossCommentdoaryBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [TopView addSubview:dztjBtn];

//底线
    UIView * bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, TopView.height-1, TopView.width, 1)];
    bottomLine.backgroundColor = [UIColor colorWithRed:217.0/255.0 green:217.0/255.0 blue:217.0/255.0 alpha:1.0];
    [TopView addSubview:bottomLine];

}


#pragma mark - 添加奖品详情
-(void)addPrizeDetail{
    //标题
    self.prizeDeTitle = [[detailTitleLabel alloc]initWithFrame:CGRectMake(10, self.smallBackView.y+self.smallBackView.height+20, 80, 20)];
    self.prizeDeTitle.text = @"奖品详情:";
    [self.backScrollView addSubview:self.prizeDeTitle];
    
    //详情内容
    NSString * connect = [self.prizeDetailModel.pintroduction  stringByReplacingOccurrencesOfString:@" " withString:@""];
    connect = [connect  stringByReplacingOccurrencesOfString:@"	" withString:@""];
    connect = [connect stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    connect = [connect  stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    CGFloat maxHeight = [getLabelHeight heightWithConnect:connect andLabelW:self.view.width-30 font:[myFont getTitle3]];
    
    UILabel * label = [getLabelHeight labelWithFrame:CGRectMake(10, self.prizeDeTitle.y+self.prizeDeTitle.height, self.view.width-30, maxHeight+16) andConnect:connect font:[myFont getTitle3]];
    
    self.prizeDetailLabel = label;
    
    [self.backScrollView addSubview:label];
}

#pragma mark - 添加商家描述
-(void)addBossDesc{
    
    //标题
    self.bossDeTitle = [[detailTitleLabel alloc]initWithFrame:CGRectMake(10, self.prizeDetailLabel.y+self.prizeDetailLabel.height+10, 80, 20)];
    self.bossDeTitle.text = @"商家描述:";
    [self.backScrollView addSubview:self.bossDeTitle];

    //描述详情
    NSString * connect = [self.prizeDetailModel.mintroduction  stringByReplacingOccurrencesOfString:@" " withString:@""];
    connect = [connect  stringByReplacingOccurrencesOfString:@"	" withString:@""];
    connect = [connect stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    connect = [connect  stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    CGFloat maxHeight = [getLabelHeight heightWithConnect:connect andLabelW:self.view.width-30 font:[myFont getTitle3]];
    
    UILabel * label = [getLabelHeight labelWithFrame:CGRectMake(10, self.bossDeTitle.y+self.bossDeTitle.height, self.view.width-30, maxHeight+16) andConnect:connect font:[myFont getTitle3]];
    
    self.bossDescLabel = label;
    [self.backScrollView addSubview:label];
    
}

#pragma mark - 添加联系电话
-(void)addPhoneLabel{
    //标题
    self.bossPhTitle = [[detailTitleLabel alloc]initWithFrame:CGRectMake(10, self.bossDescLabel.y+self.bossDescLabel.height+10, 80, 20)];
    self.bossPhTitle.text = @"联系电话:";
    [self.backScrollView addSubview:self.bossPhTitle];

    
    //电话号码
    CGFloat with = [getLabelHeight wigthWithConnect:self.prizeDetailModel.servicePhone andHeight:16 font:14];
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, self.bossPhTitle.y+self.bossPhTitle.height+10, with, 16)];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor darkGrayColor];
    label.text = self.prizeDetailModel.servicePhone;
    [self.backScrollView addSubview:label];
    self.bossPhoneNmbLabel = label;

    
    //竖线
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(label.x+label.width+1, label.y, 1, label.height)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.backScrollView addSubview:lineView];
    
    //电话按钮
    [self addCallPohneBtn];
    
}

#pragma mark - 添加电话按钮
-(void)addCallPohneBtn{
    
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(self.bossPhoneNmbLabel.frame.origin.x+self.bossPhoneNmbLabel.frame.size.width+13, self.bossPhoneNmbLabel.frame.origin.y, 15, 16)];
    [button setImage:[UIImage imageNamed:@"dianhua-prizeDetail"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(callSeverBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.backScrollView addSubview:button];
}

#pragma mark - 兑换地址
-(void)addBossAdress{
    
    //标题
    self.bossAdrTitle = [[detailTitleLabel alloc]initWithFrame:CGRectMake(10, self.bossPhoneNmbLabel.y+self.bossPhoneNmbLabel.height+10, 80, 20)];
    self.bossAdrTitle.text = @"商家地址:";
    [self.backScrollView addSubview:self.bossAdrTitle];
    
    
    //地址详情
    NSString * connect = [self.prizeDetailModel.address  stringByReplacingOccurrencesOfString:@" " withString:@""];
    connect = [connect  stringByReplacingOccurrencesOfString:@"	" withString:@""];
    connect = [connect stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    connect = [connect  stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    CGFloat maxHeight = [getLabelHeight heightWithConnect:connect andLabelW:self.view.width-20 font:[myFont getTitle3]];
    UILabel * label = [getLabelHeight labelWithFrame:CGRectMake(10, self.bossAdrTitle.y+self.bossAdrTitle.height, self.view.width-20, maxHeight+16) andConnect:connect font:[myFont getTitle3]];
    
    self.bossAdressLabel = label;//兑换地址变量全局化
    [self.backScrollView addSubview:label];
    
    //添加右下角的导航按钮和导航指示
    [rightDownLocationBtn addLocationBtnWithSuperView:self.backScrollView andLeftView:self.bossAdressLabel andAction:@selector(navigationBtnClick) andViewController:self];

    //重置scrollView的滚动位置
    self.backScrollView.contentSize = CGSizeMake(self.view.width,label.y+label.height-200);
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //设置导航按钮
    [self setLeftNavBtn];
    self.tabBarController.tabBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [self sendSumNumber];//试图消失的时候上传浏览量统计数据
}

#pragma mark - 浏览量统计方法
-(void)sendSumNumber{
    //1.取出
    NSData * data = [NSData dataWithContentsOfFile:dirDoc];
    
    NSArray * array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    if (!self.jpId) {
        return;
    }
    //2.操作
    NSString * type = @"1";
    if (![self.indentify isEqual:@"3"]) {
        type = @"0";
    }
    BOOL isHave = NO;
    for (NumberModel * model in array) {
        if ([model.type isEqual:type] && [self.jpId isEqual:model.prizeId]) {
            model.clickNum += 1;
            isHave = YES;
            break;
        }
    }
    NSMutableArray * muArray = [NSMutableArray arrayWithArray:array];
    if (isHave == NO) {
        NSDictionary * dic = @{@"type":@"0",@"prizeId":self.jpId,@"clickNum":@"1"};
        NumberModel * newModel = [NumberModel modelWithDict:dic];
        [muArray addObject:newModel];
    }
    //3.存
    NSData * newData = [NSKeyedArchiver archivedDataWithRootObject:muArray];
    //将数组存储到文件中
    [newData writeToFile:dirDoc atomically:YES];
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


#pragma mark - 加载数据
-(void)loadData{
    
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    
    NSString *str = kcurrentBigPrizeDataStr;
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];

    if (self.pId == nil) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"加载失败"];
        return;
    }
    if (!self.pId) {
        return;
    }
    NSDictionary * parameters = @{@"pId":self.pId};

    [manager POST:str parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([responseObject[@"code"] isEqual:@(0)]) {

            if (!responseObject[@"data"][0]) {
                return;
            }
            self.prizeDetailModel = [prizeDetailModel modelWithDict:responseObject[@"data"][0]];
            [self setDataWithPrizeModel];
        }else{
            [MBProgressHUD showError:responseObject[@"msg"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"网络加载失败!"];
    }];
}

#pragma mark - 设置界面数据
-(void)setDataWithPrizeModel{
    self.navigationItem.title = self.prizeDetailModel.mname;
    //添加控件
    [self addBigBackViewSubViews];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

#pragma mark - 商家环境按钮点击事件
- (void)bossEventBtnClick{
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    bossEnvironmentVC *vc = [sb instantiateViewControllerWithIdentifier:@"bossEnvironmentVC"];
    vc.prizeDetailModel = self.prizeDetailModel;//传数据模型
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 店长推荐按钮点击事件
- (void)bossCommentdoaryBtnClick {
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    managerCommendatoryVC * vc = [sb instantiateViewControllerWithIdentifier:@"managerCommendatoryVC"];
    vc.prizeDetailModel = self.prizeDetailModel;
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark - 联系客服按钮点击事件
- (void)callSeverBtnClick {
    
    NSString * string = self.prizeDetailModel.servicePhone;
    if (string.length >= 14) {//两个以上的电话
        NSArray * array = [[NSArray alloc]init];
#warning 如果后台把联系电话之间的空格改为别的，这个地方也得改变。
        array = [self.prizeDetailModel.servicePhone componentsSeparatedByString:@" "];
        for (NSString * str in array) {
            if (str.length>10) {
                [self.phoneArray addObject:str];
            }
        }
        self.str1 = self.phoneArray[0];
        self.str2 = self.phoneArray[1];
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"拨号" message:string delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拨号1",@"拨号2", nil];
        [alert show];
    }else{//一个电话 的时候
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
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.prizeDetailModel.servicePhone]]];//打电话
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
- (void)navigationBtnClick {
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    mapVC *vc = [sb instantiateViewControllerWithIdentifier:@"mapVC"];
    if (!self.indentify) {
        self.indentify = @"3";
    }
    vc.indentify = self.indentify;
    vc.prizeDetailModel = self.prizeDetailModel;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
