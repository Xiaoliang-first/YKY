//
//  YaogouVC.m
//  YKY
//
//  Created by 肖 亮 on 16/4/5.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "YaogouVC.h"
#import "yaogouCell.h"
#import "homeNewScuessModel.h"
#import "yaogouDetailVC.h"
#import "rightImgBtn.h"
#import "btnsModel.h"
#import "ygLikstRightView.h"
#import "yaogouRockVC.h"
#import "YGChooseCityVC.h"
#import "YGChooseKindVC.h"
#import "jumpSafairTool.h"
#import "Account.h"
#import "AccountTool.h"

@interface YaogouVC ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property (nonatomic , strong) UITableView * tableView;
@property (nonatomic , strong) NSMutableArray * dataArray;
@property (nonatomic) int index;
@property (nonatomic , copy) NSString * no;
@property (nonatomic , strong) rightImgBtn * kindsBtn;
@property (nonatomic , strong) rightImgBtn * citysBtn;
@property (nonatomic , strong) UIButton * backBtn;
@property (nonatomic , strong) UIView * blackView;
@property (nonatomic , strong) UIView * rightView;
@property (nonatomic , strong) NSMutableArray * rightDataArray;
@property (nonatomic , strong) UIView * kindsBackView;
@property (nonatomic , strong) UIView * citysBackView;




@end


@implementation YaogouVC

-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        self.dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}
-(NSMutableArray *)rightDataArray{
    if (_rightDataArray == nil) {
        self.rightDataArray = [[NSMutableArray alloc]init];
    }
    return _rightDataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"摇购列表";
    self.tabBarController.tabBar.items[1].title = @"摇购";
    self.view.backgroundColor = YKYColor(242, 242, 242);


    //添加相应的view
    [self addviews];

    NSString * YGAgentId = [[NSUserDefaults standardUserDefaults]objectForKey:@"YGCurrentAgentId"];
    if (!YGAgentId) {
        [self chooseCity];
        return;
    }

    [self.dataArray removeAllObjects];
    [self loadData];
    [self loadDataWithPage:@"0"];

}
-(void)loadData{
    self.index = 0;
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
        weakSelf.index = 0;
        weakSelf.no = @"0";
        [weakSelf.dataArray removeAllObjects];
        [weakSelf loadDataWithPage:@"0"];
        [weakSelf endrefreshing];
    }];
}
-(void)endrefreshing{
    [self.tableView.header endRefreshing];
    [self.tableView.footer endRefreshing];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    self.no = @"0";
//    [self loadData];

    NSString * agentId = [[NSUserDefaults standardUserDefaults]objectForKey:@"YGCurrentAgentId"];

    NSString * kindId = [[NSUserDefaults standardUserDefaults]objectForKey:@"YGCurrentKindID"];

    NSString * oldKindId = [[NSUserDefaults standardUserDefaults] objectForKey:@"YGOldKindId"];

    NSString * oldAgentId = [[NSUserDefaults standardUserDefaults] objectForKey:@"YGOldAgentId"];

    DebugLog(@"====%@=====%@====%@====%@",oldKindId,kindId,oldAgentId,agentId);
    if (![oldAgentId isEqual:agentId]) {
        [self.dataArray removeAllObjects];
        [self.tableView reloadData];
        self.index = 0;
        self.no = @"0";
        [self loadDataWithPage:@"0"];
    }else if (kindId &&  ![[NSString stringWithFormat:@"%@",oldKindId] isEqualToString:kindId]){
        [self.dataArray removeAllObjects];
        [self.tableView reloadData];
        self.index = 0;
        self.no = @"0";
        [self loadDataWithPage:@"0"];
    }

    //未选择城市情况处理
    NSString * YGAgentId = [[NSUserDefaults standardUserDefaults]objectForKey:@"YGCurrentAgentId"];
    if (!YGAgentId) {
        [MBProgressHUD showError:@"请选择摇购城市!"];
        return;
    }

    //发送广播
    [[NSNotificationCenter defaultCenter] postNotificationName:@"youAreLuckey" object:nil];
    
    self.tabBarController.tabBar.hidden = NO;
//    
//    [self.dataArray removeAllObjects];
//    [self loadDataWithPage:@"0"];

    NSString *currentKind = [[NSUserDefaults standardUserDefaults]objectForKey:@"YGCurrentKindName"];
    if (currentKind) {
        [self.kindsBtn setImage:[UIImage imageNamed:@"blackDown"] withTitle:currentKind forState:UIControlStateNormal font:[myFont getTitle2]];
    }else{
        [self.kindsBtn setImage:[UIImage imageNamed:@"blackDown"] withTitle:@"全部分类" forState:UIControlStateNormal font:[myFont getTitle2]];
    }

    NSString *currentCity = [[NSUserDefaults standardUserDefaults]objectForKey:@"YGCurrentCity"];
    if (currentCity.length>0) {
        [self.citysBtn setImage:[UIImage imageNamed:@"blackDown"] withTitle:currentCity forState:UIControlStateNormal font:[myFont getTitle2]];
    }else{
        [self.citysBtn setImage:[UIImage imageNamed:@"blackDown"] withTitle:@"城市" forState:UIControlStateNormal font:[myFont getTitle2]];
    }

    //接收去摇按钮的点击事件通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumptoRockVC) name:@"quyao" object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    //删除通知
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"quyao" object:nil];
//    //清空数据元
//    [self.dataArray removeAllObjects];
//    [self.tableView reloadData];
}


