//
//  searchPrizesVC.m
//  YKY
//
//  Created by 肖 亮 on 16/1/13.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "searchPrizesVC.h"
#import "common.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "unUsedPrizeModel.h"
#import "boundCells.h"
#import "UIView+XL.h"
#import "Account.h"
#import "AccountTool.h"
#import "MJRefresh.h"
#import "newBounsDetailVC.h"
#import "usedPrizeVC.h"


@interface searchPrizesVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>


/** tableView */
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 数据源 */
@property (nonatomic , strong) NSMutableArray * dataArray;
/** 搜索框 */
@property (weak, nonatomic) IBOutlet UITextField *textfield;


/** 没有更多数据的标识 */
@property (nonatomic , strong) NSString * no;

/** 黑色半透明按钮 */
@property (nonatomic , strong) UIButton * backBtn;

/** 跳转选中行的下标 */
@property (nonatomic) int index;

@end

@implementation searchPrizesVC

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        self.dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}


- (IBAction)searchBtnClick:(id)sender {
    if (self.textfield.text.length>0) {
        [self.dataArray removeAllObjects];
        [self.tableView reloadData];
        [self seachPrizeWithPage:@"0"];
    }else{
        [MBProgressHUD showError:@"请输入搜索内容!"];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    if ([_type isEqualToString:@"1"]) {
        self.title = @"活动摇搜索";
    }else{
        self.title = @"随意摇搜索";
    }

    //设置返回按钮
    [self setLeft];

    //设置搜索框
//    [self setTitleView];

    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"boundCells" bundle:nil] forCellReuseIdentifier:@"boundCells"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;



    // 添加传统的上拉刷新
    __block int index = 0;
    __weak typeof (self) weakSelf = self;
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        index = index + 1;
        NSString *idx = [NSString stringWithFormat:@"%d",index];
        if ([weakSelf.no isEqualToString:@"1"]) {
            weakSelf.tableView.footer.hidden = YES;
            index = 0;
            [weakSelf endrefreshing];
            return ;
        }
        [weakSelf seachPrizeWithPage:idx];
        [weakSelf endrefreshing];
    }];
}

- (void)endrefreshing{
    [self.tableView.header endRefreshing];
    [self.tableView.footer endRefreshing];
}

#pragma mark - 设置返回按钮
-(void)setLeft{
    UIBarButtonItem * left = [[UIBarButtonItem alloc]initWithTitle:@"<返回" style:UIBarButtonItemStylePlain target:self action:@selector(leftClick)];
    left.tintColor = [UIColor whiteColor];
    [left setImage:[UIImage imageNamed:@"jiantou-Left"]];
    self.navigationItem.leftBarButtonItem = left;

}
-(void)leftClick{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    self.tabBarController.tabBar.hidden = YES;

    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"prizeSearch1"];

    NSString * duihuan = [[NSUserDefaults standardUserDefaults]objectForKey:@"duihuanSeccess"];
    DebugLog(@"=======%@",duihuan);
    if ([duihuan isEqualToString:@"1"]) {
        DebugLog(@"===count=%lu====index=%ld",(unsigned long)self.dataArray.count,(long)self.index);
        if ((self.dataArray.count>self.index || (int)self.dataArray.count == self.index)&&_dataArray.count!=0) {
            [self.dataArray removeObjectAtIndex:self.index];
            DebugLog(@"===count=%lu====index=%ld",(unsigned long)self.dataArray.count,(long)self.index);
            [self.tableView reloadData];
        }
    }
    //接收使用按钮的点击事件通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumptoUsePrize) name:@"useBtnClick" object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"nowPrizeType"];

    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"prizeSearch1"];

    [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"duihuanSeccess"];

}


#pragma mark - 点击使用按钮
-(void)jumptoUsePrize{

    NSString * index = [[NSUserDefaults standardUserDefaults]objectForKey:@"index"];
    int findex = [index intValue];

    //拿到控制器
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    usedPrizeVC * vc = [sb instantiateViewControllerWithIdentifier:@"usedPrizeVC"];

    //拿到模型
    unUsedPrizeModel * model = self.dataArray[findex];
    vc.identafy = @"1";
    vc.prizeModel = model;

    //删除通知
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"useBtnClick" object:nil];

    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - tableView数据源
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count?_dataArray.count:0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    boundCells *cell = [tableView dequeueReusableCellWithIdentifier:@"boundCells"];
    cell.index = (int)indexPath.row;

    if (cell == nil) {
        cell = [[boundCells alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"boundCells"];
        return cell;
    }
    if (self.dataArray.count>0) {
        cell.model = self.dataArray[indexPath.row];
    }
    if (self.dataArray.count == 0) {
        return cell;
    }

    return cell;
}

