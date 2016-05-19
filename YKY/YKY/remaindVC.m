//
//  remaindVC.m
//  YKY
//
//  Created by 肖亮 on 15/7/30.
//  Copyright (c) 2015年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "remaindVC.h"
#import "boundCells.h"
#import "MBProgressHUD+MJ.h"
#import "AFNetworking.h"
#import "Account.h"
#import "AccountTool.h"
#import "common.h"
#import "myAccountVC.h"
#import "unUsedPrizeModel.h"
#import "newBounsDetailVC.h"
#import "MJRefresh.h"
#import "homeTableBarVC.h"
#import "usedPrizeVC.h"


@interface remaindVC ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic , strong)NSMutableArray * dataArray;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *bossPrizeBtn;
@property (weak, nonatomic) IBOutlet UIButton *activityPrizeBtn;
@property (nonatomic , strong) NSMutableArray * weakDataArray;
@property (nonatomic) int index;

@property (nonatomic) int currentType;

@end

@implementation remaindVC

-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        self.dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}
-(NSMutableArray *)weakDataArray{
    if (_weakDataArray == nil) {
        self.weakDataArray = [[NSMutableArray alloc]init];
    }
    return _weakDataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"即将过期奖品";
    
    //设置返回按钮
    [self setLeftNavBtn];
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"boundCells" bundle:nil] forCellReuseIdentifier:@"boundCells"];
    
    [self.dataArray removeAllObjects];//清空数据源数组
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    [self refasing];//上啦刷新
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - 商家奖品按钮点击事件
- (IBAction)bossPrizeBtnClick:(id)sender {
    //改变按钮状体
    [self.bossPrizeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.bossPrizeBtn setBackgroundImage:[UIImage imageNamed:@"twoBtns-left"] forState:UIControlStateNormal];
    [self.activityPrizeBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.activityPrizeBtn setBackgroundImage:nil forState:UIControlStateNormal];
    [self.dataArray removeAllObjects];
    [self loadUnusedDataWithPage:0 couponsType:0];
    self.currentType = 0;
}

#pragma mark - 活动专区奖品按钮点击事件
- (IBAction)activityBtnClick:(id)sender {
    //改变按钮状态
    [self.bossPrizeBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.bossPrizeBtn setBackgroundImage:nil forState:UIControlStateNormal];
    [self.activityPrizeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.activityPrizeBtn setBackgroundImage:[UIImage imageNamed:@"twoBtns-right"] forState:UIControlStateNormal];
    [self.dataArray removeAllObjects];
    [self loadUnusedDataWithPage:0 couponsType:1];
    self.currentType = 1;
}

#pragma mark - 下拉刷新和上拉刷新
-(void)refasing{
    _index = 0;
    //    // 添加传统的上拉刷新
    __weak typeof (self) weakSelf = self;
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        _index = _index + 1;
        NSString *idx = [NSString stringWithFormat:@"%d",_index];
        if ( weakSelf.isHaveData == NO) {
            [MBProgressHUD showError:@"没有更多数据"];
            [weakSelf.tableView.footer endRefreshing];
            return;
        }
        [weakSelf loadUnusedDataWithPage:[idx intValue] couponsType:self.currentType];
        [weakSelf.tableView.footer endRefreshing];
    }];
}

#pragma mark - 设置导航栏左侧的返回按钮（返回到主界面）
-(void)setLeftNavBtn{

    UIBarButtonItem * left = [[UIBarButtonItem alloc]initWithTitle:@"<首页" style:UIBarButtonItemStylePlain target:self action:@selector(goFirst)];
    left.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = left;
    
}
-(void)goFirst{//返回首页
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    homeTableBarVC *vc = [sb instantiateViewControllerWithIdentifier:@"homeTableBarVC"];
    UIApplication *app = [UIApplication sharedApplication];
    UIWindow *window = app.keyWindow;
    window.rootViewController = vc;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setLeftNavBtn];
    self.tabBarController.tabBar.hidden = YES;
    [self bossPrizeBtnClick:nil];
    //接收使用按钮的点击事件通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumptoUsePrize) name:@"useBtnClick" object:nil];
}