#pragma mark - 设置you导航按钮
-(void)setRightItem{
    UIBarButtonItem * right = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"pen"] style:UIBarButtonItemStylePlain target:self action:@selector(rightClick)];
    right.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = right;
}
-(void)rightClick{
    DebugLog(@"右键被点击");

    //添加views
    [self addRightViews];
    //添加选择按钮们
    [self addChooseBtns];
}
-(void)addRightViews{
    UIApplication * app =[UIApplication sharedApplication];
    self.blackView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _blackView.backgroundColor = [UIColor clearColor];
    UIWindow * window = [app keyWindow];
    [window addSubview:_blackView];
    //黑色半透明背景btn
    UIButton * btn = [[UIButton alloc]initWithFrame:[UIScreen mainScreen].bounds];
    btn.backgroundColor = [UIColor blackColor];
    btn.alpha = kalpha;
    [_blackView addSubview:btn];
    [btn addTarget:self action:@selector(dissBlackBtn:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)dissBlackBtn:(UIButton *)btn{
    [_blackView removeFromSuperview];
}
-(void)addChooseBtns{
    NSInteger btnsNum = 0;
    CGFloat w = 100.f;
    CGFloat H = 40.f;
//    UIView * whiteView = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth-w-8, 64, w,btnsNum*H)];
    NSArray * array = @[@{@"title":@"最新揭晓",@"identify":@"1"},@{@"title":@"摇兜",@"identify":@"2"}];
    [self.rightDataArray removeAllObjects];
    for (NSDictionary * dict in array) {
        btnsModel * model = [btnsModel modeWithDict:dict];
        [self.rightDataArray addObject:model];
    }
    btnsNum = _rightDataArray.count;
    [ygLikstRightView addRightViewWithArray:_rightDataArray view:_blackView frame:CGRectMake(kScreenWidth-w-8, 64, w,btnsNum*H) VC:self action:@selector(rightBtnsOneClick:)];
}
#pragma mark -
-(void)rightBtnsOneClick:(UIButton*)btn{
    int mark = (int)btn.tag - 2234;
    btnsModel * model = _rightDataArray[mark];
    if ([model.identify isEqualToString:@"1"]) {
        [self right1Click];
    }else if ([model.identify isEqualToString:@"2"]){
        [self right2Click];
    }
}
-(void)right1Click{
    DebugLog(@"第一个按钮");
}
-(void)right2Click{
    DebugLog(@"第二个按钮");
}


#pragma mark - 添加顶部固定view
-(void)addviews{
    //1.添加顶部两块儿btn
    //1.1大view
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, 40)];
    backView.backgroundColor = YKYColor(247, 237, 240);
    [self.view addSubview:backView];

    //1.3全部分类
    self.kindsBtn = [[rightImgBtn alloc]initWithFrame:CGRectMake(0, 0, 0.5*backView.width, backView.height)];
    self.kindsBtn.backgroundColor = [UIColor clearColor];
    NSString *currentKind = [[NSUserDefaults standardUserDefaults]objectForKey:@"YGCurrentKindName"];
    if (currentKind) {
        [self.kindsBtn setImage:[UIImage imageNamed:@"blackDown"] withTitle:currentKind forState:UIControlStateNormal font:[myFont getTitle2]];
    }else{
        [self.kindsBtn setImage:[UIImage imageNamed:@"blackDown"] withTitle:@"全部分类" forState:UIControlStateNormal font:[myFont getTitle2]];
    }
    [self.kindsBtn setTitleColor:YKYColor(51, 51, 51) forState:UIControlStateNormal];
    [self.kindsBtn addTarget:self action:@selector(chooseKind) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:self.kindsBtn];

    //1.4全部城市
    self.citysBtn = [[rightImgBtn alloc]initWithFrame:CGRectMake(0.5*backView.width, 0, 0.5*backView.width, backView.height)];
    self.citysBtn.backgroundColor = [UIColor clearColor];
    NSString *currentCity = [[NSUserDefaults standardUserDefaults]objectForKey:@"YGCurrentCity"];
    if (currentCity.length>0) {
        [self.citysBtn setImage:[UIImage imageNamed:@"blackDown"] withTitle:currentCity forState:UIControlStateNormal font:[myFont getTitle2]];
    }else{
        [self.citysBtn setImage:[UIImage imageNamed:@"blackDown"] withTitle:@"城市" forState:UIControlStateNormal font:[myFont getTitle2]];
    }
    [self.citysBtn setTitleColor:YKYColor(51, 51, 51) forState:UIControlStateNormal];
    [self.citysBtn addTarget:self action:@selector(chooseCity) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:self.citysBtn];

    //2.添加tableView
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, backView.y+backView.height, kScreenWidth, kScreenheight-backView.y-backView.height-50) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"yaogouCell" bundle:nil] forCellReuseIdentifier:@"yaogouCell"];
}

