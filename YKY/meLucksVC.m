//
//  meLucksVC.m
//  YKY
//
//  Created by 肖 亮 on 16/4/25.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "meLucksVC.h"
#import "meLuckCell.h"
#import "homeNewScuessModel.h"
#import "Account.h"
#import "AccountTool.h"
#import "lookMyLuckNumVC.h"
#import "homeTableBarVC.h"
#import "meLuckPrizeState.h"
#import "sharToFrend.h"

@interface meLucksVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic , strong) UITableView * tableView;
@property (nonatomic , strong) NSMutableArray * dataArray;
@property (nonatomic ) int index;
@property (nonatomic , copy) NSString * no;

@end

@implementation meLucksVC


-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        self.dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"幸运兜";
    [self setLeft];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenheight) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    self.tableView.contentSize = CGSizeMake(kScreenWidth, kScreenheight);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"meLuckCell" bundle:nil] forCellReuseIdentifier:@"meLuckCell"];

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
    UIView * top = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    top.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:top];
    _index = 0;
    [self.dataArray removeAllObjects];
    [self loadDataWithPage:@"0"];
    self.tabBarController.tabBar.hidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lingqujiangli) name:@"meluck-jixuYG" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jisuanxiangqing) name:@"meluck-ztgz" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lookLuckCode) name:@"me-xingyundou-llcode" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shareToFriends) name:@"me-xingyundou-share" object:nil];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"meluck-jixuYG" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"meluck-ztgz" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"me-xingyundou-llcode" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"me-xingyundou-share" object:nil];
}
#pragma mark - 设置leftItem
-(void)setLeft{
    UIBarButtonItem * left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"jiantou-Left"] style:UIBarButtonItemStylePlain target:self action:@selector(leftClick)];
    left.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = left;
}
-(void)leftClick{
    if ([_identify isEqualToString:@"1"]) {
        UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        homeTableBarVC * vc = [sb instantiateViewControllerWithIdentifier:@"homeTableBarVC"];
        UIApplication * app = [UIApplication sharedApplication];
        app.keyWindow.rootViewController = vc;
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}




-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count?_dataArray.count:0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    meLuckCell * cell = [tableView dequeueReusableCellWithIdentifier:@"meLuckCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[meLuckCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"meLuckCell"];
    }
    if (indexPath.row>_dataArray.count) {
        return cell;
    }
    cell.index = indexPath.row;
    cell.model = _dataArray[indexPath.row];

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 160;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_dataArray.count == 0 || indexPath.row > _dataArray.count) {
        [MBProgressHUD showError:@"网络状况不好,请稍后再试!"];
        return;
    }
    homeNewScuessModel * model = _dataArray[indexPath.row];
    if ([model.orderStatue isEqualToString:@"3"]) {
        [MBProgressHUD showError:@"您的商品已作废,请联系客服!"];
        return;
    }
    meLuckPrizeState * stavc = [[meLuckPrizeState alloc]init];
    stavc.model = model;
    [self.navigationController pushViewController:stavc animated:YES];
}





-(void)lingqujiangli{
    NSString * index = [[NSUserDefaults standardUserDefaults]objectForKey:@"index-xingyundou-jixuYG"];
    int findex = [index intValue];
    DebugLog(@"继续摇购==%d",findex);

    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    homeTableBarVC *vc = [sb instantiateViewControllerWithIdentifier:@"homeTableBarVC"];
    UIApplication *app = [UIApplication sharedApplication];
    UIWindow *window = app.keyWindow;
    window.rootViewController = vc;
    UIViewController* myvc =  vc.childViewControllers[1];
    vc.selectedViewController = myvc;

}

-(void)jisuanxiangqing{
    NSString * index = [[NSUserDefaults standardUserDefaults]objectForKey:@"index-xingyundou-ztgz"];
    int findex = [index intValue];
    DebugLog(@"状态跟踪==%d",findex);
    if (_dataArray.count == 0 || findex > _dataArray.count) {
        [MBProgressHUD showError:@"网络状况不好,请稍后再试!"];
        return;
    }
    homeNewScuessModel * model = _dataArray[findex];
    meLuckPrizeState * stavc = [[meLuckPrizeState alloc]init];
    stavc.model = model;

    if ([model.orderStatue isEqualToString:@"3"]) {
        [MBProgressHUD showError:@"该奖品已作废,请您及时联系客服!"];
        return;
    }
    [self.navigationController pushViewController:stavc animated:YES];

}

-(void)lookLuckCode{
    NSString * index = [[NSUserDefaults standardUserDefaults]objectForKey:@"index-xingyundou-melook"];
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

-(void)shareToFriends{
    NSString * index = [[NSUserDefaults standardUserDefaults]objectForKey:@"me-xingyundou-share"];
    int findex = [index intValue];
    DebugLog(@"分享给好友==%d",findex);
    if (_dataArray.count == 0 || findex > _dataArray.count) {
        [MBProgressHUD showError:@"网络状况不好,请稍后再试!"];
        return;
    }
    homeNewScuessModel * model = _dataArray[findex];
    [sharToFrend shareWithImgurl:model.url title:@"我在*一块摇*中随便玩了一下，就中了一个奖，真的是太兴奋了，实在憋不住，要分享一下！" andPid:model.serialId andVC:self];

}



-(void)loadDataWithPage:(NSString *)page{
    NSString * bindPath = @"/yshakeCoupons/getCloudShakeWinCouons";
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    [parameters setValue:page forKey:@"pageNum"];

    [XLRequest AFPostHost:kbaseURL bindPath:bindPath postParam:parameters  isClient:YES getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        DebugLog(@"幸运兜奖品请求结果===%@",responseDic);
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
        DebugLog(@"幸运兜奖品请求失败==error=%@==oper=%@",error,operation);
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
