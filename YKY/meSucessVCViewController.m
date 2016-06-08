//
//  meSucessVCViewController.m
//  YKY
//
//  Created by 肖 亮 on 16/4/25.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "meSucessVCViewController.h"
#import "meSucessCell.h"
#import "homeNewScuessModel.h"
#import "Account.h"
#import "AccountTool.h"
#import "homeNewScuessDetailVC.h"
#import "YGPrizeDetailVC.h"
#import "lookMyLuckNumVC.h"


@interface meSucessVCViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic , strong) UITableView * tableView;
@property (nonatomic , strong) NSMutableArray * dataArray;
@property (nonatomic ) int index;
@property (nonatomic , copy) NSString * no;
@property (nonatomic , strong) UIView * alterview;
@property (nonatomic , strong) UIButton * btn;
@property (nonatomic , strong) UIButton * xiaoX;
@property (nonatomic) int modelIndex;


@end

@implementation meSucessVCViewController

-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        self.dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"已揭晓";
    [self setLeft];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenheight) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    self.tableView.contentSize = CGSizeMake(kScreenWidth, kScreenheight);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"meSucessCell" bundle:nil] forCellReuseIdentifier:@"meSucessCell"];
    
}
-(void)endrefreshing{
    [self.tableView.header endRefreshing];
    [self.tableView.footer endRefreshing];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIView * top = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    top.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:top];

    _index = 0;
    // 添加传统的上拉刷新
    __weak typeof (self) weakSelf = self;
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        weakSelf.index = weakSelf.index + 1;
        NSString *idx = [NSString stringWithFormat:@"%d",weakSelf.index];
        if ([weakSelf.no isEqualToString:@"1"]) {
            [weakSelf endrefreshing];
            return ;
        }
        [weakSelf loadDataWithPage:idx];
        [weakSelf endrefreshing];
    }];

    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf.dataArray removeAllObjects];
        weakSelf.index = 0;
        weakSelf.no = @"0";
        [weakSelf loadDataWithPage:@"0"];
        [weakSelf endrefreshing];
    }];

    self.tabBarController.tabBar.hidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lingqujiangli) name:@"meSuccess-lingqu" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jisuanxiangqing) name:@"meSuccess-jisuan" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lookLuckCode) name:@"me-jiexiao-lookMyLuckcode" object:nil];

    if (_dataArray.count == 0) {
        [self loadDataWithPage:@"0"];
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"meSuccess-lingqu" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"meSuccess-jisuan" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"me-jiexiao-lookMyLuckcode" object:nil];
    [self.dataArray removeAllObjects];
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




-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count?_dataArray.count:0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    meSucessCell * cell = [tableView dequeueReusableCellWithIdentifier:@"meSucessCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[meSucessCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"meSucessCell"];
    }

    if (indexPath.row>_dataArray.count || _dataArray.count == 0) {
        return cell;
    }


    cell.index = indexPath.row;
    cell.model = _dataArray[indexPath.row];

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 170;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    homeNewScuessDetailVC * vc = [[homeNewScuessDetailVC alloc]init];
    if (_dataArray.count == 0 || indexPath.row > _dataArray.count) {
        [MBProgressHUD showError:@"网络状况不好,请稍后再试!"];
        return;
    }
    homeNewScuessModel * model = _dataArray[indexPath.row];
    vc.prizemodel = model;
    vc.serialID = model.serialId;
    vc.pid = model.pid;
    [self.navigationController pushViewController:vc animated:YES];
}







-(void)lingqujiangli{
    NSString * index = [[NSUserDefaults standardUserDefaults]objectForKey:@"index-jiexiao-lingqu"];
    int findex = [index intValue];
    DebugLog(@"领取奖励==%d",findex);

    [self addAleterViewWithIndex:findex];
}



-(void)jisuanxiangqing{
    NSString * index = [[NSUserDefaults standardUserDefaults]objectForKey:@"index-jiexiao-jisuan"];
    int findex = [index intValue];
    DebugLog(@"计算详情==%d",findex);
    YGPrizeDetailVC * vc = [[YGPrizeDetailVC alloc]init];
    vc.vcTitle = @"计算详情";
    if (_dataArray.count == 0 || findex > _dataArray.count) {
        [MBProgressHUD showError:@"网络状况不好,请稍后再试!"];
        return;
    }
    homeNewScuessModel * model = _dataArray[findex];
    NSString * str = [kbaseURL stringByAppendingString:[NSString stringWithFormat:@"/yshakeCoupons/getCalculateInfo?perid=%@&priNum=%@",model.serialId,model.luckCode]];
    vc.requestUrl = [NSURL URLWithString:str];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)lookLuckCode{
    NSString * index = [[NSUserDefaults standardUserDefaults]objectForKey:@"index-jiexiao-melook"];
    int findex = [index intValue];
    DebugLog(@"查看我的摇码==%d",findex);
    if (_dataArray.count == 0 || findex > _dataArray.count) {
        [MBProgressHUD showError:@"网络状况不好,请稍后再试!"];
        return;
    }
    lookMyLuckNumVC * vc = [[lookMyLuckNumVC alloc]init];
    homeNewScuessModel * model = _dataArray[findex];
    vc.prizemodel = model;
    [self.navigationController pushViewController:vc animated:YES];
}



