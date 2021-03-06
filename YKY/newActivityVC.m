//
//  newActivityVC.m
//  YKY
//
//  Created by 肖亮 on 15/9/16.
//  Copyright (c) 2015年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "newActivityVC.h"
#import "common.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "MJRefresh.h"
#import "newActivityCell.h"
#import "newActivityModel.h"
#import "newAvtivityDetailVC.h"
#import "YGPrizeDetailVC.h"



@interface newActivityVC ()<UIAlertViewDelegate>


/** 活动列表数据源数组 */
@property (nonatomic , strong) NSMutableArray * dataArray;
/** 没有数据的标注 1:没有数据 0:有数据 */
@property (nonatomic , copy) NSString * no;
@property (nonatomic , strong) UIAlertView * agentIdAlert;


@end

@implementation newActivityVC


-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        self.dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置左nav
    [self setLeftNavBtn];
    
    //设置标题
    self.navigationItem.title = @"指定摇专区";
    self.tabBarController.tabBar.hidden = YES;
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"newActivityCell" bundle:nil] forCellReuseIdentifier:@"newActivityCell"];
    
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


-(void)loadDataWithPage:(NSString *)page{
    
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    NSString *str = kactivityListStr;
    
    NSString * ciId = [[NSUserDefaults standardUserDefaults]objectForKey:@"cityId"];
    
    if (ciId == nil) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        [MBProgressHUD showError:@"城市信息有误"];
        self.agentIdAlert = [[UIAlertView alloc]initWithTitle:@"摇哥提示:" message:@"1.选择本地城市，开启100%中奖之旅，随意摇和指定摇的奖品仅限到店兑换使用\n2.暂时还没开通地区的摇粉，可以先去玩摇购，一元摇大奖，邮寄到您家!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"选择城市",@"新手帮助", nil];
        [self.agentIdAlert show];
        return;
    }
    
    NSDictionary *parameter = @{@"cityId":ciId,@"pageNum":page};
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:str parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        if ([responseObject[@"code"] isEqual:@(0)]) {
            NSArray * array = responseObject[@"data"];
            if (array.count == 0) {
                [MBProgressHUD showError:@"没有数据"];
                self.no = @"1";
                return ;
            }else{
                self.no = @"0";
            }
            
            for (NSDictionary *dict in responseObject[@"data"]) {
                newActivityModel * model = [newActivityModel modelWithDict:dict];
                [self.dataArray addObject:model];
            }
            [self.tableView reloadData];
        }else{
            [MBProgressHUD showError:responseObject[@"msg"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"网络加载失败"];
    }];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case 1:
            if ([alertView isEqual:self.agentIdAlert]) {//跳转到城市选择
                [self jumpToCitys];
            }
            break;
        case 2:
            if ([alertView isEqual:self.agentIdAlert]) {//跳转到新手帮助
                [self jumpToNewHelp];
            }
            break;

        default:
            break;
    }
}

-(void)jumpToCitys{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController * vc = [sb instantiateViewControllerWithIdentifier:@"citysViewVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)jumpToNewHelp{
    YGPrizeDetailVC * vc = [[YGPrizeDetailVC alloc]init];
    vc.title = @"新手帮助";
    vc.requestUrl = [NSURL URLWithString:kHelpCenterStr];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.dataArray removeAllObjects];
    //加载数据
    [self loadDataWithPage:@"0"];
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


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count?_dataArray.count:0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    newActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newActivityCell"];
    if (cell == nil) {
        cell = [[newActivityCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"newActivityCell"];
        return cell;
    }
    cell.activityModel = self.dataArray[indexPath.row];
    return cell;
}


#pragma mark - 代理方法
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 192;
}


#pragma mark - 选中跳转
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    newActivityModel * model = self.dataArray[indexPath.row];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    newAvtivityDetailVC * vc = [sb instantiateViewControllerWithIdentifier:@"newAvtivityDetailVC"];
    vc.activModel = model;
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
