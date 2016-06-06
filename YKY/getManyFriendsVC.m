//
//  getManyFriendsVC.m
//  YKY
//
//  Created by 肖 亮 on 16/5/31.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "getManyFriendsVC.h"
#import "getFriendsCell.h"
#import "getFriendModel.h"
#import "Account.h"
#import "AccountTool.h"


@interface getManyFriendsVC ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic , strong) NSMutableArray * dataArray;
@property (nonatomic) int index;
@property (nonatomic , copy) NSString * no;


@end

@implementation getManyFriendsVC

-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        self.dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"邀请好友明细";
    [self setLeft];

    [self.tableView registerNib:[UINib nibWithNibName:@"getFriendsCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"getFriendsCell"];


    _index = 0;
    __weak typeof (self) weakSelf = self;
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        self.index = self.index + 1;
        NSString *idx = [NSString stringWithFormat:@"%d",self.index];
        if ([weakSelf.no isEqualToString:@"1"]) {
            self.index = 0;
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


#pragma mark - 设置leftItem
-(void)setLeft{
    UIBarButtonItem * left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"jiantou-Left"] style:UIBarButtonItemStylePlain target:self action:@selector(leftClick)];
    left.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = left;
}
-(void)leftClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count?_dataArray.count:0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    getFriendsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"getFriendsCell"];

    if (cell == nil) {
        cell = [[getFriendsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"getFriendsCell"];
    }
    if (_dataArray.count == 0 || _dataArray.count<indexPath.row) {
        return cell;
    }
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}




-(void)loadUsedDataWithPage:(NSString *)page{

//    NSDictionary * dic = @{@"phone":@"13716344285",@"signtime":@"2016-05-20",@"diamondsnum":@"2"};
//
//    getFriendModel * model = [getFriendModel modelWithDict:dic];
//    [self.dataArray addObject:model];
//    [self.tableView reloadData];

    Account * account = [AccountTool account];
    if (!account) {
        [MBProgressHUD showError:@"账号信息有误,请重新登录!"];
        [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(jumpToMyaccountVC) userInfo:nil repeats:NO];
        return;
    }


    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    NSString * bindPath = @"/user/iniviteList";
    NSMutableDictionary * parmeter = [NSMutableDictionary dictionary];

    [parmeter setObject:page forKey:@"pageNum"];
    [parmeter setObject:account.phone forKey:@"userPhone"];

    [XLRequest AFPostHost:kbaseURL bindPath:bindPath postParam:parmeter isClient:YES getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        DebugLog(@"已推荐的好友列表数据=%@",responseDic);
        if ([responseDic[@"code"] isEqual:@0]) {
            NSArray * array = [NSArray arrayWithArray:responseDic[@"data"]];
            if (array.count == 0) {
                self.index = 0;
                self.no = @"1";
                [MBProgressHUD showError:@"没有更多数据"];
                return ;
            }
            for (NSDictionary * dic in array) {
                getFriendModel * model = [getFriendModel modelWithDict:dic];
                [self.dataArray addObject:model];
            }
            [self.tableView reloadData];
        }else if([responseDic[@"code"] isEqual:KotherLogin]){
            [MBProgressHUD showError:@"账号信息有误,请重新登录!"];
            [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(jumpToMyaccountVC) userInfo:nil repeats:NO];
        }else{
            [MBProgressHUD showError:@"网路加载失败,请稍后再试!"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"网路加载失败,请稍后再试!"];
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