-(void)addAleterViewWithIndex:(int)index{

    if (_dataArray.count == 0 || index > (int)_dataArray.count) {
            [MBProgressHUD showError:@"网络状况不好,请稍后再试!"];
            return;
        }

    self.btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenheight)];
    self.btn.backgroundColor = [UIColor blackColor];
    self.btn.alpha = kalpha;
    [self.btn addTarget:self action:@selector(dissMiss) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btn];


    CGFloat backW = 0.7*kScreenWidth;
    CGFloat backH = 0.25*kScreenheight;
    self.alterview = [[UIView alloc]initWithFrame:CGRectMake(0.5*(kScreenWidth-backW), 0.5*(kScreenheight-backH), backW, backH)];
    self.alterview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.alterview];
    //设置图片圆角
    self.alterview.layer.cornerRadius = 5;
    self.alterview.layer.masksToBounds = YES;
    self.alterview.layer.borderWidth = 0.01;

    
    homeNewScuessModel * model = _dataArray[index];
    self.modelIndex = index;
    UITextView * textview = [[UITextView alloc]initWithFrame:CGRectMake(15, 15, self.alterview.width-30, 0.65*self.alterview.height)];
    textview.userInteractionEnabled = NO;

    NSString * string = [NSString stringWithFormat:@"&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp您在第%@期%@摇购中摇购了%@次，很遗憾您没能中奖，但是别灰心，摇哥送您",model.serials,model.pname,model.joinCount];
    NSString *red1 = [NSString stringWithFormat:@"<font size=\"5\" color=\"red\">%@</font>",model.joinCount];
    NSString * str2 = @"个银币。";
    NSString * last = [NSString stringWithFormat:@"%@%@%@",string,red1,str2];
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[last dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    textview.attributedText = attrStr;
    textview.font = [UIFont systemFontOfSize:[myFont getTitle2]];
    [self.alterview addSubview:textview];


    CGFloat ligW = 114;
    CGFloat ligH = 26;
    UIButton *lingquBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.5*(self.alterview.width-ligW), textview.y+textview.height, ligW, ligH)];
    [lingquBtn setBackgroundImage:[UIImage imageNamed:@"领取button"] forState:UIControlStateNormal];
    [lingquBtn addTarget:self action:@selector(getPrize) forControlEvents:UIControlEventTouchUpInside];
    [self.alterview addSubview:lingquBtn];

    self.xiaoX = [[UIButton alloc]initWithFrame:CGRectMake(self.alterview.x+self.alterview.width-30, self.alterview.y-35, 30, 30)];
    [self.xiaoX setBackgroundImage:[UIImage imageNamed:@"xiaochazi"] forState:UIControlStateNormal];
    [self.xiaoX addTarget:self action:@selector(dissMiss) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.xiaoX];
}

-(void)dissMiss{
    [self.xiaoX removeFromSuperview];
    [self.btn removeFromSuperview];
    [self.alterview removeFromSuperview];
}










-(void)getPrize{
    [self dissMiss];
    if (![AccountTool account]) {
        [self jumpToAccountVc];
        return;
    }
    [MBProgressHUD showMessage:@"领取中..." toView:self.view];
    homeNewScuessModel * model = _dataArray[_modelIndex];
    NSString * bindPath = @"/yshakeCoupons/getAward";
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    [parameter setValue:model.serialId forKey:@"serialId"];
    [XLRequest AFPostHost:kbaseURL bindPath:bindPath postParam:parameter isClient:YES getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        DebugLog(@"==领取奖励返回结果=%@",responseDic);
        if ([responseDic[@"code"] isEqual:@0]) {
            [[NSUserDefaults standardUserDefaults]setObject:responseDic[@"data"][0][@"glod"] forKey:@"gold"];
            [[NSUserDefaults standardUserDefaults]setObject:responseDic[@"data"][0][@"silver"] forKey:@"silverCoin"];
            [self.dataArray removeAllObjects];
            [self loadDataWithPage:@"0"];
        }else if ([responseDic[@"code"] isEqual:KotherLogin]){
            [self jumpToAccountVc];
        }else{
            [MBProgressHUD showError:responseDic[@"msg"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"领取失败,请检查您的网络!"];
    }];
}

-(void)loadDataWithPage:(NSString *)page{
    NSString * bindPath = @"/yshakeCoupons/getCloudShakedCouons";
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    [parameters setValue:page forKey:@"pageNum"];
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    [XLRequest AFPostHost:kbaseURL bindPath:bindPath postParam:parameters  isClient:YES getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        DebugLog(@"已揭晓奖品请求结果===%@",responseDic);
        if ([responseDic[@"code"] isEqual:@0]) {
            NSArray * array = [NSArray array];
            array = responseDic[@"data"];
            if (array.count == 0) {
                [MBProgressHUD showError:@"没有更多数据"];
                self.no = @"1";
                return ;
            }
            for (NSDictionary * dict in responseDic[@"data"]) {
                homeNewScuessModel * model = [homeNewScuessModel modelWithDict:dict];
                [self.dataArray addObject:model];
            }
            [self.tableView reloadData];
        }else if ([responseDic[@"code"] isEqual:KotherLogin]){
            [self jumpToAccountVc];
        }else{
            self.index = 0;
            [MBProgressHUD showError:responseDic[@"msg"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DebugLog(@"已揭晓奖品请求失败==error=%@==oper=%@",error,operation);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"网络加载失败,请重试!"];
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



@end
