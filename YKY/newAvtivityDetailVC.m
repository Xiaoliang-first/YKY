//
//  newAvtivityDetailVC.m
//  YKY
//
//  Created by 肖亮 on 15/9/17.
//  Copyright (c) 2015年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "newAvtivityDetailVC.h"
#import "MJRefresh.h"
#import "AFNetworking.h"
#import "common.h"
#import "MBProgressHUD+MJ.h"
#import "newActivityDetailCell.h"
#import "newActivityDetailModel.h"
#import "acADModel.h"
#import "adDetailVC.h"
#import "SDCycleScrollView.h"
#import "newActivityPrizeDetailVC.h"
#import "newActivityModel.h"
#import "newActivityRockingVC.h"
#import "jumpSafairTool.h"
#import "Account.h"
#import "AccountTool.h"
#import "myAccountVC.h"




@interface newAvtivityDetailVC ()<UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate>



/** 顶部滚动图的背景View */
@property (weak, nonatomic) IBOutlet UIView *topScrolBackView;
/** tableView */
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 摇动按钮 */
@property (weak, nonatomic) IBOutlet UIButton *rockingBtn;
/** 没有数据的标注 */
@property (nonatomic , copy) NSString * no;

/** 数据原数组 */
@property (nonatomic , strong) NSMutableArray * dataArray;

/** banner图片URL数组 */
@property (nonatomic , strong) NSMutableArray * Images;
@property (nonatomic , strong) SDCycleScrollView * activityHeaderView;

@property (nonatomic , strong) NSMutableArray * imagesDataArray;

@end

@implementation newAvtivityDetailVC

-(NSMutableArray *)imagesDataArray{
    if (_imagesDataArray == nil) {
        self.imagesDataArray = [[NSMutableArray alloc]init];
    }
    return _imagesDataArray;
}

-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        self.dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

-(NSMutableArray *)Images{
    if (_Images == nil) {
        self.Images = [[NSMutableArray alloc]init];
    }
    return _Images;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"奖品列表";
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"newActivityDetailCell" bundle:nil] forCellReuseIdentifier:@"newActivityDetailCell"];
    
    //设置左nav
    [self setLeftNavBtn];
    
    //加载数据
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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadTopImgUrls];
    if ([self.activModel.statu isEqual:@2]) {
        self.rockingBtn.hidden = YES;
    }else{
        self.rockingBtn.hidden = NO;
    }
    [self setLeftNavBtn];
    self.tabBarController.tabBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.imagesDataArray removeAllObjects];
    [self.activityHeaderView removeFromSuperview];
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


- (void)endrefreshing{
    [self.tableView.header endRefreshing];
    [self.tableView.footer endRefreshing];
}

#pragma mark - 加载数据
-(void)loadDataWithPage:(NSString *)page{
    
    NSString * str = kactivityDetailListStr;

    NSDictionary *parameter = @{@"pageNum":page,@"acId":self.activModel.activeId};
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:str parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSArray * array = [[NSArray alloc]init];
        array = responseObject[@"data"];
        if (array.count == 0) {
            self.no = @"1";
            [MBProgressHUD showError:@"没有更多数据!"];
            return ;
        }
        if ([responseObject[@"code"] isEqual:@(0)]) {
            if (array.count == 0) {
                self.no = @"1";
                [MBProgressHUD showError:@"没有更多数据!"];
                return ;
            }
            for (NSDictionary * dict in responseObject[@"data"]) {
                newActivityDetailModel * model = [newActivityDetailModel modelWithDict:dict];
                [self.dataArray addObject:model];
            }
            [self.tableView reloadData];
        }else{
            [MBProgressHUD showError:@"奖品加载失败,请重试!"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"网络异常,请检查您的网络!"];
    }];
}

#pragma mark - 加载顶部banner
-(void)loadTopImgUrls{
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    NSString * str = kactivityDetailBannerStr;

    NSDictionary *parameter = @{@"acId":self.activModel.activeId};

    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:str parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {

        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([responseObject[@"code"] isEqual:@(0)]) {
            NSArray * array = [[NSArray alloc]init];
            array = responseObject[@"data"];
            if (array.count == 0) {
                [self addPleseHoderImage];
                return ;
            }
            for (NSDictionary *dic in array) {
                acADModel * model = [acADModel adWithDict:dic];
                [self.imagesDataArray addObject:model];
            }
            [self setAdScrollView];
            [self.tableView reloadData];
        }else{
            [MBProgressHUD showError:responseObject[@"msg"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"网络加载失败"];
    }];
}

/**
 *  添加占位图
 */
-(void)addPleseHoderImage{
    UIImageView * imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.topScrolBackView.frame.size.width, self.topScrolBackView.frame.size.height)];
    imgView.image = [UIImage imageNamed:@"prepare_loading_big"];
    [self.topScrolBackView addSubview:imgView];
}

