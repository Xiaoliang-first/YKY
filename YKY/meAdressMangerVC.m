//
//  meAdressMangerVC.m
//  YKY
//
//  Created by 肖 亮 on 16/4/18.
//  Copyright © 2016年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "meAdressMangerVC.h"
#import "meAdressModel.h"
#import "meAdressCell.h"
#import "Account.h"
#import "AccountTool.h"
#import "meAddAddressVC.h"
#import "meLuckPrizeState.h"


@interface meAdressMangerVC ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property (nonatomic , strong) UITableView * tableView;
@property (nonatomic , strong) NSMutableArray * dataArray;
@property (nonatomic , strong) meAdressModel * Addressmodel;

@property (nonatomic , strong) NSIndexPath * oldHostIndex;
@property (nonatomic , strong) UIView * addAddressBtnBackView;
@property (nonatomic , strong) UIButton * addAddressBtn;


@end

@implementation meAdressMangerVC

-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        self.dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"地址管理";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setLeft];
    if ([_identify isEqualToString:@"1"]) {
        [self setRight];
    }
    //添加tableView
    [self addTableView];

    //添加底部的添加地址按钮
    [self addBottom];
}

#pragma mark - 设置leftItem
-(void)setRight{
    UIBarButtonItem * right = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(upDateAddreess)];
    right.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = right;
}



-(void)addTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenheight-70)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    if ([self.identify isEqualToString:@"1"]) {
//        self.tableView.userInteractionEnabled = YES;
    }else{
//        self.tableView.userInteractionEnabled = NO;
    }
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"meAdressCell" bundle:nil] forCellReuseIdentifier:@"meAdressCell"];
}
-(void)addBottom{
    self.addAddressBtnBackView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenheight-70, kScreenWidth, 70)];
    self.addAddressBtnBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.addAddressBtnBackView];
    self.addAddressBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 0, kScreenWidth-2*15, 40)];
    [self.addAddressBtn setTitle:@"添加新地址" forState:UIControlStateNormal];
    self.addAddressBtn.titleLabel.font = [UIFont systemFontOfSize:[myFont getTitle2]];
    [self.addAddressBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.addAddressBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.addAddressBtn.backgroundColor = YKYColor(249, 60, 67);
    [self.addAddressBtn addTarget:self action:@selector(addAdressBtnClick) forControlEvents:UIControlEventTouchUpInside];
    //设置图片圆角
    self.addAddressBtn.layer.cornerRadius = 5;
    self.addAddressBtn.layer.masksToBounds = YES;
    self.addAddressBtn.layer.borderWidth = 0.01;
    [self.addAddressBtnBackView addSubview:self.addAddressBtn];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    //网络获取地址列表
    [self getAdressData];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
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

-(void)addAdressBtnClick{
    DebugLog(@"添加地址");
    if (_dataArray.count<3) {
        meAddAddressVC * vc = [[meAddAddressVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [MBProgressHUD showError:@"您最多只能添加3个地址哦!"];
    }
}




#pragma mark - tableView数据源datasouce
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count?_dataArray.count:0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    meAdressCell * cell = [tableView dequeueReusableCellWithIdentifier:@"meAdressCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[meAdressCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"meAdressCell"];
    }
    meAdressModel * model = _dataArray[indexPath.row];
    if ([model.isHost isEqualToString:@"1"]) {
        self.oldHostIndex = indexPath;
    }
    cell.model = model;
    return cell;
}




-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 63;
}
#pragma mark - tableviewDelegate代理方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    meAdressModel * model = _dataArray[indexPath.row];
    self.Addressmodel = model;
    DebugLog(@"选中地址==%@",model.ID);
    if ([self.identify isEqualToString:@"1"]) {
        if (indexPath != self.oldHostIndex) {//非默认地址点选
            meAdressCell * oldHostCell = [self.tableView cellForRowAtIndexPath:self.oldHostIndex];
            oldHostCell.backImagView.hidden = YES;
            oldHostCell.isMyAdressImgv.hidden = YES;
            oldHostCell.nameLabel.textColor = YKYColor(51, 51, 51);
            oldHostCell.phoneLabel.textColor = YKYColor(51, 51, 51);
            oldHostCell.adressDetail.textColor = YKYColor(102, 102, 102);
        }
        meAdressCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.isMyAdressImgv.hidden = NO;
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, cell.contentView.width, cell.contentView.height)];
        view.backgroundColor = YKYColor(255, 78, 79);
        cell.selectedBackgroundView = view;
        cell.backImagView.hidden = YES;
        cell.nameLabel.textColor = [UIColor whiteColor];
        cell.phoneLabel.textColor = [UIColor whiteColor];
        cell.adressDetail.textColor = [UIColor whiteColor];
    }
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.identify isEqualToString:@"1"]) {
        meAdressCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.backImagView.hidden = YES;
        cell.isMyAdressImgv.hidden = YES;
        cell.nameLabel.textColor = YKYColor(51, 51, 51);
        cell.phoneLabel.textColor = YKYColor(51, 51, 51);
        cell.adressDetail.textColor = YKYColor(102, 102, 102);
    }
}

