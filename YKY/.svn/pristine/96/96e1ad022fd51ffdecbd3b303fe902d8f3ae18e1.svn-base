//
//  systemNoticeVC.m
//  一块摇
//
//  Created by 亮肖 on 15/4/24.
//  Copyright (c) 2015年 云途基石（北京）信息技术有限公司. All rights reserved.
//

#import "systemNoticeVC.h"
#import "noticeCell.h"
#import "noticeDetailVC.h"
#import "AFNetworking.h"
#import "common.h"
#import "noticeModel.h"
#import "MBProgressHUD+MJ.h"


@interface systemNoticeVC ()

/**  “系统通知”数组 */
@property (nonatomic , strong) NSArray * NoticeDataArray;

/** 存放数据模型的数组 */
@property (nonatomic , strong) NSMutableArray * mutableDataArray;


@end

@implementation systemNoticeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"系统通知";
    
    [self loadSystemData];
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"noticeCell" bundle:nil] forCellReuseIdentifier:@"noticeCell"];
    [self setLeftNavBtn];
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

- (void)loadSystemData{
    
    NSString *str = ksystemNoticeStr;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    self.mutableDataArray = [[NSMutableArray alloc]init];
    [manager POST:str parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"code"] isEqual:@(0)]) {
            for (NSDictionary *dict in responseObject[@"data"]) {
                noticeModel *model = [noticeModel noticeWithDict:dict];
                [self.mutableDataArray addObject:model];
            }
        }
        [self.tableView reloadData];
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
    return self.mutableDataArray.count?self.mutableDataArray.count:1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    noticeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"noticeCell" forIndexPath:indexPath];
    if (self.mutableDataArray.count == 0) {
        return cell;
    }
    cell.noticeModel = self.mutableDataArray[indexPath.row];
    return cell;
}

#pragma mark - 代理方法

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 68;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    跳入详情界面
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    noticeDetailVC * noticedetailVC = [sb instantiateViewControllerWithIdentifier:@"noticeDetailVC"];
    if (self.mutableDataArray.count == 0) {
        [MBProgressHUD showError:@"请查看您的网络"];
        return;
    }
    noticedetailVC.noticemodel = self.mutableDataArray[indexPath.row];
    [self.navigationController pushViewController:noticedetailVC animated:YES];
}

@end