#pragma mark - 点击使用按钮
-(void)jumptoUsePrize{

    NSString * index = [[NSUserDefaults standardUserDefaults]objectForKey:@"index"];
    int findex = [index intValue];
    
    if (findex > (int)_dataArray.count || (int)_dataArray.count == 0) {
        [MBProgressHUD showError:@"网络链接失败,请检查网络!"];
        return;
    }
    //拿到控制器
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    usedPrizeVC * vc = [sb instantiateViewControllerWithIdentifier:@"usedPrizeVC"];
    //拿到模型
    unUsedPrizeModel * model = self.weakDataArray[findex];
    vc.identafy = @"1";
    vc.prizeModel = model;

    //删除通知
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"useBtnClick" object:nil];

    [self.navigationController pushViewController:vc animated:YES];
}


- (void)loadUnusedDataWithPage:(int) page couponsType:(int)couponsType{

    Account *account = [AccountTool account];
    
    if (!account.uiId) {//用户ID判空
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"用户信息错误，请重新登录"];
        [self jumpToMyaccountVC];
        return;
    }
    if (self.dataArray.count == 0) {
        page = 0;
    }
    
    NSString * str = kgetRemaindListStr;
    if (@(page) == nil) {//page对象判空
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"加载错误"];
        return;
    }

    NSDictionary * parameters = @{@"pageNum":@(page),@"serverToken":account.reponseToken,@"userId":account.uiId,@"client":Kclient,@"couponsType":@(couponsType)};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:str parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if ([responseObject[@"code"] isEqual:KotherLogin]) {
            self.isHaveData = NO;
            _index=0;
            [MBProgressHUD showError:@"您的账号在其他设备登录，请您重新登录"];
            [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(jumpToMyaccountVC) userInfo:nil repeats:NO];
        }else if ([responseObject[@"code"] isEqual:@(0)]){
            self.isHaveData = YES;
            NSArray * array = [[NSArray alloc]init];
            array = responseObject[@"data"];
            if (array.count == 0) {
                [MBProgressHUD showError:@"没有数据"];
                [self.tableView reloadData];
                _index=0;
                return;
            }
            for (NSDictionary *dict in responseObject[@"data"]) {
                unUsedPrizeModel *model = [unUsedPrizeModel  prizeWithDict:dict];
                [self.dataArray addObject:model];
            }
        }else{
            self.isHaveData = NO;
            _index=0;
            [self.tableView.footer endRefreshing];
            [MBProgressHUD showError:responseObject[@"msg"]];
            if ([responseObject[@"msg"] isEqualToString:@"没有数据"]) {
                [self.tableView.footer endRefreshing];
                [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"isNoData"];
                return ;
            }
            [NSTimer scheduledTimerWithTimeInterval:1.2 target:self selector:@selector(back) userInfo:nil repeats:YES];
            return ;
        }
        [self.tableView reloadData];
        [self.tableView.footer endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"请检查当前网络"];
        [self.tableView.footer endRefreshing];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

//单点登录
-(void)jumpToMyaccountVC{
    Account * account2 = [AccountTool account];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (account2) {
        //实现当前用户注销（就是把 account.data文件清空）
        account2 = nil;
        [AccountTool saveAccount:account2];
        //当前用户注销之后跳转到登陆界面
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        myAccountVC * myAccountVC = [sb instantiateViewControllerWithIdentifier:@"myAccountVC"];
        [self.navigationController pushViewController:myAccountVC animated:YES];
    }else{
        //当前用户注销之后跳转到登陆界面
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        myAccountVC * myAccountVC = [sb instantiateViewControllerWithIdentifier:@"myAccountVC"];
        [self.navigationController pushViewController:myAccountVC animated:YES];
    }
}

#pragma mark - 自动回跳
-(void)back{
    if (self.isHaveData) {
        //有数据时不做返回处理
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count?self.dataArray.count:0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *ID = @"boundCells";
    boundCells *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[boundCells alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        return cell;
    }
    if (self.dataArray.count == 0) {
        return cell;
    }
    cell.index = indexPath.row;
    cell.model = self.dataArray[indexPath.row];
    self.weakDataArray = _dataArray;
    return cell;
}

#pragma mark - 代理方法
//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}


#pragma mark - 选中行的跳转
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    newBounsDetailVC * bonusDetailVC = [sb instantiateViewControllerWithIdentifier:@"newBounsDetailVC"];

    if (self.dataArray.count == 0) {
        return;
    }
    
    unUsedPrizeModel * model = self.dataArray[indexPath.row];
    bonusDetailVC.couponsId = model.cid;
    bonusDetailVC.Type = model.type;
    [self.navigationController pushViewController:bonusDetailVC animated:YES];
}





@end
