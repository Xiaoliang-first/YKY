//
//  myChargedVC.m
//  YKY
//
//  Created by 肖亮 on 15/9/14.
//  Copyright (c) 2015年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "myChargedVC.h"
#import "AFNetworking.h"
#import "common.h"
#import "chargeOrNoCell.h"
#import "Account.h"
#import "AccountTool.h"
#import "MJRefresh.h"
#import "rechargeModel.h"
#import "MBProgressHUD+MJ.h"



@interface myChargedVC ()<UITableViewDataSource,UITableViewDelegate>


/** 充值成功按钮 */
@property (weak, nonatomic) IBOutlet UIButton *chargedBtn;
/** 未充值成功按钮 */
@property (weak, nonatomic) IBOutlet UIButton *noSeccessChargedBtn;
/** 列表tableView */
@property (weak, nonatomic) IBOutlet UITableView *tableView;


/** 数据源方法 */
@property (nonatomic , strong) NSMutableArray * dataArray;
@property (nonatomic , copy) NSString * no;
/** 充值状态  1：充值成功  0：充值失败 */
@property (nonatomic , copy) NSString * type;
@property (nonatomic) int index;


@end

@implementation myChargedVC


-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        self.dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"充值记录";
    self.tabBarController.tabBar.hidden = YES;
   
    Account * account = [AccountTool account];
    if (!account) {
        [self jumpToMyaccountVC];
        return;
    }
    [self setLeftNavBtn];
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"chargeOrNoCell" bundle:nil] forCellReuseIdentifier:@"chargeOrNoCell"];

    [self chargedBtnClick:self.chargedBtn];

    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    self.index = 0;
    // 添加传统的上拉刷新
    __weak typeof (self) weakSelf = self;
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        self.index = _index + 1;
        NSString *idx = [NSString stringWithFormat:@"%d",_index];
        if ([weakSelf.no isEqualToString:@"1"]) {
//            weakSelf.tableView.footer.hidden = YES;
//            [weakSelf.tableView removeFooter];
            [MBProgressHUD showError:@"没有更多数据!"];
            [weakSelf endrefreshing];
            return ;
        }
        [weakSelf loadDataWithType:self.type andPage:idx];
        [weakSelf endrefreshing];
    }];
}


- (void)endrefreshing{
    [self.tableView.header endRefreshing];
    [self.tableView.footer endRefreshing];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setLeftNavBtn];
    self.tabBarController.tabBar.hidden = YES;
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

#pragma mark - 数据源方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count?_dataArray.count:0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    chargeOrNoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chargeOrNoCell"];
    if (cell == nil) {
        cell = [[chargeOrNoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"chargeOrNoCell"];
        return cell;
    }
    if (_dataArray.count == 0) {
        return cell;
    }
    cell.model = self.dataArray[indexPath.row];
    return cell;
}



#pragma mark - 代理方法
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

#pragma mark - 已成功充值按钮点击事件
- (IBAction)chargedBtnClick:(id)sender {
    
    [self.chargedBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.chargedBtn setBackgroundImage:[UIImage imageNamed:@"twoBtns-left"] forState:UIControlStateNormal];
    [self.noSeccessChargedBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.noSeccessChargedBtn setBackgroundImage:nil forState:UIControlStateNormal];
    [self.dataArray removeAllObjects];
    [self.tableView reloadData];
    self.type = @"1";
    self.no = @"0";
    [self loadDataWithType:self.type andPage:@"0"];
}


#pragma mark - 未充值成功按钮点击事件
- (IBAction)noChargedBtnClick:(id)sender {
    
    [self.noSeccessChargedBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.noSeccessChargedBtn setBackgroundImage:[UIImage imageNamed:@"twoBtns-right"] forState:UIControlStateNormal];
    [self.chargedBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.chargedBtn setBackgroundImage:nil forState:UIControlStateNormal];
    [self.dataArray removeAllObjects];
    [self.tableView reloadData];
    self.type = @"0";
    self.no = @"0";
    [self loadDataWithType:self.type andPage:@"0"];
}

#pragma mark - 加载列表数据
-(void)loadDataWithType:(NSString *)type andPage:(NSString *)page{

    NSString * str = kmyChargeStr;
    Account * account = [AccountTool account];
    
    NSDictionary *parameter = @{@"userId":account.uiId,@"client":Kclient,@"serverToken":account.reponseToken,@"isSuccess":type,@"pageNum":page};

    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    [manager POST:str parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        if ([responseObject[@"code"] isEqual:@(0)]) {
            NSArray * array = [NSArray arrayWithArray:responseObject[@"data"]];
            if (array.count == 0) {
                self.no = @"1";
                self.index = 0;
                [MBProgressHUD showError:@"没有更多数据!"];
                return ;
            }
            for (NSDictionary * dict in responseObject[@"data"]) {
                rechargeModel * model = [rechargeModel rechargeWithDict:dict];
                [self.dataArray addObject:model];
            }
            [self.tableView reloadData];
        }else if([responseObject[@"code"] isEqual:KotherLogin]){
            [MBProgressHUD showError:@"账号已过有效期,请您重新登录"];
            [NSTimer scheduledTimerWithTimeInterval:1.2 target:self selector:@selector(jumpToMyaccountVC) userInfo:nil repeats:NO];
            self.index = 0;
        }else{
            self.index = 0;
            [MBProgressHUD showError:responseObject[@"msg"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.index = 0;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"网络加载失败!"];
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
