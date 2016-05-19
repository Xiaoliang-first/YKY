//
//  YGCurrentyaogouList.m
//  YKY
//
//  Created by 肖 亮 on 16/4/11.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "YGCurrentyaogouList.h"
#import "YGCurrentyaogouListCell.h"
#import "YGCurrentyaogouListModel.h"

@interface YGCurrentyaogouList ()<UITableViewDataSource,UITableViewDelegate>

@property ( nonatomic , strong ) NSMutableArray * dataArray;
@property (nonatomic) int index;
@property (nonatomic , copy) NSString * no;
@property (nonatomic , strong) UITableView * tableView;

@end

@implementation YGCurrentyaogouList

-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        self.dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"摇购记录";

    CGFloat top = 0;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, top, kScreenWidth, kScreenheight-top) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];

    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"YGCurrentyaogouListCell" bundle:nil] forCellReuseIdentifier:@"YGCurrentyaogouListCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    //设置左道航
    [self setLeft];

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
        weakSelf.tableView.footer.hidden = NO;
        [weakSelf endrefreshing];
    }];

    [self loadDataWithPage:@"0"];
}
-(void)endrefreshing{
    [self.tableView.header endRefreshing];
    [self.tableView.footer endRefreshing];
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


-(void)loadDataWithPage:(NSString *)page{
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    NSMutableDictionary * paramete = [NSMutableDictionary dictionary];
    [paramete setValue:page forKey:@"pageNum"];
    [paramete setValue:_serailId forKey:@"serailId"];

    NSString * bindPath = @"/yshakeUtil/getJoinedRecords";
    [XLRequest AFPostHost:kbaseURL bindPath:bindPath postParam:paramete isClient:NO getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        DebugLog(@"该奖品摇购记录获取结果=%@",responseDic);
        if ([responseDic[@"code"] isEqual:@0]) {
            NSArray * array = [NSArray array];
            array = responseDic[@"data"];
            if (array.count == 0) {
                [MBProgressHUD showError:@"暂无更多记录"];
                self.no = @"1";
                self.index = 0;
                self.tableView.footer.hidden = YES;
                if (_dataArray.count == 0) {
                    [NSTimer scheduledTimerWithTimeInterval:1.7 target:self selector:@selector(goBack) userInfo:nil repeats:NO];
                }
                return ;
            }
            for (NSDictionary * dict in responseDic[@"data"]) {
                YGCurrentyaogouListModel * model = [YGCurrentyaogouListModel modeWithDict:dict];
                [self.dataArray addObject:model];
            }
        }else{
            self.index = 0;
            [MBProgressHUD showError:responseDic[@"msg"]];
        }
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DebugLog(@"该奖品摇购记录获取失败error=%@====oper=%@",error,operation);
        self.index = 0;
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:@"网络加载失败,请稍后!"];
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count?_dataArray.count:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    YGCurrentyaogouListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YGCurrentyaogouListCell" forIndexPath:indexPath];

    if (cell == nil) {
        cell = [[YGCurrentyaogouListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCellStyleDefault"];
    }
    if (_dataArray.count < indexPath.row) {
        return cell;
    }
    cell.LuckModel = self.dataArray[indexPath.row];

    DebugLog(@"--%lu--%@",(unsigned long)self.dataArray.count,cell.LuckModel.luckerName);
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 95;
}


-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}



@end
