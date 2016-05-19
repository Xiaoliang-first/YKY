//
//  managerCommendatoryVC.m
//  YKY
//
//  Created by 亮肖 on 15/6/15.
//  Copyright (c) 2015年 云途基石（北京）信息技术有限公司. All rights reserved.
//

#import "managerCommendatoryVC.h"
#import "managerCommendatoryCell.h"
#import "AFNetworking.h"
#import "common.h"
#import "prizeDetailModel.h"
#import "MBProgressHUD+MJ.h"
#import "MJRefresh.h"
#import "managerCommendatoryModel.h"


@interface managerCommendatoryVC ()

@property (nonatomic , strong) managerCommendatoryModel * managerCommendatoryModel;
@property (nonatomic , strong) NSMutableArray * dataArray;
/** 数据总量 */
@property (nonatomic) int rowCount;

@end

@implementation managerCommendatoryVC

#pragma mark - ****懒加载数组数据****
-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        self.dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.title = @"店长推荐";

    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"managerCommendatoryCell" bundle:nil] forCellReuseIdentifier:@"managerCommendatoryCell"];

    //加载数据
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];

    __block int index = 0;
    // 添加传统的上拉刷新
    __weak typeof (self) weakSelf = self;
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        if (weakSelf.rowCount/10>index) {
            [weakSelf endrefreshing];
            return ;
        }
        index = index + 1;
        [weakSelf loadModelDataWithpage:index];
        [weakSelf endrefreshing];
    }];
    [self loadModelDataWithpage:0];
}

- (void)endrefreshing{
    [self.tableView.header endRefreshing];
    [self.tableView.footer endRefreshing];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setLeftNavBtn];
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


#pragma mark - ******加载模型数据******
- (void)loadModelDataWithpage:(int)page{

    NSString *str = KmanagerCommendatoryStr;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = [[NSDictionary alloc]init];
    
    if (self.prizeDetailModel.mid == nil) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"没有数据"];
        [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(gotoBack) userInfo:nil repeats:NO];
        return;
    }
    parameters = @{@"mId":self.prizeDetailModel.mid,@"pageNum":@(page)};
    
    [manager POST:str parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.rowCount = (int)responseObject[@"rowCount"];
        if ([responseObject[@"code"] isEqual:@(0)]){
            NSArray *array = responseObject[@"data"];
            if (array.count == 0) {
                [MBProgressHUD showError:@"没有更多数据!"];
                if (_dataArray.count == 0) {
                    [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(gotoBack) userInfo:nil repeats:NO];
                }
                return ;
            }
            for (NSDictionary * dict in responseObject[@"data"]) {
                managerCommendatoryModel *model = [managerCommendatoryModel modelWithDict:dict];
                [self.dataArray addObject:model];
            }
        }else{
            [MBProgressHUD showError:@"暂时没有推荐奖品!"];
            [NSTimer scheduledTimerWithTimeInterval:1.7 target:self selector:@selector(gotoBack) userInfo:nil repeats:NO];
        }
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"网络加载失败"];
    }];
    
    
}

-(void)gotoBack{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count>0?self.dataArray.count:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *ID = @"managerCommendatoryCell";
    
    managerCommendatoryCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[managerCommendatoryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        return cell;
    }
    if (self.dataArray.count == 0) {
        return cell;
    }

    managerCommendatoryModel * model = self.dataArray[indexPath.row];

    cell.managerModel = model;

    return cell;
}

#pragma mark - tableview代理方法
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}
@end