#pragma mark - textField代理方法
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

    self.backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, self.tableView.y, self.view.width, self.view.height)];
    self.backBtn.backgroundColor = [UIColor blackColor];
    self.backBtn.alpha = 0.4;
    [self.backBtn addTarget:self action:@selector(dissMess:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backBtn];

    //右导航按钮
    UIBarButtonItem * right = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(rightClick)];
    right.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = right;

    //清空数据源
    [self.dataArray removeAllObjects];
    [self.tableView reloadData];
    return YES;
}
-(void)dissMess:(UIButton *)btn{
    [btn removeFromSuperview];
    [self.textfield resignFirstResponder];
    self.navigationItem.rightBarButtonItem = nil;
}
-(void)rightClick{
    [self.backBtn removeFromSuperview];
    [self.textfield resignFirstResponder];
    self.navigationItem.rightBarButtonItem = nil;
}



#pragma mark - 奖品搜索结束事件
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    Account * account = [AccountTool account];
    [self.textfield resignFirstResponder];
    [self.backBtn removeFromSuperview];
    self.navigationItem.rightBarButtonItem = nil;
    if ([textField isEqual:self.textfield]) {//搜索事件
        if (!account) {
            [MBProgressHUD showError:@"账号信息有误,请重新登录!"];
            return YES;
        }
        [self seachPrizeWithPage:@"0"];
    }
    return YES;
}


#pragma mark - 搜索奖品方法
-(void)seachPrizeWithPage:(NSString *)page{
    if (self.textfield.text.length == 0) {
        return;
    }
    [MBProgressHUD showMessage:@"查询中..." toView:self.view];
    Account * account = [AccountTool account];
    NSString * str = kboundSearchStr;

    NSString * type = _type;
    if (!type) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"请输入搜索内容"];
        return;
    }
    
    NSDictionary *parameter = @{@"pageNum":page,@"serverToken":account.reponseToken,@"userId":account.uiId,@"client":Kclient,@"couponsType":type,@"vagueFlag":@"1",@"vagueVal":self.textfield.text};

    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    [manager POST:str parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DebugLog(@"搜索结果==%@",responseObject);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([responseObject[@"code"]  isEqual: @(0)]){
            NSArray * array = responseObject[@"data"];
            if (array.count == 0) {
                self.no = @"1";
                [MBProgressHUD showError:@"没有更多数据!"];
                [self.tableView reloadData];
                return ;
            }
            [MBProgressHUD showSuccess:@"奖品查询成功!"];
            //往数据源里添加数据
            for (NSDictionary *dict in responseObject[@"data"]) {
                unUsedPrizeModel *unUsedPrize = [unUsedPrizeModel prizeWithDict:dict];
                [self.dataArray addObject:unUsedPrize];
            }
            //刷新数据
            [self.tableView reloadData];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }else if ([responseObject[@"code"] isEqual:KotherLogin]){
            self.no = @"1";
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showError:@"账号已过有效期，请重新登录" ];
            [self jumpToMyAccountVC];
        }else{
            self.no = @"1";
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showError:responseObject[@"msg"]];
            self.tableView.footer.hidden = YES;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"网络加载失败,请稍后再试!"];
    }];
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
//        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"haveJumped"];
        [self.dataArray removeAllObjects];
        [self.tableView reloadData];
        [self.navigationController pushViewController:myAccountVC animated:YES];
    }else{
        //当前用户注销之后跳转到登陆界面
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController * myAccountVC = [sb instantiateViewControllerWithIdentifier:@"myAccountVC"];
//        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"haveJumped"];
        [self.dataArray removeAllObjects];
        [self.tableView reloadData];
        [self.navigationController pushViewController:myAccountVC animated:YES];
    }
}


#pragma mark - 代理方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    unUsedPrizeModel * model = self.dataArray[indexPath.row];
    newBounsDetailVC * bonusDetailVC = [sb instantiateViewControllerWithIdentifier:@"newBounsDetailVC"];
    if (self.dataArray.count == 0) {
        return;
    }else{
        bonusDetailVC.couponsId = model.cid;
        bonusDetailVC.Type = model.type;
    }
    bonusDetailVC.identify = @"1";
    self.index = (int)indexPath.row;
    [self.navigationController pushViewController:bonusDetailVC animated:YES];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}





@end




