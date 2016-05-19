//
//  signinDetailVC.m
//  YKY
//
//  Created by 肖亮 on 15/9/22.
//  Copyright (c) 2015年 金蚂蚁（北京）网络科技有限公司. All rights reserved.
//

#import "signinDetailVC.h"
#import "common.h"
#import "AFNetworking.h"
#import "chargeCityCell.h"
#import "cityModel.h"
#import "severceDeal.h"
#import "MBProgressHUD+MJ.h"
#import <CommonCrypto/CommonDigest.h>
#import "cityModel.h"
#import "Account.h"
#import "AccountTool.h"
#import "MobClick.h"

@interface signinDetailVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>


/** 密码field */
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
/** 确认密码field */
@property (weak, nonatomic) IBOutlet UITextField *okPwdField;
/** 推荐人电话field */
@property (weak, nonatomic) IBOutlet UITextField *friendPhoneField;
/** 选择城市Btn */
@property (weak, nonatomic) IBOutlet UIButton *chargeCityBtn;
/** 同意协议小框框Btn */
@property (weak, nonatomic) IBOutlet UIButton *agreeOrNoBtn;
/** 选择城市的Tableview */
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 同意服务协议 */
@property (nonatomic) BOOL agreeSever;


/** 城市列表数据源数组 */
@property (nonatomic , strong) NSMutableArray * dataArray;
@property (nonatomic , strong) cityModel * model;
//@property (nonatomic , copy) NSString * cityId;

/** 电话号码label */
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;


@end

@implementation signinDetailVC

-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        self.dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"注册信息";
    
    self.phoneLabel.text = self.phone;
    
    [self setLeftNavBtn];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"chargeCityCell" bundle:nil] forCellReuseIdentifier:@"chargeCityCell"];

    self.agreeSever = YES;
    [self loadData];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.pwdField resignFirstResponder];
    [self.okPwdField resignFirstResponder];
    [self.friendPhoneField resignFirstResponder];
    self.tableView.hidden = YES;
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

#pragma mark - 加载数据
-(void)loadData{
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    NSString * str = kgetCityListStr;

    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:str parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject[@"code"] isEqual:@(0)]) {
            if (responseObject[@"AllCity"] == nil) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                return ;
            }
            for (NSDictionary * dict in responseObject[@"AllCity"]) {
                cityModel * model = [cityModel cityWithDict:dict];
                [self.dataArray addObject:model];
            }
            [self.tableView reloadData];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"网络加载失败,请稍后再试!"];
    }];
}


#pragma mark - 数据源事件
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count?_dataArray.count:0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    chargeCityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chargeCityCell"];

    if (self.dataArray.count > 0) {
        cell.model = self.dataArray[indexPath.row];
    }
    
    return cell;
}

#pragma mark - 代理事件
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 20;
}
#pragma mark - 选中cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    cityModel * model = self.dataArray[indexPath.row];
    [self.chargeCityBtn setTitle:model.ciName forState:UIControlStateNormal];
    self.model = model;
    self.tableView.hidden = YES;
}


#pragma mark - 选择城市按钮右边的红色按钮
static BOOL click1 = NO;
- (IBAction)chargeCityRightBtnClick:(id)sender {
    if (click1 == NO) {
        self.tableView.hidden = NO;
        click1 = YES;
    }else{
        self.tableView.hidden = YES;
        click1 = NO;
    }

}
#pragma mark - 选择城市按钮点击事件
- (IBAction)chargeBtnClick:(id)sender {
    self.tableView.hidden = NO;
}

static bool agree = YES;
#pragma mark - 是否同意协议的小框框点击事件
- (IBAction)agreeOrNoBtnClick:(id)sender {
    
    if (agree) {//不同意
        [self.agreeOrNoBtn setBackgroundImage:[UIImage imageNamed:@"noagree-sign"] forState:UIControlStateNormal];
        self.agreeSever = NO;
        agree = NO;
    }else{//同意
        [self.agreeOrNoBtn setBackgroundImage:[UIImage imageNamed:@"agree-sign"] forState:UIControlStateNormal];
        self.agreeSever = YES;
        agree = YES;
    }
}

#pragma mark - 服务协议按钮点击事件
- (IBAction)severTextBtnClick:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    severceDeal * vc = [sb instantiateViewControllerWithIdentifier:@"severceDeal"];
    vc.identify = @"0";
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 确定按钮点击事件
- (IBAction)okBtnClick:(id)sender {
    
    if (![self.pwdField.text isEqualToString:self.okPwdField.text]) {
        [MBProgressHUD showError:@"两次密码输入不一致!"];
        return;
    }
    
    if (self.pwdField.text.length == 0) {
        [MBProgressHUD showError:@"密码不能为空"];
        return;
    }
    
    if (self.agreeSever == NO) {
        [MBProgressHUD showError:@"请仔细阅读并同意相关协议!"];
        return;
    }
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    NSString * str = ksignStr;

    if (self.model.ciId == nil) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"请选择城市!"];
        return;
    }

    NSDictionary *parameter = @{@"loginName":self.phone,@"pwd":self.okPwdField.text,@"cid":self.model.ciId,@"regFrom":@1};//regFrom：注册来源，0安卓 1苹果 2后台

    if (self.friendPhoneField.text.length == 11) {
        parameter = @{@"loginName":self.phone,@"pwd":[self md5:self.okPwdField.text],@"cid":self.model.ciId,@"linkPhone":self.friendPhoneField.text,@"regFrom":@1};
    }

    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:str parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {

        [MBProgressHUD hideHUDForView:self.view animated:YES];

        if ([responseObject[@"code"] isEqual:@(0)]) {
            [MBProgressHUD showSuccess:@"注册成功"];
            
            //保存登录用户的数据
            Account * account = [Account accountWithDict:responseObject[@"data"][0]];
            [[NSUserDefaults standardUserDefaults]setObject:account.gold forKey:@"gold"];
            [[NSUserDefaults standardUserDefaults]setObject:account.silverCoin forKey:@"silverCoin"];
            [[NSUserDefaults standardUserDefaults]setObject:account.diamonds forKey:@"diamonds"];
            [AccountTool saveAccount:account];
            
            [MobClick profileSignInWithPUID:[NSString stringWithFormat:@"%@",account.uiId]];//用户浏览量统计
            
            [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"registOK"];//切换账号时把签到时间置空
            
            //清空奖兜跳转登陆界面的标志
            [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"haveJumped"];
            
            [NSTimer scheduledTimerWithTimeInterval:1.2 target:self selector:@selector(JumpToRootVC) userInfo:nil repeats:NO];
        }else{
            [MBProgressHUD showError:responseObject[@"msg"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"网络加载失败!"];
    }];
}
-(void)JumpToRootVC{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark - MD5密码加密
-(NSString *)md5:(NSString *)str {
    
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (unsigned int)strlen(cStr), result );
    
    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}


@end
