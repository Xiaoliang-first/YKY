//
//  lookLuckTableVC.m
//  YKY
//
//  Created by 肖亮 on 15/9/13.
//  Copyright (c) 2015年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "lookLuckTableVC.h"
#import "common.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "lookLucksModel.h"
#import "lookLuckTableCell.h"
#import "MJRefresh.h"


@interface lookLuckTableVC ()<UITableViewDataSource,UITableViewDelegate>


/** 中奖名单的数据源数组 */
@property (nonatomic , strong) NSMutableArray * dataArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 没有数据时的标志 1:没有数据 */
@property (nonatomic , copy) NSString * no;


@end

@implementation lookLuckTableVC

-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        self.dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"头奖摇粉";
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"lookLuckTableCell" bundle:nil] forCellReuseIdentifier:@"lookLuckTableCell"];
    
    //初次加载数据
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    [self loadDataWithPage:@"0"];
    // 添加传统的上拉刷新
    __weak typeof (self) weakSelf = self;
    __block int index = 0;
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        index = index + 1;
        NSString *idx = [NSString stringWithFormat:@"%d",index];
        if ([weakSelf.no isEqualToString:@"1"]) {
            weakSelf.tableView.footer.hidden = YES;
            [weakSelf.tableView removeFooter];
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
    self.tabBarController.tabBar.hidden = YES;
    //设置左导航按钮
    [self setLeftNav];
}

#pragma mark - 设置左导航按钮
-(void)setLeftNav{
    UIBarButtonItem * left = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(leftClick)];
    left.tintColor = [UIColor whiteColor];
    [left setImage:[UIImage imageNamed:@"jiantou-Left"]];
    self.navigationItem.leftBarButtonItem = left;
}
-(void)leftClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 加载数据
-(void)loadDataWithPage:(NSString *)page{

    NSString * str = klistOfAwardWinnersStr;
    
    NSDictionary *parameter = @{@"pageNum":page};
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:str parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        if (!responseObject[@"data"]) {
            self.no = @"1";
            [MBProgressHUD showError:@"没有更多数据"];
            self.tableView.footer.hidden = YES;
            return;
        }
        if ([responseObject[@"code"] isEqual:@(0)]) {
            for (NSDictionary * dict in responseObject[@"data"]) {
                lookLucksModel * model = [lookLucksModel modelWithdict:dict];
                [self.dataArray addObject:model];
            }
            [self.tableView reloadData];
        }else{
            [MBProgressHUD showError:@"没有更多数据!"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"网络加载失败!"];
    }];
}


#pragma mark - dataSouce
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count?_dataArray.count:0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    lookLuckTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"lookLuckTableCell"];
    if (cell == nil) {
        cell = [[lookLuckTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"lookLuckTableCell"];
        return cell;
    }
    cell.lookLucksmodels = self.dataArray[indexPath.row];
    return cell;
}

#pragma mark - dataDelete
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}


@end
