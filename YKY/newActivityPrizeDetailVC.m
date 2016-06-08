//
//  newActivityPrizeDetailVC.m
//  YKY
//
//  Created by 肖亮 on 15/9/17.
//  Copyright (c) 2015年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "newActivityPrizeDetailVC.h"
#import "common.h"
#import "mapVC.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "prizeDetailModel.h"
#import "UIImageView+WebCache.h"
#import "NumberModel.h"
#import "UIView+XL.h"
#import "detailTitleLabel.h"
#import "rightDownLocationBtn.h"
#import "getLabelHeight.h"


#define dirDoc [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"ClickNumFile.data"]


@interface newActivityPrizeDetailVC ()

/** 数据模型 */
@property (nonatomic , strong) prizeDetailModel * prizeDetailModel;

@property (nonatomic , strong) NSMutableArray * phoneArray;

@property (nonatomic , copy) NSString * str1;

@property (nonatomic , copy) NSString * str2;

@end

@implementation newActivityPrizeDetailVC

-(NSMutableArray *)phoneArray{
    if (_phoneArray == nil) {
        self.phoneArray = [[NSMutableArray alloc]init];
    }
    return _phoneArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.activName.length == 0) {
        self.navigationItem.title = @"列表详情";
    }else{
        self.navigationItem.title = self.activName;
    }
    
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
    self.backScrollView.backgroundColor = [UIColor whiteColor];

    //设置导航按钮
    [self setLeftNavBtn];
    
    //加载数据
    [self loadData];
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setLeftNavBtn];
    self.tabBarController.tabBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
#pragma mark 浏览量统计的具体实现方法
    //1.取出
    NSData * data = [NSData dataWithContentsOfFile:dirDoc];
    
    NSArray * array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    //2.操作
    NSString * type = @"0";
    if (!self.prizeDetailModel.pid) {
        return;
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
        NSDictionary * dic = @{@"type":@"1",@"prizeId":self.jpId,@"clickNum":@"1"};
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
    
    NSString *str = kactivityDetailDataStr;
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    if (self.prizeId == nil) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"加载失败"];
        return;
    }
    
    NSDictionary * parameters = @{@"pId":self.prizeId};
    
    [manager POST:str parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DebugLog(@"活动奖品详情=%@",responseObject);
        if ([responseObject[@"code"] isEqual:@(0)]) {
            for (NSDictionary * dict in responseObject[@"data"]) {
                self.prizeDetailModel = [prizeDetailModel modelWithDict:dict];
                self.title = self.prizeDetailModel.mname;
            }
            [self setDataWithPrizeModel];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"网络加载失败"];
    }];
}

#pragma mark - 设置界面数据
-(void)setDataWithPrizeModel{
    [self addBigBackViewSubViews];
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
    UIView * TopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height*0.36)];
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
    CGFloat priceLbW = 70;
    UILabel * prizeNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, IMGVH, TopView.width-priceLbW, TopView.height-IMGVH)];
    prizeNameLabel.text = self.prizeDetailModel.pname;
    prizeNameLabel.font = [UIFont systemFontOfSize:14];
    [TopView addSubview:prizeNameLabel];
    //价格label
    UILabel * priceLB = [[UILabel alloc]initWithFrame:CGRectMake(TopView.width-priceLbW, IMGVH, priceLbW, TopView.height-IMGVH)];
    priceLB.font = [UIFont systemFontOfSize:14];
    NSString * RMB = @"￥";
    NSString * price = [RMB stringByAppendingFormat:@"%d",[self.prizeDetailModel.marketPrice intValue]];
    DebugLog(@"price=%@-------%@",self.prizeDetailModel.marketPrice,price);
    priceLB.text = price;
    [TopView addSubview:priceLB];

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
    self.bossDeTitle = [[detailTitleLabel alloc]initWithFrame:CGRectMake(10, self.prizeDetailLabel.y+self.prizeDetailLabel.height+8, 80, 20)];
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
    self.bossPhTitle = [[detailTitleLabel alloc]initWithFrame:CGRectMake(10, self.bossDescLabel.y+self.bossDescLabel.height+8, 80, 20)];
    self.bossPhTitle.text = @"联系电话:";
    [self.backScrollView addSubview:self.bossPhTitle];


    //电话号码
    CGFloat with = [getLabelHeight wigthWithConnect:self.prizeDetailModel.servicePhone andHeight:16 font:14];
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, self.bossPhTitle.y+self.bossPhTitle.height+5, with, 16)];
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
    
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(self.bossPhoneNmbLabel.frame.origin.x+self.bossPhoneNmbLabel.frame.size.width+8, self.bossPhoneNmbLabel.frame.origin.y, 15, 16)];
    [button setImage:[UIImage imageNamed:@"dianhua-prizeDetail"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(callBossBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.backScrollView addSubview:button];
    
}

#pragma mark - 兑换地址
-(void)addBossAdress{
    
    //标题
    self.bossAdrTitle = [[detailTitleLabel alloc]initWithFrame:CGRectMake(10, self.bossPhoneNmbLabel.y+self.bossPhoneNmbLabel.height+15, 80, 20)];
    self.bossAdrTitle.text = @"兑换地址:";
    [self.backScrollView addSubview:self.bossAdrTitle];

    //地址详情
    NSString * connect = [self.prizeDetailModel.address  stringByReplacingOccurrencesOfString:@" " withString:@""];
    connect = [connect  stringByReplacingOccurrencesOfString:@"	" withString:@""];
    connect = [connect stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    connect = [connect  stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    CGFloat maxHeight = [getLabelHeight heightWithConnect:connect andLabelW:self.view.width-20 font:[myFont getTitle3]];
    UILabel * label = [getLabelHeight labelWithFrame:CGRectMake(10, self.bossAdrTitle.y+self.bossAdrTitle.height, self.view.width-20, maxHeight+16) andConnect:connect font:[myFont getTitle3]];
    
    self.bossAdressLabel = label;
    [self.backScrollView addSubview:label];
    
    //添加右下角导航按钮
    [rightDownLocationBtn addLocationBtnWithSuperView:self.backScrollView andLeftView:self.bossAdressLabel andAction:@selector(locationBtnClick) andViewController:self];

    self.backScrollView.contentSize = CGSizeMake(self.view.width,label.y+label.height-250);
}



#pragma mark - 联系商家
- (IBAction)callBossBtnClick{
    
    NSString * string = self.prizeDetailModel.servicePhone;
    
    if (string.length >= 14) {
        NSArray * array = [[NSArray alloc]init];
        
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
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.prizeDetailModel.servicePhone]]];//打电话
            }
            break;
            
        case 2:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.str2]]];//打电话
            
        default:
            break;
    }
}

#pragma mark - 导航按钮点击事件
- (void)locationBtnClick {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    mapVC *vc = [sb instantiateViewControllerWithIdentifier:@"mapVC"];
    vc.indentify = @"2";
    vc.prizeDetailModel = self.prizeDetailModel;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
