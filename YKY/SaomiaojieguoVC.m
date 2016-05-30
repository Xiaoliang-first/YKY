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

@interface SaomiaojieguoVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic , strong) UITableView * tableView;
@property (nonatomic) int index;
@property (nonatomic , copy) NSString * no;
@property (nonatomic , strong) NSMutableArray * dataArray;


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
    [self setLeft];

    [self addTableView];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
}

-(void)addTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenheight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];

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
    cell.model = self.dataArray[indexPath.row];

    return cell;
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
}
- (void)endrefreshing{
    [self.tableView.header endRefreshing];
    [self.tableView.footer endRefreshing];
}

-(void)loadUsedDataWithPage:(NSString*)page{

    NSString * bindPath = @"";
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    [XLRequest AFPostHost:kbaseURL bindPath:bindPath postParam:parameter isClient:YES getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        DebugLog(@"扫描结果请求网络返回数据=%@",responseDic);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    }];

}


@end
