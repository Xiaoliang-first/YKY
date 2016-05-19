//
//  theMoreVC.m
//  YKY
//
//  Created by 肖亮 on 15/9/13.
//  Copyright (c) 2015年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "theMoreVC.h"
#import "common.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "MJRefresh.h"
#import "prizeModel.h"
#import "homeTableViewCell.h"
#import "homePrizeDetailVC.h"


@interface theMoreVC ()

@property (nonatomic , strong) NSMutableArray * dataArray;
@property (nonatomic , copy) NSString * no;


@end

@implementation theMoreVC


-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        self.dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationItem.title = @"重磅推出";
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"homeTableViewCell" bundle:nil] forCellReuseIdentifier:@"homeTableViewCell"];

    
    //加载数据
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    [self loadDataWithPage:@"0"];
    __block int index = 0;
    // 添加传统的上拉刷新
    __weak typeof (self) weakSelf = self;
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        index = index + 1;
        NSString *idx = [NSString stringWithFormat:@"%d",index];
        if ([weakSelf.no isEqualToString:@"1"]) {
            [weakSelf endrefreshing];
            return ;
        }
        [weakSelf loadDataWithPage:idx];
        [weakSelf endrefreshing];
    }];
}

- (void)endrefreshing{
    [self.tableView.header endRefreshing];
    [self.tableView.footer endRefreshing];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    //设置导航按钮
    [self setLeftNavBtn];
}

#pragma mark - 设置左导航按钮
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
-(void)loadDataWithPage:(NSString *)page{

    NSString * str = [kbaseURL stringByAppendingString:@"/index/prizeListMore"];
    
    NSString * ciId = [[NSUserDefaults standardUserDefaults]objectForKey:@"cityId"];
    
    NSDictionary *parameter = @{@"pageNum":page,@"cityId":ciId};
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:str parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray * array = [NSArray array];
        array = responseObject[@"data"];
        if (array.count == 0) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showError:@"没有更多数据"];
            self.tableView.footer.hidden = YES;
            return ;
        }
        if ([responseObject[@"code"] isEqual:@(0)]) {
            for (NSDictionary * dict in responseObject[@"data"]) {
                prizeModel * model = [prizeModel prizeWithDict:dict];
                [self.dataArray addObject:model];
            }
            [self.tableView reloadData];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showError:@"没有更多数据!"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"网络加载失败"];
    }];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count?_dataArray.count:0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    homeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"homeTableViewCell"];
    if (cell == nil) {
        cell = [[homeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"homeTableViewCell"];
        return cell;
    }
    cell.prizemodel = self.dataArray[indexPath.row];
    return cell;
}

#pragma mark - 代理方法
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 125;
}

#pragma mark - 选中行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    homePrizeDetailVC * vc = [sb instantiateViewControllerWithIdentifier:@"homePrizeDetailVC"];
    prizeModel * model = self.dataArray[indexPath.row];
    vc.pId = [NSString stringWithFormat:@"%@",model.pId];
    vc.indentify = @"1";
    [self.navigationController pushViewController:vc animated:YES];
    
}



@end