#pragma mark - 选择分类
-(void)chooseKind{
    DebugLog(@"选择分类");

    YGChooseKindVC * vc = [[YGChooseKindVC alloc]init];
    NSString * currentKind = [[NSUserDefaults standardUserDefaults]objectForKey:@"YGCurrentKindName"];
    if (currentKind.length>0) {
        vc.currentKind = currentKind;
    }else{
        vc.currentKind = _kindsBtn.titleLabel.text;
    }

    NSString *currentCity = [[NSUserDefaults standardUserDefaults]objectForKey:@"YGCurrentCity"];
    if (currentCity.length>0) {
        vc.currentCity = currentCity;
    }else{
        vc.currentCity = _citysBtn.titleLabel.text;
    }

    [self.navigationController pushViewController:vc animated:YES];

}
#pragma mark - 选择城市
-(void)chooseCity{
    DebugLog(@"选择城市");

    YGChooseCityVC * vc = [[YGChooseCityVC alloc]init];
    NSString * currentKind = [[NSUserDefaults standardUserDefaults]objectForKey:@"YGCurrentKindName"];
    if (currentKind.length>0) {
        vc.currentKind = currentKind;
    }else{
        vc.currentKind = _kindsBtn.titleLabel.text;
    }

    NSString *currentCity = [[NSUserDefaults standardUserDefaults]objectForKey:@"YGCurrentCity"];
    if (currentCity.length>0) {
        vc.currentCity = currentCity;
    }else{
        vc.currentCity = _citysBtn.titleLabel.text;
    }

    [self.navigationController pushViewController:vc animated:YES];    
}

#pragma mark - 去摇按钮被点击
-(void)jumptoRockVC{
    NSString * index = [[NSUserDefaults standardUserDefaults]objectForKey:@"index-yaogou"];
    int findex = [index intValue];
    DebugLog(@"去摇按钮被点击==%d",findex);

    Account * account = [AccountTool account];
    if (!account) {//没有用户登录
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示:" message:@"亲~您还未登录账号哦!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去登录", nil];
        [alert show];
        return;
    }
    jumpSafairTool * tool = [[jumpSafairTool alloc]init];
    if ([tool jumpOrNo]) {//需要跳转到safair
        NSString * agentId = [[NSUserDefaults standardUserDefaults]objectForKey:@"agentId"];
        NSString * str = [NSString stringWithFormat:@"http://api.yikuaiyao.com/ios/index.jsp?rt=%@&uid=%@&t=1&c=%@&acid=0&aid=%@",account.reponseToken,account.uiId,Kclient,agentId];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }else{//正常执行程序
        yaogouRockVC * rockVC = [[yaogouRockVC alloc]init];
        rockVC.model = _dataArray[findex];
        [self.navigationController pushViewController:rockVC animated:YES];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:

            break;
        case 1:
            [self jumpToMyAccountVC];
            break;

        default:
            break;
    }
}

#pragma mark - 数据请求
-(void)loadDataWithPage:(NSString *)page{
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];

    NSString * kindId = [[NSUserDefaults standardUserDefaults]objectForKey:@"YGCurrentKindID"];
    DebugLog(@"==kindID==%@",kindId);
    NSString * agentId = [[NSUserDefaults standardUserDefaults]objectForKey:@"YGCurrentAgentId"];
    if (!agentId) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:@"亲~您还没选择摇购城市哦!"];
        return;
    }

    [[NSUserDefaults standardUserDefaults] setObject:kindId forKey:@"YGOldKindId"];
    [[NSUserDefaults standardUserDefaults] setObject:agentId forKey:@"YGOldAgentId"];

    NSMutableDictionary * paramete = [NSMutableDictionary dictionary];
    [paramete setValue:page forKey:@"pageNum"];
    [paramete setValue:kindId forKey:@"type"];
    [paramete setValue:agentId forKey:@"agentId"];

    NSString * str = @"/yshakeUtil/getCloudList";

    [XLRequest AFPostHost:kbaseURL bindPath:str postParam:paramete isClient:NO getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        DebugLog(@"摇购列表获取结果==%@",responseDic);
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
        }else{
            self.index = 0;
            [MBProgressHUD showError:responseDic[@"msg"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) { 
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:@"网络加载失败,请稍后!"];
    }];
}


#pragma mark - tableviewDateSouce
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count?_dataArray.count:0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    yaogouCell * cell = [tableView dequeueReusableCellWithIdentifier:@"yaogouCell"];
    if (cell == nil) {
        cell = [[yaogouCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"yaogouCell"];
    }
    cell.index = (long)indexPath.row;
    if (_dataArray.count == 0) {
        return cell;
    }
    if (indexPath.row>_dataArray.count) {
        return cell;
    }
    cell.prizeModel = _dataArray[indexPath.row];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}
#pragma mark - tableView deletage
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 168;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    homeNewScuessModel * model = self.dataArray[indexPath.row];
    yaogouDetailVC * vc = [[yaogouDetailVC alloc]init];
    vc.prizeModel = model;
    [self.navigationController pushViewController:vc animated:YES];
}

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
