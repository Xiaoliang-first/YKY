//
//  SaomiaojieguoVC.m
//  YKY
//
//  Created by 肖 亮 on 16/5/30.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "SaomiaojieguoVC.h"
#import "boundCells.h"
#import "unUsedPrizeModel.h"
#import "SaomiaoDetailVC.h"
#import "Account.h"
#import "AccountTool.h"

@interface SaomiaojieguoVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic , strong) UITableView * tableView;
@property (nonatomic) int index;
@property (nonatomic , copy) NSString * no;
@property (nonatomic , strong) NSMutableArray * dataArray;

@property (nonatomic , copy) NSString * mName;


@end

@implementation SaomiaojieguoVC

-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        self.dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"奖品列表";
    [self setLeft];

    [self addTableView];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];

    //接收使用按钮的点击事件通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumptoUsePrize) name:@"useBtnClick" object:nil];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"useBtnClick" object:nil];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"useBtnClick" object:nil];
}

-(void)addTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenheight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.tableView registerNib:[UINib nibWithNibName:@"boundCells" bundle:nil] forCellReuseIdentifier:@"boundCells"];
}


#pragma mark - 设置leftItem
-(void)setLeft{
    UIBarButtonItem * left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"jiantou-Left"] style:UIBarButtonItemStylePlain target:self action:@selector(leftClick)];
    left.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = left;
}
-(void)leftClick{
    [self.navigationController popToRootViewControllerAnimated:YES];
}



#pragma mark - tableVIewDataSouce
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count?_dataArray.count:0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    boundCells * cell = [tableView dequeueReusableCellWithIdentifier:@"boundCells" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[boundCells alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"boundCells"];
    }

    if (self.dataArray.count<indexPath.row || self.dataArray.count == 0) {
        return cell;
    }

    cell.ID = self.mName;
    cell.index = (int)indexPath.row;
    cell.model = self.dataArray[indexPath.row];

    return cell;
}



#pragma mark - 使用按钮点击事件
-(void)jumptoUsePrize{
    
//    NSString * index = [[NSUserDefaults standardUserDefaults]objectForKey:@"index"];
//    int findex = [index intValue];
//    if (findex > (int)_dataArray.count || (int)_dataArray.count == 0) {
//        [MBProgressHUD showError:@"网络链接失败,请检查网络!"];
//        return;
//    }

    NSString * index = [[NSUserDefaults standardUserDefaults]objectForKey:@"index"];
    int inx = [index intValue];
    unUsedPrizeModel *model = self.dataArray[inx];
    DebugLog(@"===%@===%d",index,inx);
    SaomiaoDetailVC * vc = [[SaomiaoDetailVC alloc]init];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 代理方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SaomiaoDetailVC * vc = [[SaomiaoDetailVC alloc]init];
    vc.model = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}


#pragma mark - 加载数据
-(void)loadData{
    [self.dataArray removeAllObjects];
    _index = 0;
    __weak typeof (self) weakSelf = self;
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        weakSelf.index = self.index + 1;
        NSString *idx = [NSString stringWithFormat:@"%d",weakSelf.index];
        if ([weakSelf.no isEqualToString:@"1"]) {
            weakSelf.index = 0;
            idx = [NSString stringWithFormat:@"%d",self.index];
            weakSelf.tableView.footer.stateHidden = YES;
            [weakSelf endrefreshing];
            return ;
        }
        [weakSelf loadUsedDataWithPage:idx];
        [weakSelf endrefreshing];
    }];
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        weakSelf.index = 0;
        weakSelf.no = @"0";
        [weakSelf.dataArray removeAllObjects];
        [weakSelf.tableView reloadData];
        [weakSelf loadUsedDataWithPage:@"0"];
        [weakSelf endrefreshing];
    }];
    [self loadUsedDataWithPage:@"0"];
}
- (void)endrefreshing{
    [self.tableView.header endRefreshing];
    [self.tableView.footer endRefreshing];
}

-(void)loadUsedDataWithPage:(NSString*)page{

    Account * account = [AccountTool account];
    if (!account) {
        [MBProgressHUD showError:@"您还未登录账号,请登录!"];
        [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(jumpToMyaccountVC) userInfo:nil repeats:NO];
        return;
    }

    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    NSString * stringValue = [[NSUserDefaults standardUserDefaults]objectForKey:@"bossIDAndPhone"];
    NSString * mid = [stringValue componentsSeparatedByString:@"@"][0];
    

    NSString * bindPath = kuserSaomiaoStr;
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    [parameter setObject:mid forKey:@"mId"];
    [parameter setObject:page forKey:@"pageNum"];

    [XLRequest AFPostHost:kbaseURL bindPath:bindPath postParam:parameter isClient:YES getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        DebugLog(@"扫描结果请求网络返回数据=%@",responseDic);
        if ([responseDic[@"code"] isEqual:@0]) {
            NSArray * array = [NSArray arrayWithArray:responseDic[@"data"]];
            if (array.count == 0) {
                self.no = @"1";
                self.index = 0;
                [MBProgressHUD showError:@"没有更多数据!"];
                [self.tableView reloadData];
                return ;
            }
            for (NSDictionary * dic in array) {
                unUsedPrizeModel * model = [unUsedPrizeModel prizeWithDict:dic];
                [self.dataArray addObject:model];
            }
            self.title = responseDic[@"msg"];
            self.mName = responseDic[@"msg"];
            [self.tableView reloadData];
        }else if([responseDic[@"code"] isEqual:KotherLogin]){
            [MBProgressHUD showError:@"账号信息有误,请重新登录!"];
            self.index = 0;
            [self jumpToMyaccountVC];
        }else{
            [MBProgressHUD showError:@"加载失败!"];
            self.index = 0;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.index = 0;
        [MBProgressHUD showError:@"网络加载失败,请稍后再试!"];
    }];
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
