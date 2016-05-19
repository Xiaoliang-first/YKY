//
//  messageCenterVC.m
//  YKY
//
//  Created by 肖亮 on 15/9/14.
//  Copyright (c) 2015年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "messageCenterVC.h"
#import "messageCentercell.h"
#import "AFNetworking.h"
#import "common.h"
#import "noticeModel.h"
#import "messageCenterDetailVC.h"
#import "MBProgressHUD+MJ.h"
#import "homeTableBarVC.h"
#import "Account.h"
#import "AccountTool.h"


@interface messageCenterVC ()

/** 数据源数组 */
@property (nonatomic , strong) NSMutableArray * dataArray;


@end

@implementation messageCenterVC

-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        self.dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1.0];
    
    [self setLeftNavBtn];
    self.navigationItem.title = @"消息中心";

    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"messageCentercell" bundle:nil] forCellReuseIdentifier:@"messageCentercell"];
    
    //加载数据
    [self loadData];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setLeftNavBtn];
    self.tabBarController.tabBar.hidden = YES;
}

#pragma mark - 设置左导航nav
-(void)setLeftNavBtn{
    if ([self.ID isEqualToString:@"1"]) {
        UIBarButtonItem * left = [[UIBarButtonItem alloc]initWithTitle:@"<首页" style:UIBarButtonItemStylePlain target:self action:@selector(leftClick)];
        left.tintColor = [UIColor whiteColor];
        self.navigationItem.leftBarButtonItem = left;
    }else{
        UIBarButtonItem * left = [[UIBarButtonItem alloc]initWithTitle:@"<返回" style:UIBarButtonItemStylePlain target:self action:@selector(leftClick)];
        left.tintColor = [UIColor whiteColor];
        [left setImage:[UIImage imageNamed:@"jiantou-Left"]];
        self.navigationItem.leftBarButtonItem = left;
    }
}
-(void)leftClick{
    if ([self.ID isEqualToString:@"1"]) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        homeTableBarVC *vc = [sb instantiateViewControllerWithIdentifier:@"homeTableBarVC"];
        UIApplication *app = [UIApplication sharedApplication];
        UIWindow *window = app.keyWindow;
        
        window.rootViewController = vc;
        
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }

}

#pragma mark - 加载数据
-(void)loadData{
    
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];

    Account * account = [AccountTool account];

    NSString *str = kmessageCenterStr;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    NSDictionary * prameters = [[NSDictionary alloc]init];
    if (account) {
        prameters = @{@"client":Kclient,@"userId":account.uiId,@"serverToken":account.reponseToken};
    }else{
        prameters = nil;
    }

    [manager POST:str parameters:prameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        if ([responseObject[@"code"] isEqual:@(0)]) {
            NSArray * array = [NSArray array];
            array = responseObject[@"data"];
            if (array.count == 0) {
                [MBProgressHUD showError:@"系统暂无消息!"];
                [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(back) userInfo:nil repeats:NO];
                return ;
            }
            for (NSDictionary *dict in responseObject[@"data"]) {
                noticeModel *model = [noticeModel noticeWithDict:dict];
                [self.dataArray addObject:model];
            }
        }else{
            [MBProgressHUD showError:@"系统暂无更多消息!"];
        }
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"网络加载失败"];
    }];
}

-(void)back{
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

    messageCentercell *cell = [tableView dequeueReusableCellWithIdentifier:@"messageCentercell"];
    if (_dataArray.count == 0) {
        return cell;
    }
    cell.noticeModel = self.dataArray[indexPath.row];
    
    return cell;
}

#pragma mark - 代理方法
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

#pragma mark - 选中跳转
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    messageCenterDetailVC * vc = [sb instantiateViewControllerWithIdentifier:@"messageCenterDetailVC"];
    noticeModel * model = self.dataArray[indexPath.row];
    vc.TitleStr = model.sysTitle;
    vc.time = model.publicDate;
    vc.content = model.sysContent;
    [self.navigationController pushViewController:vc animated:YES];
}




@end
