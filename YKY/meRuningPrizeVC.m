//
//  meRuningPrizeVC.m
//  YKY
//
//  Created by 肖 亮 on 16/4/19.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "meRuningPrizeVC.h"
#import "meRuningPrizeCell.h"
#import "homeNewScuessModel.h"
#import "Account.h"
#import "AccountTool.h"
#import "lookMyLuckNumVC.h"
#import "yaogouRockVC.h"
#import "yaogouDetailVC.h"
#import "jumpSafairTool.h"
#import "jiaVC.h"

@interface meRuningPrizeVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic , strong) UITableView * tableView;
@property (nonatomic , strong) NSMutableArray * dataArray;

@property (nonatomic) int index;
@property (nonatomic , copy) NSString * no;

@end

@implementation meRuningPrizeVC

-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        self.dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"进行中";
    [self setLeft];
    [self addView];


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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lookMyLuckCode) name:@"melookMyLuckcode" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rockAgain) name:@"meYGRockAgain" object:nil];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"melookMyLuckcode" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"meYGRockAgain" object:nil];
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

#pragma mark - 添加控件
-(void)addView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenheight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"meRuningPrizeCell" bundle:nil] forCellReuseIdentifier:@"meRuningPrizeCell"];
}

#pragma mark - 查看我的摇码
-(void)lookMyLuckCode{
    NSString * index = [[NSUserDefaults standardUserDefaults]objectForKey:@"index-yaogou-melook"];
    int findex = [index intValue];
    DebugLog(@"查看我的摇码==%d",findex);
    lookMyLuckNumVC * vc = [[lookMyLuckNumVC alloc]init];
    if (_dataArray.count == 0 || findex > (int)_dataArray.count) {
        [MBProgressHUD showError:@"网络状况不好,请稍后再试!"];
        return;
    }
    vc.prizemodel = _dataArray[findex];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 再次去摇
-(void)rockAgain{
    NSString * index = [[NSUserDefaults standardUserDefaults]objectForKey:@"index-yaogou-merock"];
    int findex = [index intValue];
    DebugLog(@"再次去摇==%d",findex);

    Account * account = [AccountTool account];
    if (!account) {//没有用户登录
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示:" message:@"亲~您还未登录账号哦!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去登录", nil];
        [alert show];
        return;
    }
    jumpSafairTool * tool = [[jumpSafairTool alloc]init];
    if ([tool jumpOrNo]) {//需要跳转到safair
        
        NSString * agentId = [[NSUserDefaults standardUserDefaults]objectForKey:@"YGCurrentAgentId"];
        if (!agentId) {
            agentId = @"10";
        }
        NSString * ip = [[NSUserDefaults standardUserDefaults] objectForKey:@"userIP"];
        if (_dataArray.count == 0 || findex > (int)_dataArray.count) {
            [MBProgressHUD showError:@"网络状况不好,请稍后再试!"];
            return;
        }
        homeNewScuessModel * model = _dataArray[findex];
        NSString * seriaiId = model.serialId;
        NSString * str = [NSString stringWithFormat:@"%@/iosyg/index.jsp?c=%@&t=%@&u=%@&a=%@&s=%@&ip=%@",kbaseURL,Kclient,account.reponseToken,account.uiId,agentId,seriaiId,ip];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
//        NSString * agentId = [[NSUserDefaults standardUserDefaults]objectForKey:@"agentId"];
//        NSString * str = [NSString stringWithFormat:@"http://api.yikuaiyao.com/ios/index.jsp?rt=%@&uid=%@&t=1&c=%@&acid=0&aid=%@",account.reponseToken,account.uiId,Kclient,agentId];
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];

//        jiaVC * vc = [[jiaVC alloc]initWithNibName:@"jiaVC" bundle:nil];
//        [self.navigationController pushViewController:vc animated:YES];

    }else{//正常执行程序
        yaogouRockVC * vc = [[yaogouRockVC alloc]init];
        if (_dataArray.count == 0 || findex > (int)_dataArray.count) {
            [MBProgressHUD showError:@"网络状况不好,请稍后再试!"];
            return;
        }
        vc.model = _dataArray[findex];
        vc.isRocking = @"0";
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:

            break;
        case 1:
            [self jumpToAccountVc];
            break;

        default:
            break;
    }
}




-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count?_dataArray.count:0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    meRuningPrizeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"meRuningPrizeCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[meRuningPrizeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"meRuningPrizeCell"];
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
    yaogouDetailVC * vc = [[yaogouDetailVC alloc]init];
    vc.prizeModel = _dataArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}





-(void)loadDataWithPage:(NSString*)page{
    Account * account = [AccountTool account];
    if (!account) {
        [self jumpToAccountVc];
        return;
    }

    NSString * bindPath = @"/yshakeCoupons/getCloudShakeingCouons";

    NSMutableDictionary * paramter = [NSMutableDictionary dictionary];
    [paramter setValue:page forKey:@"pageNum"];

   [XLRequest AFPostHost:kbaseURL bindPath:bindPath postParam:paramter isClient:YES getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
       DebugLog(@"进行中奖品请求结果==%@",responseDic);
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