#pragma mark - tableView 左滑删除
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [self.tableView reloadData];
    if ([self.identify isEqualToString:@"1"]) {
        for (meAdressCell * oldHostCell in tableView.visibleCells) {
            oldHostCell.backImagView.hidden = YES;
            oldHostCell.isMyAdressImgv.hidden = YES;
            oldHostCell.nameLabel.textColor = YKYColor(51, 51, 51);
            oldHostCell.phoneLabel.textColor = YKYColor(51, 51, 51);
            oldHostCell.adressDetail.textColor = YKYColor(102, 102, 102);
        }
    }
    self.Addressmodel = nil;
    return @"删除";
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 从数据源中删除
    if (_dataArray.count == 0 || indexPath.row > _dataArray.count) {
        return;
    }
    //网络删除
    meAdressModel * model = self.dataArray[indexPath.row];
    [self deleteWithModel:model];

    [_dataArray removeObjectAtIndex:indexPath.row];
    // 从列表中删除
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}


#pragma mark - 提交收货地址
-(void)upDateAddreess{

    UIAlertView * alter = [[UIAlertView alloc]initWithTitle:@"当前选择:" message:[NSString stringWithFormat:@"%@",_Addressmodel.adressDetail] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    BOOL sele = NO;
    for (meAdressModel * model in _dataArray) {
        if ([model.adressDetail isEqual:_Addressmodel.adressDetail]) {
            sele = YES;
            [alter show];
        }
    }

    if (sele == NO) {
        [MBProgressHUD showError:@"请选择收货地址!"];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:

            break;
        case 1:
            [self okUpDateAddress];//提交地址
            break;

        default:
            break;
    }
}

-(void)okUpDateAddress{
    NSString * bindPath = @"/yshakeCoupons/addOrder";
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    [parameter setValue:_serialId forKey:@"serialId"];
    [parameter setValue:_agentId forKey:@"agentId"];
    if (!_Addressmodel.phone) {
        for (meAdressModel * model in self.dataArray) {
            if ([model.isHost isEqualToString:@"1"]) {
                [parameter setValue:model.phone forKey:@"phone"];
                [parameter setValue:model.name forKey:@"name"];
                [parameter setValue:model.adressDetail forKey:@"address"];
            }
        }
    }else{
        [parameter setValue:_Addressmodel.phone forKey:@"phone"];
        [parameter setValue:_Addressmodel.name forKey:@"name"];
        [parameter setValue:_Addressmodel.adressDetail forKey:@"address"];
    }

    if (![parameter objectForKey:@"address"]) {
        [MBProgressHUD showError:@"地址选择失败,请重试!"];
        return;
    }

    [XLRequest AFPostHost:kbaseURL bindPath:bindPath postParam:parameter isClient:YES getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        DebugLog(@"===收货地址选择提交结果---%@",responseDic);
        if ([responseDic[@"code"] isEqual:@0]) {
            [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"prizeState-me"];
            [self.navigationController popViewControllerAnimated:YES];
        }else if ([responseDic[@"code"] isEqual:KotherLogin]){
            [self jumpToMyaccountVC];
        }else{
            [MBProgressHUD showError:@"地址提交失败,请稍后再试!"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"地址提交失败,请检查网路"];
    }];
}




#pragma mark - 删除地址网络交互
-(void)deleteWithModel:(meAdressModel*)model{

    if (!model.ID) {
        return;
    }
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    [parameters setValue:model.ID forKey:@"id"];

    [XLRequest AFPostHost:kbaseURL bindPath:@"/yshakeCoupons/deleteAdd" postParam:parameters isClient:YES getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        DebugLog(@"地址管理删除地址结果==%@",responseDic);
        if ([responseDic[@"code"] isEqual:@0]) {
            [MBProgressHUD showSuccess:@"地址删除成功!"];
        }else if ([responseDic[@"code"] isEqual:KotherLogin]){
            [self jumpToMyaccountVC];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DebugLog(@"地址删除失败==error=%@==oper=%@",error,operation);
    }];
}



#pragma mark - 获取地址列表数据
-(void)getAdressData{
    [MBProgressHUD showMessage:@"获取中..." toView:self.view];
    Account * account = [AccountTool account];
    if (!account) {
        [self jumpToMyaccountVC];
        return;
    }
    [self.dataArray removeAllObjects];
    NSString * bindPath = @"/yshakeCoupons/queryAdds";
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    [XLRequest AFPostHost:kbaseURL bindPath:bindPath postParam:parameter isClient:YES getParam:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        DebugLog(@"地址管理界面获取地址列表数据=%@",responseDic);
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        if ([responseDic[@"code"] isEqual:knoData]) {//没有地址
            UIAlertView * alter = [[UIAlertView alloc]initWithTitle:@"提示:" message:@"亲~您还没有添加收货地址哦!" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alter show];
        }else if ([responseDic[@"code"] isEqual:@0]){//获取成功
            for (NSDictionary * dict in responseDic[@"data"]) {
                meAdressModel * model = [meAdressModel modelWithDict:dict];
                [self.dataArray addObject:model];
            }
            for (meAdressModel * model in self.dataArray){
                if ([model.isHost isEqualToString:@"1"]) {
                    self.Addressmodel = model;
                }
            }
            [self.tableView reloadData];
        }else{
            [MBProgressHUD showError:responseDic[@"msg"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"网络加载失败!"];
        DebugLog(@"error=%@====operation=%@",error,operation);
    }];
}


//单点登录
-(void)jumpToMyaccountVC{
    Account *account = [AccountTool account];
    if (account) {
        //实现当前用户注销（就是把 account.data文件清空）
        account = nil;
        [AccountTool saveAccount:account];

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