/**
 *  加载商家活动页
 */
- (void)setAdScrollView{
    
    for (acADModel *dict in self.imagesDataArray) {
        //将请求回来的URL字符串转换为URl
        NSURL * url = [NSURL URLWithString:dict.apic];
        //添加URL到图片URL数组
        [self.Images addObject:url];
    }
    self.activityHeaderView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, self.topScrolBackView.frame.size.height) imageURLsGroup:self.Images];
    self.activityHeaderView.delegate = self;
    self.activityHeaderView.autoScrollTimeInterval = 2.0;
    [self.activityHeaderView.mainView reloadData];
    [self.topScrolBackView addSubview:self.activityHeaderView];
    
}


#pragma mark - banner点击事件
-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    if (self.imagesDataArray[index] == nil) {
        return;
    }
    acADModel * model = self.imagesDataArray[index];
    //跳转
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    adDetailVC *adDetailVC = [sb instantiateViewControllerWithIdentifier:@"adDetailVC"];
    adDetailVC.adDetailUrl = [NSURL URLWithString:model.aurl];
    [self.navigationController pushViewController:adDetailVC animated:YES];
}

//单点登录
-(void)jumpToMyaccountVC{
    Account * account2 = [AccountTool account];
    if (account2) {
        //实现当前用户注销（就是把 account.data文件清空）
        account2 = nil;
        [AccountTool saveAccount:account2];
        //当前用户注销之后跳转到登陆界面
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        myAccountVC * myAccountVC = [sb instantiateViewControllerWithIdentifier:@"myAccountVC"];
        [self.navigationController pushViewController:myAccountVC animated:YES];
    }else{
        //当前用户注销之后跳转到登陆界面
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        myAccountVC * myAccountVC = [sb instantiateViewControllerWithIdentifier:@"myAccountVC"];
        [self.navigationController pushViewController:myAccountVC animated:YES];
    }
}

#pragma mark - 摇动按钮点击事件
- (IBAction)rockingBtnClick:(id)sender {

    if ([self.activModel.statu isEqual:@2]) {
        [MBProgressHUD showError:@"活动暂未开始!"];
        return;
    }
    
    Account * account = [AccountTool account];
    if (account == nil) {
        [self jumpToMyaccountVC];
        return;
    }
    jumpSafairTool * tool = [[jumpSafairTool alloc]init];
    if ([tool jumpOrNo]) {//需要跳转到safair

        NSString * agentId = [[NSUserDefaults standardUserDefaults]objectForKey:@"agentId"];

        NSString * str = [NSString stringWithFormat:@"http://api.yikuaiyao.com/ios/index.jsp?rt=%@&uid=%@&t=2&c=%@&acid=%@&aid=%@",account.reponseToken,account.uiId,Kclient,self.activModel.activeId,agentId];

        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        
    }else{//正常执行程序
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        newActivityRockingVC * vc = [sb instantiateViewControllerWithIdentifier:@"newActivityRockingVC"];
        vc.model = self.activModel;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


#pragma mark - 数据源
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count?_dataArray.count:0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    newActivityDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newActivityDetailCell"];
    if (cell == nil) {
        cell = [[newActivityDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"newActivityDetailCell"];
    }
    cell.model = self.dataArray[indexPath.row];
    return cell;
}


#pragma mark - 代理方法
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 88;
}

#pragma mark - 选中方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    newActivityPrizeDetailVC * vc = [sb instantiateViewControllerWithIdentifier:@"newActivityPrizeDetailVC"];
    vc.activName = self.activModel.activeName;
    newActivityDetailModel * model = _dataArray[indexPath.row];
    vc.jpId = model.jpId;
    vc.prizeId = model.pid;
    [self.navigationController pushViewController:vc animated:YES];
    
}



@end
